class VPNManager {
    var vpnProtocol: VPNProtocol?

    func startVPN(protocol: String) {
        switch protocol {
        case "wireguard":
            vpnProtocol = WireGuardVPNProtocol()
        case "tor":
            let bridge = Obfs4Bridge()
            let torClient = TorClient(bridge: bridge)
            let circuitManager = CircuitManager(torClient: torClient)
            let torManager = TorManager(torClient: torClient, circuitManager: circuitManager)
            vpnProtocol = TorVPNProtocol(torManager: torManager)
        default:
            print("Unsupported protocol")
        }

        vpnProtocol?.connect { success in
            if success {
                print("VPN connected successfully")
            } else {
                print("Failed to connect VPN")
            }
        }
    }

    func stopVPN() {
        vpnProtocol?.disconnect { success in
            if success {
                print("VPN disconnected successfully")
            } else {
                print("Failed to disconnect VPN")
            }
        }
    }
}
