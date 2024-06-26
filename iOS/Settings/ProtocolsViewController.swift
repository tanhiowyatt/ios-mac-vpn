import UIKit

class ProtocolsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TorBridgeSelectionDelegate {

    @IBOutlet weak var tableView: UITableView!

    let protocols = ["AmneziaWG", "ShadowSocks", "Tor Onion"]
    var torManager: TorManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Protocols"
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
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
            // Handle other protocol selections
            print("\(selectedProtocol) selected")
        }
    }

    private func showTorBridgeSelectionView() {
        let torBridgeSelectionView = TorBridgeSelectionView(frame: view.bounds)
        torBridgeSelectionView.delegate = self
        view.addSubview(torBridgeSelectionView)
    }

    func didChooseBridge(_ bridge: String) {
        // Pass the selected bridge to the TorManager
        torManager?.configure(with: ["bridge": bridge])
        print("Selected bridge: \(bridge)")
    }
}

