import Foundation

class Socket {
    func connect(_ host: String, port: Int) {
        print("Connecting to \(host) on port \(port)")
    }

    func send(_ data: Data) {
        print("Sending data: \(data)")
    }

    func receive() -> Data? {
        let response = "obfs4: Hello, client!".data(using: .utf8)
        return response
    }
}
