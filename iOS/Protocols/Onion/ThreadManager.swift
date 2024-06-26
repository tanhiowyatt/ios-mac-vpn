import Foundation

struct Thread: Equatable {
    let id: Int
    let node: Node

    static func == (lhs: Thread, rhs: Thread) -> Bool {
        return lhs.id == rhs.id && lhs.node == rhs.node
    }
}

class ThreadManager {
    var threads: [Thread]

    init() {
        threads = [Thread(id: 1, node: Node(id: 1, address: "localhost")), Thread(id: 2, node: Node(id: 2, address: "node2.tor"))]
    }

    func getThreads() -> [Thread] {
        return threads
    }

    func addThread(_ thread: Thread) {
        threads.append(thread)
    }

    func removeThread(_ thread: Thread) {
        threads.removeAll { $0 == thread }
    }
}
