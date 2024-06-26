import Foundation
import CryptoKit

class Curve25519 {
    let privateKey: Curve25519.KeyAgreement.PrivateKey
    let publicKey: Curve25519.KeyAgreement.PublicKey

    init(privateKey: Curve25519.KeyAgreement.PrivateKey, publicKey: Curve25519.KeyAgreement.PublicKey) {
        self.privateKey = privateKey
        self.publicKey = publicKey
    }
}
