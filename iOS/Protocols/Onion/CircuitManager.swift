import Foundation

class Circuit {
    let id: Int
    var nodes: [Node]

    init(id: Int, nodes: [Node]) {
        self.id = id
        self.nodes = nodes
    }
}

class CircuitManager {
    let torClient: TorClient
    var currentCircuit: Circuit?

    init(torClient: TorClient) {
        self.torClient = torClient
    }

    func createNewCircuit(completion: @escaping (Circuit) -> Void) {
        torClient.createCircuit { [weak self] circuit in
            guard let self = self else { return }
            self.currentCircuit = circuit
            completion(circuit)
        }
    }

    func extendCircuit(_ circuit: Circuit, with node: Node) {
        circuit.nodes.append(node)
    }

    func closeCircuit(_ circuit: Circuit) {
        circuit.nodes.removeAll()
    }
}
