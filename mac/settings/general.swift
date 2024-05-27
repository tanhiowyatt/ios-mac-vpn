import AppKit

struct Switcher {
    let title: String
    let `switch`: NSSwitch
}

class GeneralViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var killSwitch: NSSwitch!
    @IBOutlet weak var tonProxySwitch: NSSwitch!
    @IBOutlet weak var torSwitch: NSSwitch!
    @IBOutlet weak var useSyntLabsDNSSwitch: NSSwitch!
    @IBOutlet weak var separateTunnelingSwitch: NSSwitch!

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
        tableView.register(MyTableCellView.self, forCellReuseIdentifier: "Cell")
    }

    func numberOfRows(in tableView: NSTableView) -> Int {
        return items.count
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let cell = tableView.makeView(withIdentifier: "Cell", owner: self) as? MyTableCellView else { return nil }
        let item = items[row]
        cell.textField?.stringValue = item.title
        cell.accessoryView = item.switch
        return cell
    }

    @IBAction func switchChanged(_ sender: NSSwitch) {
        guard let index = items.firstIndex(where: { $0.switch == sender }) else { return }
        let item = items[index]
        switchChanged(for: item, state: sender.state ==.on)
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
        print("Kill Switch \(state? "enabled" : "disabled")")
    }

    func tonProxySwitchAction(_ state: Bool) {
        print("Ton Proxy \(state? "enabled" : "disabled")")
    }

    func torSwitchAction(_ state: Bool) {
        if state {
            // Enable Tor onion routing
            let torConfig = TorConfig()
            torConfig.SOCKSPort = 9050
            torConfig.ControlPort = 9051
            // Use a more robust way to determine the data directory
            torConfig.DataDirectory = FileManager.default.applicationSupportDirectory.appendingPathComponent("TorData")

            do {
                let tor = try Tor(config: torConfig)
                tor.start()
                print("Tor onion routing enabled")
            } catch {
                print("Error enabling Tor onion routing: \(error)")
            }
        } else {
            // Disable Tor onion routing
            let tor = Tor.shared
            tor.stop()
            print("Tor onion routing disabled")
        }
    }

    func useSyntLabsDNSSwitchAction(_ state: Bool) {
        print("SyntLabs DNS \(state? "enabled" : "disabled")")
    }

    func separateTunnelingSwitchAction(_ state: Bool) {
        print("Separate Tunneling \(state? "enabled" : "disabled")")
    }
}

class MyTableCellView: NSTableCellView {
    @IBOutlet weak var textField: NSTextField!
}