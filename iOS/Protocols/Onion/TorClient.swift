import Foundation
import CryptoKit

class TorClient {
    let socket: Socket
    let nodeManager: NodeManager
    let threadManager: ThreadManager
    let bridge: Bridge
    var aes: AES.GCM
    let sha256: SHA256
    var curve25519: Curve25519

    init(bridge: Bridge) {
        self.socket = Socket()
        self.nodeManager = NodeManager()
        self.threadManager = ThreadManager()
        self.bridge = bridge
        let aesKey = SymmetricKey(size: .bits256)
        self.aes = AES.GCM(key: aesKey)
        self.sha256 = SHA256()
        let privateKey = Curve25519.KeyAgreement.PrivateKey()
        let publicKey = privateKey.publicKey
        self.curve25519 = Curve25519(privateKey: privateKey, publicKey: publicKey)
    }

    func configure(with config: [String: String]) {
        bridge.address = config["bridgeAddress"] ?? "obfs4.tor"

        if let aesKeyString = config["aesKey"], let aesKeyData = Data(hexString: aesKeyString) {
            let aesKey = SymmetricKey(data: aesKeyData)
            self.aes = AES.GCM(key: aesKey)
        } else {
            print("Error: AES key not provided or invalid")
        }

        if let privateKeyString = config["curve25519PrivateKey"], let privateKeyData = Data(hexString: privateKeyString) {
            let privateKey = Curve25519.KeyAgreement.PrivateKey(rawRepresentation: privateKeyData)
            let publicKey = privateKey.publicKey
            self.curve25519 = Curve25519(privateKey: privateKey, publicKey: publicKey)
        } else {
            print("Error: Curve25519 private key not provided or invalid")
        }

        if let nodesString = config["nodes"] {
            let nodes = nodesString.split(separator: ",").compactMap { Node(id: nodeManager.nodes.count + 1, address: String($0)) }
            nodeManager.nodes = nodes
        } else {
            print("Error: Nodes not provided")
        }

        if let threadsString = config["threads"] {
            let threads = threadsString.split(separator: ",").compactMap { Thread(id: threadManager.threads.count + 1, node: Node(id: threadManager.threads.count + 1, address: String($0))) }
            threadManager.threads = threads
        } else {
            print("Error: Threads not provided")
        }
    }

    func start() {
        bridge.connect()
    }

    func createCircuit(completion: @escaping (Circuit) -> Void) {
        let nodes = nodeManager.getNodes()
        let circuit = Circuit(id: 1, nodes: nodes)
        completion(circuit)
    }

    func decrypt(data: Data, using circuit: Circuit) throws -> Data {
        let sealedBox = try AES.GCM.SealedBox(combined: data)
        let decryptedData = try aes.open(sealedBox)
        return decryptedData
    }
}
