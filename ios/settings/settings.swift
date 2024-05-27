import UIKit

// SettingsViewController class that inherits from UIViewController and conforms to UITableViewDataSource and UITableViewDelegate protocols
class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // An IBOutlet property that is connected to a UITableView in the storyboard
    @IBOutlet weak var tableView: UITableView!

    // An array of strings that represents the rows in the table view
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

    // A method that is called when the view controller's view is loaded into memory
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the title of the navigation bar
        title = "Settings"

        // Set the table view's data source and delegate to the current instance of SettingsViewController
        tableView.dataSource = self
        tableView.delegate = self

        // Register a UITableViewCell class for a specified reuse identifier
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    // A method that is called by the table view to determine the number of rows in a particular section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the count of the rows array
        return rows.count
    }

    // A method that is called by the table view to get the cell that is to be displayed for a particular row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue a reusable cell for a specified index path and reuse identifier
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        // Set the text of the cell's text label to the corresponding row in the rows array
        cell.textLabel?.text = rows[indexPath.row]

        // Return the configured cell
        return cell
    }

    // A method that is called by the table view when the user selects a row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // A switch statement that performs a different action for each row that is selected
        switch indexPath.row {
        case 0:
            // Instantiate a UserInfoViewController
            let userInfoViewController = UserInfoViewController()

            // Push the view controller onto the navigation stack
            navigationController?.pushViewController(userInfoViewController, animated: true)
        case 1:
            // Instantiate a SubscriptionStatusViewController
            let subscriptionStatusViewController = SubscriptionStatusViewController()

            // Push the view controller onto the navigation stack
            navigationController?.pushViewController(subscriptionStatusViewController, animated: true)
        case 2:
            // Instantiate a GeneralViewController
            let generalViewController = GeneralViewController()

            // Push the view controller onto the navigation stack
            navigationController?.pushViewController(generalViewController, animated: true)
        case 3:
            // Instantiate a ProtocolsViewController
            let protocolsViewController = ProtocolsViewController()

            // Push the view controller onto the navigation stack
            navigationController?.pushViewController(protocolsViewController, animated: true)
        case 4:
            // Instantiate a LanguageViewController
            let languageViewController = LanguageViewController()

            // Push the view controller onto the navigation stack
            navigationController?.pushViewController(languageViewController, animated: true)
        case 5:
            // Instantiate a SupportViewController
            let supportViewController = SupportViewController()

            // Push the view controller onto the navigation stack
            navigationController?.pushViewController(supportViewController, animated: true)
        case 6:
            // Instantiate a PrivacyPolicyViewController
            let privacyPolicyViewController = PrivacyPolicyViewController()

            // Push the view controller onto the navigation stack
            navigationController?.pushViewController(privacyPolicyViewController, animated: true)
        case 7:
            // Instantiate a AboutUsViewController
            let aboutUsViewController = AboutUsViewController()

            // Push the view controller onto the navigation stack
            navigationController?.pushViewController(aboutUsViewController, animated: true)
        case 8:
            // Call the showLogoutAlert method
            showLogoutAlert()
        default:
            break
        }
    }

    // A method that presents a logout alert to the user
    func showLogoutAlert() {
        // Instantiate a UIAlertController with a specified title, message, and preferred style
        let alert = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle:.alert)

        // Instantiate a UIAlertAction with a specified title, style, and handler
        let logoutAction = UIAlertAction(title: "Log Out", style:.destructive) { _ in
            // Call the logout method
            self.logout()
        }

        // Instantiate a UIAlertAction with a specified title, style, and handler
        let cancelAction = UIAlertAction(title: "Cancel", style:.cancel) { _ in
            // Cancel button tapped
        }

        // Add the logout and cancel actions to the alert
        alert.addAction(logoutAction)
        alert.addAction(cancelAction)

        // Present the alert to the user
        present(alert, animated: true) {
            // Alert presented
        }
    }

    // A method that logs the user out of the app
    func logout() {
        // Stop the VPN connection
        VPNManager.shared.stopVPN()

        // Remove the VPN configurations from the preferences
        VPNManager.shared.vpnManager.removeFromPreferences { error in
            if let error = error {
                print("Error removing VPN preferences: \(error)")
                return
            }
        }

        // Remove the user's username and password from the UserDefaults
        UserDefaults.standard.removeObject(forKey: "username")
        UserDefaults.standard.removeObject(forKey: "password")

        // Instantiate a LoginViewController
        let loginViewController = LoginViewController()

        // Set the view controllers of the navigation controller to the login view controller
        navigationController?.setViewControllers([loginViewController], animated: true)
    }
}
