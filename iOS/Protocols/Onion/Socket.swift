import Foundation
import Network

class Socket {
    private let connection: NWConnection

    init(address: String, port: UInt16) {
        let host = NWEndpoint.Host(address)
        let port = NWEndpoint.Port(rawValue: port)!
        connection = NWConnection(host: host, port: port, using: .tcp)
        connection.start(queue: .main)
    }

    func write(_ data: Data, completion: @escaping (Result<Void, Error>) -> Void) {
        connection.send(content: data, completion: .contentProcessed { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        })
    }

    func read(completion: @escaping (Result<Data, Error>) -> Void) {
        connection.receive(minimumIncompleteLength: 1, maximumLength: 1024) { data, _, _, error in
            if let data = data {
                completion(.success(data))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
}
