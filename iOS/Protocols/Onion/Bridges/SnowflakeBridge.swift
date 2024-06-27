import Foundation

class SnowflakeBridge: Bridge {
    let address: String
    let encryptor: Encryptor
    let socket: Socket

    init() {
        address = "snowflake.torproject.net"
        encryptor = Encryptor()
        socket = Socket(address: address, port: 443)
    }

    func connect(completion: @escaping (Result<Void, Error>) -> Void) {
        socket.connect(address, port: 443) { result in
            switch result {
            case .success:
                let handshakeMessage = "snowflake: Hello, world!"
                self.sendData(handshakeMessage.data(using: .utf8)!) { result in
                    switch result {
                    case .success:
                        if let response = self.receiveData(), String(data: response, encoding: .utf8) == "snowflake: Hello, client!" {
                            print("Connected to Snowflake bridge")
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
            socket.send(encryptedData) { result in
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
        socket.receive { result in
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
