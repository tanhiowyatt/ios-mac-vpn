import Foundation

protocol Bridge {
    var address: String { get set }
    func connect()
    func sendData(_ data: Data)
    func receiveData() -> Data?
}
