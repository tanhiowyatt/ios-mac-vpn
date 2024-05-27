import SystemConfiguration
import NetworkExtension

class VPNManager {
    let vpnManager = SCNetworkServiceController().networkServices.first(where: { $0.protocol ==.vpn })!
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

        vpnManager.setProtocol(vpnProtocol) { error in
            if let error = error {
                print("Error setting VPN protocol: \(error)")
                return
            }

            vpnManager.start() { error in
                if let error = error {
                    print("Error starting VPN: \(error)")
                    return
                }
            }
        }
    }

    func stopVPN() {
        vpnManager.stop() { error in
            if let error = error {
                print("Error stopping VPN: \(error)")
                return
            }
        }
    }
}