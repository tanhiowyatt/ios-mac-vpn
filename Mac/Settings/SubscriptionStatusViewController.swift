import Cocoa

class SubscriptionStatusViewController: NSViewController {

    @IBOutlet weak var countdownLabel: NSTextField!
    @IBOutlet weak var promoCodeField: NSTextField!
    @IBOutlet weak var promoCodeButton: NSButton!

    let dateFormatter = DateFormatter()
    private let userDefaults = UserDefaults.standard
    private let subscriptionEndTimeKey = "subscriptionEndTime"
    private let accessGrantedKey = "accessGranted"

    var subscriptionEndTime: Date? {
        get {
            return userDefaults.object(forKey: subscriptionEndTimeKey) as? Date
        }
        set {
            userDefaults.set(newValue, forKey: subscriptionEndTimeKey)
            userDefaults.synchronize()
        }
    }

    var accessGranted: Bool {
        get {
            return userDefaults.bool(forKey: accessGrantedKey)
        }
        set {
            userDefaults.set(newValue, forKey: accessGrantedKey)
            userDefaults.synchronize()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Subscription Status"
        countdownLabel.isHidden = true
        promoCodeButton.target = self
        promoCodeButton.action = #selector(checkPromoCode)
        if let subscriptionEndTime = subscriptionEndTime, subscriptionEndTime > Date() {
            countdownLabel.isHidden = false
            updateCountdown()
        }
    }

    func updateCountdown() {
        guard let subscriptionEndTime = subscriptionEndTime else { return }
        let timeRemaining = subscriptionEndTime.timeIntervalSinceNow
        let days = Int(timeRemaining / 86400)
        let hours = Int((timeRemaining % 86400) / 3600)
        let minutes = Int((timeRemaining % 3600) / 60)
        let seconds = Int(timeRemaining % 60)
        countdownLabel.stringValue = "Subscription ends in: \(days) days, \(hours) hours, \(minutes) minutes, \(seconds) seconds"
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
        if Date() >= subscriptionEndTime {
            dropVPNTunnel()
            showSubscriptionEndedNotification()
        }
    }

    @objc func checkPromoCode() {
        guard let promoCode = promoCodeField.stringValue else { return }
        guard let url = URL(string: "https://example.com/promo_code/validation") else { return }
        var request = URLRequest(url: url, cachePolicy:.useProtocolCachePolicy)
        request.httpMethod = "POST"
        request.httpBody = "promo_code=\(promoCode)".data(using:.utf8)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error validating promo code: \(error)")
                return
            }
            guard let data = data else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let isValid = json as? [String: Bool], isValid["is_valid"] == true {
                    self.grantAccess()
                    self.updateSubscriptionEndTime()
                } else {
                    self.displayError("Invalid promo code")
                }
            } catch {
                print("Error parsing JSON: \(error)")
            }
        }.resume()
    }

    func grantAccess() {
        countdownLabel.isHidden = false
        updateCountdown()
        accessGranted = true
        let alertController = NSAlert()
        alertController.messageText = "Success"
        alertController.informativeText = "You have successfully redeemed your promo code and gained access to premium content."
        let okButton = alertController.addButton(withTitle: "OK")
        okButton.keyEquivalent = "\r"
        alertController.runModal()
    }

    func updateSubscriptionEndTime() {
        subscriptionEndTime = Date().addingTimeInterval(30 * 24 * 60 * 60)
    }

    func dropVPNTunnel() {
        print("VPN tunnel dropped")
        VPNManager.shared.stopVPNTunnel()
    }

    func showSubscriptionEndedNotification() {
        print("Subscription has ended, please buy a new one")
        let buyNewSubscriptionView = BuyNewSubscriptionView()
        buyNewSubscriptionView.frame = view.bounds
        view.addSubview(buyNewSubscriptionView)
    }

    func displayError(_ message: String) {
        print("Error: \(message)")
    }
}

class BuyNewSubscriptionView: NSView {

    override init(frame: NSRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        backgroundColor =.white
        let label = NSTextField()
        label.stringValue = "Your subscription has ended. Please buy a new one to continue using our service."
        label.alignment =.center
        label.font =.systemFont(ofSize: 17)
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        let buyButton = NSButton()
        buyButton.title = "Buy New Subscription"
        buyButton.bezelStyle =.rounded
        buyButton.target = self
        buyButton.action = #selector(buyNewSubscription)
        addSubview(buyButton)
        buyButton.translatesAutoresizingMaskIntoConstraints = false
        buyButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        buyButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20).isActive = true
    }

    @objc func buyNewSubscription() {
        if let telegramURL = URL(string: "tg://resolve?domain=syntlabs_vpn_bot") {
            if NSWorkspace.shared.open(telegramURL) {
                // URL opened successfully
            } else {
                if let browserURL = URL(string: "https://t.me/syntlabs_vpn_bot") {
                    NSWorkspace.shared.open(browserURL)
                }
            }
        }
    }
}