import UIKit

class ProtocolsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    let protocols = ["AmneziaWG Protocol", "Xray Protocol", "ShadowSocks Protocol", "Cloak Protocol"]

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
}
