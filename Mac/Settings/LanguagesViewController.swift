import Cocoa

class LanguagesViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    @IBOutlet weak var tableView: NSTableView!

    let languages = ["English", "Russian", "Spanish", "French", "Chinese"]

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Language"

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NSCell.self, forCellReuseIdentifier: "Cell")
    }

    func tableView(_ tableView: NSTableView, numberOfRowsInSection column: Int) -> Int {
        return languages.count
    }

    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return languages[row]
    }
}