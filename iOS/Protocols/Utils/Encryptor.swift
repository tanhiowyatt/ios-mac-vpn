import Foundation
import CryptoKit

class Encryptor {
    func encrypt(data: Data) throws -> Data {
        // Example encryption logic using symmetric encryption
        let key = SymmetricKey(size: .bits256)
        let sealedBox = try AES.GCM.seal(data, using: key)
        return sealedBox.combined!
    }

    func decrypt(data: Data) throws -> Data {
        // Example decryption logic using symmetric encryption
        let key = SymmetricKey(size: .bits256)
        let sealedBox = try AES.GCM.SealedBox(combined: data)
        return try AES.GCM.open(sealedBox, using: key)
    }
}
