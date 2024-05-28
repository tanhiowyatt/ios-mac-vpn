import UIKit

struct Switcher {
    let title: String
    let `switch`: UISwitch
}

class GeneralViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tonProxySwitch: UISwitch!
    @IBOutlet weak var useSyntLabsDNSSwitch: UISwitch!

    let items = [
        Switcher(title: "Ton Proxy", switch: tonProxySwitch),
        Switcher(title: "Use SyntLabs DNS", switch: useSyntLabsDNSSwitch)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "General"
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item = items[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryView = item.switch
        return cell
    }

    @IBAction func switchChanged(_ sender: UISwitch) {
        guard let index = items.firstIndex(where: { $0.switch == sender }) else { return }
        let item = items[index]
        switchChanged(for: item, state: sender.isOn)
    }

    func switchChanged(for item: Switcher, state: Bool) {
        switch item {
        case let item where item.switch == tonProxySwitch:
            tonProxySwitchAction(state)
        case let item where item.switch == useSyntLabsDNSSwitch:
            useSyntLabsDNSSwitchAction(state)
        default:
            break
        }
    }

    func tonProxySwitchAction(_ state: Bool) {
        print("Ton Proxy \(state? "enabled" : "disabled")")
    }

    func useSyntLabsDNSSwitchAction(_ state: Bool) {
        print("SyntLabs DNS \(state? "enabled" : "disabled")")
    }
}