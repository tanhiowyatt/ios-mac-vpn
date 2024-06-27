import Foundation

class Circuit {
    var nodes: [Node]
    let id: UUID

    init(nodes: [Node] = [], id: UUID = UUID()) {
        self.nodes = nodes
        self.id = id
    }

    func addNode(_ node: Node) {
        nodes.append(node)
    }

    func getNode(at index: Int) -> Node? {
        return nodes.indices.contains(index) ? nodes[index] : nil
    }
}

class CircuitManager {
    private var circuits: [UUID: Circuit] = [:]
    private let torClient: TorClient

    init(torClient: TorClient) {
        self.torClient = torClient
    }

    func createNewCircuit(completion: @escaping (Result<Circuit, Error>) -> Void) {
        let node1 = Node(publicKey: "Node1PublicKey", address: "Node1Address")
        let node2 = Node(publicKey: "Node2PublicKey", address: "Node2Address")
        let node3 = Node(publicKey: "Node3PublicKey", address: "Node3Address")

        let circuit = Circuit(nodes: [node1, node2, node3])
        circuits[circuit.id] = circuit

        torClient.establishCircuit(circuit) { result in
            switch result {
            case .success:
                completion(.success(circuit))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getCircuit(with id: UUID) -> Circuit? {
        return circuits[id]
    }

    func closeCircuit(with id: UUID) {
        guard let circuit = circuits[id] else { return }
        torClient.closeCircuit(circuit)
        circuits[id] = nil
    }
}