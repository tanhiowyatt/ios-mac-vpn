import Foundation

class Node {
    let publicKey: String
    let address: String

    init(publicKey: String, address: String) {
        self.publicKey = publicKey
        self.address = address
    }
}

class NodeManager {
    var nodes: [Node]

    init() {
        nodes = [Node(id: 1, address: "localhost"), Node(id: 2, address: "node2.tor")]
    }

    func getNodes() -> [Node] {
        return nodes
    }

    func addNode(_ node: Node) {
        nodes.append(node)
    }

    func removeNode(_ node: Node) {
        nodes.removeAll { $0 == node }
    }
}
