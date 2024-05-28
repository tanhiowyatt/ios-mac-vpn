import UIKit

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = rows[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let userInfoViewController = UserInfoViewController()
            navigationController?.pushViewController(userInfoViewController, animated: true)
        case 1:
            let subscriptionStatusViewController = SubscriptionStatusViewController()
            navigationController?.pushViewController(subscriptionStatusViewController, animated: true)
        case 2:
            let generalViewController = GeneralViewController()
            navigationController?.pushViewController(generalViewController, animated: true)
        case 3:
            let protocolsViewController = ProtocolsViewController()
            navigationController?.pushViewController(protocolsViewController, animated: true)
        case 4:
            let languageViewController = LanguageViewController()
            navigationController?.pushViewController(languageViewController, animated: true)
        case 5:
            let supportViewController = SupportViewController()
            navigationController?.pushViewController(supportViewController, animated: true)
        case 6:
            let privacyPolicyViewController = PrivacyPolicyViewController()
            navigationController?.pushViewController(privacyPolicyViewController, animated: true)
        case 7:
            let aboutUsViewController = AboutUsViewController()
            navigationController?.pushViewController(aboutUsViewController, animated: true)
        case 8:
            showLogoutAlert()
        default:
            break
        }
    }

    func showLogoutAlert() {
        let alert = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle:.alert)
        let logoutAction = UIAlertAction(title: "Log Out", style:.destructive) { _ in
            self.logout()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style:.cancel) { _ in
        }
        alert.addAction(logoutAction)
        alert.addAction(cancelAction)
        present(alert, animated: true) {
        }
    }

    func logout() {
        VPNManager.shared.stopVPN()
        VPNManager.shared.vpnManager.removeFromPreferences { error in
            if let error = error {
                print("Error removing VPN preferences: \(error)")
                return
            }
        }
        UserDefaults.standard.removeObject(forKey: "username")
        UserDefaults.standard.removeObject(forKey: "password")
        let loginViewController = LoginViewController()
        navigationController?.setViewControllers([loginViewController], animated: true)
    }
}
