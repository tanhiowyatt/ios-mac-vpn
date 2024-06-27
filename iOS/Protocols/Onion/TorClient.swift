import Foundation

class TorClient {
    let socket: Socket
    let encryptor: Encryptor

    init(socket: Socket, encryptor: Encryptor) {
        self.socket = socket
        self.encryptor = encryptor
    }

    func establishCircuit(_ circuit: Circuit, completion: @escaping (Result<Void, Error>) -> Void) {
        let message = TorProtocolMessage(type: .create, circuitId: circuit.id)
        sendMessage(message) { result in
            switch result {
            case .success:
                self.sendCreateCells(for: circuit) { result in
                    switch result {
                    case .success:
                        completion(.success(()))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func closeCircuit(_ circuit: Circuit) {
        let message = TorProtocolMessage(type: .destroy, circuitId: circuit.id)
        sendMessage(message) { _ in }
    }

    func decrypt(data: Data, using circuit: Circuit) throws -> Data {
        guard let firstNode = circuit.nodes.first else {
            throw DecryptError.noNode
        }
        let decryptedData = try encryptor.decrypt(data: data)
        return decryptedData
    }

    private func sendMessage(_ message: TorProtocolMessage, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let data = try JSONEncoder().encode(message)
            socket.write(data) { result in
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

    private func sendCreateCells(for circuit: Circuit, completion: @escaping (Result<Void, Error>) -> Void) {
        let dispatchGroup = DispatchGroup()

        for node in circuit.nodes {
            dispatchGroup.enter()
            let message = TorProtocolMessage(type: .createCell, circuitId: circuit.id, nodeId: node.publicKey)
            sendMessage(message) { result in
                if case .failure = result {
                    completion(.failure(result as! Error))
                }
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            completion(.success(()))
        }
    }

    enum DecryptError: Error {
        case noNode
    }
}
