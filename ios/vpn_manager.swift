import CFNetwork
import NetworkExtension

class VPNManager {
    let vpnManager = NEVPNManager.shared()
    let passwordRef: Data

    init(password: String) {
        passwordRef = password.data(using:.utf8)!
    }

    func startVPN() {
        let vpnProtocol = NEVPNProtocol()
        vpnProtocol.providerBundleIdentifier = "com.example.vpn"
        vpnProtocol.serverAddress = "your-proxy-server-url.com"
        vpnProtocol.username = "username"
        vpnProtocol.passwordReference = passwordRef
        vpnProtocol.authenticationMethod =.none
        vpnProtocol.useExtendedAuthentication = true
        let chacha20Encryption = NEVPNCrypto()
        chacha20Encryption.encryptionAlgorithm =.chacha20
        chacha20Encryption.integrityAlgorithm =.poly1305
        vpnProtocol.crypto = chacha20Encryption
        vpnManager.loadFromPreferences { error in
            if let error = error {
                print("Error loading VPN preferences: \(error)")
                return
            }
            self.vpnManager.protocolConfiguration = vpnProtocol
            self.vpnManager.isOnDemandEnabled = true
            self.vpnManager.saveToPreferences { error in
                if let error = error {
                    print("Error saving VPN preferences: \(error)")
                    return
                }
                self.vpnManager.startVPNTunnel()
            }
        }
    }

    func stopVPN() {
        vpnManager.stopVPNTunnel()
    }
}
