import UIKit

struct Switcher {
    let title: String
    let `switch`: UISwitch
}

class GeneralViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var killSwitch: UISwitch!
    @IBOutlet weak var tonProxySwitch: UISwitch!
    @IBOutlet weak var torSwitch: UISwitch!
    @IBOutlet weak var useSyntLabsDNSSwitch: UISwitch!
    @IBOutlet weak var separateTunnelingSwitch: UISwitch!

    let items = [
        Switcher(title: "Kill Switch", switch: killSwitch),
        Switcher(title: "Ton Proxy", switch: tonProxySwitch),
        Switcher(title: "Tor", switch: torSwitch),
        Switcher(title: "Use SyntLabs DNS", switch: useSyntLabsDNSSwitch),
        Switcher(title: "Separate Tunneling", switch: separateTunnelingSwitch)
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
        case let item where item.switch == killSwitch:
            killSwitchAction(state)
        case let item where item.switch == tonProxySwitch:
            tonProxySwitchAction(state)
        case let item where item.switch == torSwitch:
            torSwitchAction(state)
        case let item where item.switch == useSyntLabsDNSSwitch:
            useSyntLabsDNSSwitchAction(state)
        case let item where item.switch == separateTunnelingSwitch:
            separateTunnelingSwitchAction(state)
        default:
            break
        }
    }

    func killSwitchAction(_ state: Bool) {
        print("Kill Switch \((state? "enabled" : "disabled"))")
    }

    func tonProxySwitchAction(_ state: Bool) {
        print("Ton Proxy \((state? "enabled" : "disabled"))")
    }

    func torSwitchAction(_ state: Bool) {
        if state {
            let torConfig = TorConfig()
            torConfig.SOCKSPort = 9050
            torConfig.ControlPort = 9051
            torConfig.DataDirectory = "/path/to/tor/data/directory"
            do {
                let tor = try Tor(config: torConfig)
                tor.start()
                print("Tor onion routing enabled")
            } catch {
                print("Error enabling Tor onion routing: \(error)")
            }
        } else {
            let tor = Tor.shared
            tor.stop()
            print("Tor onion routing disabled")
        }
    }

    func useSyntLabsDNSSwitchAction(_ state: Bool) {
        print("SyntLabs DNS \((state? "enabled" : "disabled"))")
    }

    func separateTunnelingSwitchAction(_ state: Bool) {
        print("Separate Tunneling \((state? "enabled" : "disabled"))")
    }
}
