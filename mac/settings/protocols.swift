import Cocoa

class ProtocolsViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    @IBOutlet weak var tableView: NSTableView!

    let protocols = ["Protocol 1", "Protocol 2", "Protocol 3"]

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Protocols"

        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 20.0 // adjust row height as needed
    }

    func numberOfRows(in tableView: NSTableView) -> Int {
        return protocols.count
    }

    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return protocols[row]
    }
}