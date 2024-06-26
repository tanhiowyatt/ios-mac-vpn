import Foundation

class Node: Equatable {
    let id: Int
    let address: String

    init(id: Int, address: String) {
        self.id = id
        self.address = address
    }

    static func == (lhs: Node, rhs: Node) -> Bool {
        return lhs.id == rhs.id && lhs.address == rhs.address
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
