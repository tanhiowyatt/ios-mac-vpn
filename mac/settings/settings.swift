import Cocoa

class SettingsViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    @IBOutlet weak var tableView: NSTableView!
    let rows = [
        "User Info",
        "Subscription Status",
        "General",
        "Protocols",
        "Language",
        "Support",
        "Privacy Policy",
        "About Us",
        "Log Out"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Settings"

        tableView.dataSource = self
        tableView.delegate = self
    }

    func numberOfRows(in tableView: NSTableView) -> Int {
        return rows.count
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("Cell"), owner: self) as? NSTableCellView
        cellView?.textField?.stringValue = rows[row]
        return cellView
    }

    func tableViewSelectionDidChange(_ notification: Notification) {
        let selectedRow = tableView.selectedRow
        switch selectedRow {
        case 0:
            let userInfoViewController = UserInfoViewController()
            self.present(userInfoViewController, animator:.default)
        case 1:
            let subscriptionStatusViewController = SubscriptionStatusViewController()
            self.present(subscriptionStatusViewController, animator:.default)
        case 2:
            let generalViewController = GeneralViewController()
            self.present(generalViewController, animator:.default)
        case 3:
            let protocolsViewController = ProtocolsViewController()
            self.present(protocolsViewController, animator:.default)
        case 4:
            let languageViewController = LanguageViewController()
            self.present(languageViewController, animator:.default)
        case 5:
            let supportViewController = SupportViewController()
            self.present(supportViewController, animator:.default)
        case 6:
            let privacyPolicyViewController = PrivacyPolicyViewController()
            self.present(privacyPolicyViewController, animator:.default)
        case 7:
            let aboutUsViewController = AboutUsViewController()
            self.present(aboutUsViewController, animator:.default)
        case 8:
            showLogoutAlert()
        default:
            break
        }
    }

    func showLogoutAlert() {
        let alert = NSAlert()
        alert.messageText = "Log Out"
        alert.informativeText = "Are you sure you want to log out?"
        alert.addButton(withTitle: "Log Out")
        alert.addButton(withTitle: "Cancel")
        let response = alert.runModal()
        if response ==.alertFirstButtonReturn {
            logout()
        }
    }

    func logout() {
        // Disconnect from VPN server
        VPNManager.shared.stopVPN()

        // Reset VPN configurations to default
        VPNManager.shared.vpnManager.removeFromPreferences { error in
            if let error = error {
                print("Error removing VPN preferences: \(error)")
                return
            }
        }

        // Clear user data
        UserDefaults.standard.removeObject(forKey: "username")
        UserDefaults.standard.removeObject(forKey: "password")

        // Show login screen
        let loginViewController = LoginViewController()
        self.present(loginViewController, animator:.default)
    }
}