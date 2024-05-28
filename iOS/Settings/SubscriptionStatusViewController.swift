import UIKit

class SubscriptionStatusViewController: UIViewController {

    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var promoCodeField: UITextField!
    @IBOutlet weak var promoCodeButton: UIButton!
    let dateFormatter = DateFormatter()
    private let secureStorage = KeychainSwift()
    private let certificateKey = "subscriptionCertificate"
    private let accessGrantedKey = "accessGranted"

    var subscriptionEndTime: Date? {
        get {
            return secureStorage.get(certificateKey)?["endTime"] as? Date
        }
        set {
            if let newValue = newValue {
                secureStorage.set(["endTime": newValue], forKey: certificateKey)
            } else {
                secureStorage.delete(certificateKey)
            }
        }
    }

    var accessGranted: Bool {
        get {
            return secureStorage.getBool(accessGrantedKey)
        }
        set {
            secureStorage.set(newValue, forKey: accessGrantedKey)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Subscription Status"
        countdownLabel.isHidden = true
        promoCodeButton.addTarget(self, action: #selector(checkPromoCode), for:.touchUpInside)
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
        countdownLabel.text = "Subscription ends in: \(days) days, \(hours) hours, \(minutes) minutes, \(seconds) seconds"
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
        if Date() >= subscriptionEndTime {
            dropVPNTunnel()
            showSubscriptionEndedNotification()
        }
    }

    @objc func checkPromoCode() {
        guard let promoCode = promoCodeField.text else { return }
        let url = URL(string: "https://example.com/promo_code/validation")!
        var request = URLRequest(url: url, cachePolicy:.useProtocolCachePolicy)
        request.httpMethod = "POST"
        request.httpBody = "promo_code=\(promoCode)".data(using:.utf8)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error validating promo code: \(error)")
                return
            }
            guard let data = data else { return }
            let json = try! JSONSerialization.jsonObject(with: data, options: [])
            if let isValid = json["is_valid"] as? Bool, isValid {
                self.grantAccess()
                self.updateSubscriptionEndTime()
            } else {
                self.displayError("Invalid promo code")
            }
        }.resume()
    }

    func grantAccess() {
        countdownLabel.isHidden = false
        updateCountdown()
        accessGranted = true
        let alertController = UIAlertController(title: "Success", message: "You have successfully redeemed your promo code and gained access to premium content.", preferredStyle:.alert)
        let okAction = UIAlertAction(title: "OK", style:.default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

    func updateSubscriptionEndTime() {
        let certificate = SubscriptionCertificate(endTime: Date().addingTimeInterval(30 * 24 * 60 * 60))
        let certificateData = try! JSONEncoder().encode(certificate)
        secureStorage.set(certificateData, forKey: certificateKey)
        subscriptionEndTime = certificate.endTime
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

class SubscriptionCertificate: Codable {
    let endTime: Date?

    init(endTime: Date?) {
        self.endTime = endTime
    }
}

class BuyNewSubscriptionView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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

    @objc func buyNewSubscription() {
        if let telegramURL = URL(string: "tg://resolve?domain=syntlabs_vpn_bot") {
            if UIApplication.shared.canOpenURL(telegramURL) {
                UIApplication.shared.open(telegramURL, options: [:], completionHandler: nil)
            } else {
                if let browserURL = URL(string: "https://t.me/syntlabs_vpn_bot") {
                    UIApplication.shared.open(browserURL, options: [:], completionHandler: nil)
                }
            }
        }
    }
}