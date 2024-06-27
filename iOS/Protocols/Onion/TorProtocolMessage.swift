import Foundation

class TorProtocolMessage: Codable {
    let type: MessageType
    let circuitId: UUID
    let nodeId: String?

    enum MessageType: String, Codable {
        case create
        case createCell
        case destroy
    }

    init(type: MessageType, circuitId: UUID, nodeId: String? = nil) {
        self.type = type
        self.circuitId = circuitId
        self.nodeId = nodeId
    }
}
