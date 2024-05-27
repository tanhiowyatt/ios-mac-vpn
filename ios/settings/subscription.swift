import UIKit

// This class is responsible for managing and displaying the user's subscription status
class SubscriptionStatusViewController: UIViewController {

    // IBOutlet for the label that displays the countdown timer for the subscription
    @IBOutlet weak var countdownLabel: UILabel!

    // IBOutlet for the text field where the user can enter a promo code
    @IBOutlet weak var promoCodeField: UITextField!

    // IBOutlet for the button that the user can tap to check if a promo code is valid
    @IBOutlet weak var promoCodeButton: UIButton!

    // DateFormatter instance that is used to format dates
    let dateFormatter = DateFormatter()

    // UserDefaults instance that is used to store and retrieve the user's subscription information
    private let userDefaults = UserDefaults.standard

    // Key for the subscription end time in UserDefaults
    private let subscriptionEndTimeKey = "subscriptionEndTime"

    // Key for the access granted flag in UserDefaults
    private let accessGrantedKey = "accessGranted"

    // Computed property for the user's subscription end time
    var subscriptionEndTime: Date? {
        get {
            // Retrieve the subscription end time from UserDefaults
            return userDefaults.object(forKey: subscriptionEndTimeKey) as? Date
        }
        set {
            // Store the subscription end time in UserDefaults
            userDefaults.set(newValue, forKey: subscriptionEndTimeKey)
        }
    }

    // Computed property for the flag that indicates whether the user has access to premium content
    var accessGranted: Bool {
        get {
            // Retrieve the access granted flag from UserDefaults
            return userDefaults.bool(forKey: accessGrantedKey)
        }
        set {
            // Store the access granted flag in UserDefaults
            userDefaults.set(newValue, forKey: accessGrantedKey)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the title for the view controller
        title = "Subscription Status"

        // Hide the countdown label by default
        countdownLabel.isHidden = true

        // Add a target for the promo code button that calls the checkPromoCode method when the button is tapped
        promoCodeButton.addTarget(self, action: #selector(checkPromoCode), for:.touchUpInside)

        // Check if the user has a valid subscription and if so, display the countdown timer
        if let subscriptionEndTime = subscriptionEndTime, subscriptionEndTime > Date() {
            countdownLabel.isHidden = false
            updateCountdown()
        }
    }

    // This method is responsible for updating the countdown label with the time remaining in the user's subscription
    func updateCountdown() {
        guard let subscriptionEndTime = subscriptionEndTime else { return }

        // Calculate the time remaining in the user's subscription
        let timeRemaining = subscriptionEndTime.timeIntervalSinceNow
        let days = Int(timeRemaining / 86400)
        let hours = Int((timeRemaining % 86400) / 3600)
        let minutes = Int((timeRemaining % 3600) / 60)
        let seconds = Int(timeRemaining % 60)

        // Format the time remaining as a string and display it in the countdown label
        countdownLabel.text = "Subscription ends in: \(days) days, \(hours) hours, \(minutes) minutes, \(seconds) seconds"

        // Schedule a timer to call the updateCountdown method every second
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)

        // Check if the user's subscription has ended and if so, drop the VPN tunnel and display a notification
        if Date() >= subscriptionEndTime {
            dropVPNTunnel()
            showSubscriptionEndedNotification()
        }
    }

    // This method is called when the user taps the promo code button
    @objc func checkPromoCode() {
        guard let promoCode = promoCodeField.text else { return }

        // Create a URL for the endpoint that will validate the promo code
        let url = URL(string: "https://example.com/promo_code/validation")!

        // Create a URLRequest instance that will be used to make the API call
        var request = URLRequest(url: url, cachePolicy:.useProtocolCachePolicy)

        // Set the HTTP method for the request to POST
        request.httpMethod = "POST"

        // Set the HTTP body for the request to the promo code
        request.httpBody = "promo_code=\(promoCode)".data(using:.utf8)

        // Create a data task instance that will be used to make the API call
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                // If there is an error with the API call, print the error to the console
                print("Error validating promo code: \(error)")
                return
            }
            guard let data = data else { return }

            // Parse the JSON response from the API call
            let json = try! JSONSerialization.jsonObject(with: data, options: [])

            // Check if the promo code is valid and if so, grant access to the user and update the subscription end time
            if let isValid = json["is_valid"] as? Bool, isValid {
                self.grantAccess()
                self.updateSubscriptionEndTime()
            } else {
                // If the promo code is not valid, display an error message to the user
                self.displayError("Invalid promo code")
            }
        }.resume()
    }

    // This method is responsible for granting access to the user and displaying a success message
    func grantAccess() {
        countdownLabel.isAccessible = false
        updateCountdown()
        userDefaults.set(true, forKey: "accessGranted")
        let alertController = UIAlertController(title: "Success", message: "You have successfully redeemed your promo code and gained access to premium content.", preferredStyle:.alert)
        let okAction = UIAlertAction(title: "OK", style:.default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

    // This method is responsible for updating the user's subscription end time
    func updateSubscriptionEndTime() {
        subscriptionEndTime = Date().addingTimeInterval(30 * 24 * 60 * 60)
    }

    // This method is responsible for dropping the VPN tunnel
    func dropVPNTunnel() {
        print("VPN tunnel dropped")
        VPNManager.shared.stopVPNTunnel()
    }

    // This method is responsible for displaying a notification to the user when their subscription has ended
    func showSubscriptionEndedNotification() {
        print("Subscription has ended, please buy a new one")
        let buyNewSubscriptionView = BuyNewSubscriptionView()
        buyNewSubscriptionView.frame = view.bounds
        view.addSubview(buyNewSubscriptionView)
    }

    // This method is responsible for displaying an error message to the user
    func displayError(_ message: String) {
        print("Error: \(message)")
    }
}

// This class is responsible for displaying the view that prompts the user to buy a new subscription
class BuyNewSubscriptionView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // This method is responsible for setting up the view
    func setupView() {
        backgroundColor =.white
        let label = UILabel()
        label.text = "Your subscription has ended. Please buy a new one to continue using our service."
        label.textAlignment =.center
        label.font =.systemFont(ofSize: 17)
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        let buyButton = UIButton()
        buyButton.setTitle("Buy New Subscription", for:.normal)
        buyButton.setTitleColor(.white, for:.normal)
        buyButton.backgroundColor =.systemBlue
        buyButton.addTarget(self, action: #selector(buyNewSubscription), for:.touchUpInside)
        addSubview(buyButton)
        buyButton.translatesAutoresizingMaskIntoConstraints = false
        buyButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        buyButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20).isActive = true
    }

    // This method is responsible for handling the user's request to buy a new subscription
    @objc func buyNewSubscription() {
        if let telegramURL = URL(string: "tg://resolve?domain=syntlabs_vpn_bot") {
            if UIApplication.shared.canOpenURL(telegramURL) {
                // If the user has Telegram installed, open the Telegram bot to allow the user to buy a new subscription
                UIApplication.shared.open(telegramURL, options: [:], completionHandler: nil)
            } else {
                // If the user does not have Telegram installed, open the web version of the Telegram bot to allow the user to buy a new subscription
                if let browserURL = URL(string: "https://t.me/syntlabs_vpn_bot") {
                    UIApplication.shared.open(browserURL, options: [:], completionHandler: nil)
                }
            }
        }
    }
}
