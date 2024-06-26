import Foundation
import CryptoKit

class TorManager {
    let torClient: TorClient
    let urlSession: URLSession
    let circuitManager: CircuitManager

    enum TorManagerError: Error {
        case invalidURL
    }

    init(torClient: TorClient, urlSession: URLSession = URLSession.shared, circuitManager: CircuitManager) {
        self.torClient = torClient
        self.urlSession = urlSession
        self.circuitManager = circuitManager
    }

    func routeTrafficThroughTor() {
        circuitManager.createNewCircuit { [weak self] circuit in
            guard let self = self else { return }
            self.sendRequestThroughCircuit(circuit)
        }
    }

    func sendRequestThroughCircuit(_ circuit: Circuit) {
        guard let url = URL(string: "https://example.com") else {
            print("Invalid URL")
            return
        }
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60.0)
        request.httpMethod = "GET"
        let task = urlSession.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            if let error = error {
                print("Error: \(error)")
                return
            }
            guard let data = data else {
                print("No data received")
                return
            }
            do {
                let decryptedData = try self.decryptData(using: data, circuit: circuit)
                self.processDecryptedData(decryptedData)
            } catch {
                print("Decryption error: \(error)")
            }
        }
        task.resume()
    }

    func decryptData(using data: Data, circuit: Circuit) throws -> Data {
        return try torClient.decrypt(data: data, using: circuit)
    }

    func processDecryptedData(_ data: Data) {
        print("Decrypted data: \(data)")
    }
}
