import UIKit

class ProtocolsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TorBridgeSelectionDelegate {

    @IBOutlet weak var tableView: UITableView!

    let torManager = TorManager(torClient: TorClient(), circuitManager: CircuitManager(), onionRouter: OnionRouter(), encryptor: Encryptor())
    let protocols = ["AmneziaWG", "ShadowSocks", "Tor Onion"]
    var torManager: TorManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Protocols"
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    func didChooseBridge(_ bridge: String) {
        torManager.routeTrafficThroughTor(using: bridge)
    }

    func showBridgeSelection() {
        let bridgeSelectionView = TorBridgeSelectionView(frame: view.bounds)
        bridgeSelectionView.delegate = self
        view.addSubview(bridgeSelectionView)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return protocols.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = protocols[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedProtocol = protocols[indexPath.row]
        if selectedProtocol == "Tor Onion" {
            showTorBridgeSelectionView()
        } else {
            print("\(selectedProtocol) selected")
        }
    }

    func didChooseBridge(_ bridge: String) {
        torManager?.configure(with: ["bridge": bridge])
        print("Selected bridge: \(bridge)")
    }
}

