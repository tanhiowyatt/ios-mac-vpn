import Foundation

class MeekAzureBridge {
    let address: String
    let encryptor: Encryptor
    let socket: Socket

    init() {
        address = "meek.azure"
        encryptor = Encryptor()
        socket = Socket(address: "meek.azure", port: 443)
    }

    func connect(completion: @escaping (Result<Void, Error>) -> Void) {
        let handshakeMessage = "meek: Hello, world!"
        sendData(handshakeMessage.data(using: .utf8)!) { result in
            switch result {
            case .success:
                self.receiveData { result in
                    switch result {
                    case .success(let response):
                        if String(data: response, encoding: .utf8) == "meek: Hello, client!" {
                            print("Connected to Meek Azure bridge")
                            completion(.success(()))
                        } else {
                            completion(.failure(BridgeError.handshakeFailed))
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func sendData(_ data: Data, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let encryptedData = try encryptor.encrypt(data: data)
            socket.write(encryptedData) { result in
                switch result {
                case .success:
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }

    func receiveData(completion: @escaping (Result<Data, Error>) -> Void) {
        socket.read { result in
            switch result {
            case .success(let encryptedData):
                do {
                    let decryptedData = try encryptor.decrypt(data: encryptedData)
                    completion(.success(decryptedData))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

enum BridgeError: Error {
    case handshakeFailed
}
