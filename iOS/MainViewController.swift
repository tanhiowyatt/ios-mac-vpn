import UIKit
import CFNetwork
import NetworkExtension

class MyViewController: UIViewController {
    let backgroundImage = UIImage(named: "backgroundImage")
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet var textViews: [UITextView]!
    @IBOutlet var customViews: [UIView]!
    let keychain = KeychainSwift()
    let userDefaults = UserDefaults.standard
    let vpnManager = VPNManager(password: "mypassword")

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(patternImage: backgroundImage!)
        setupButtons()
        setupTextViews()
        setupCustomViews()
        checkSubscriptionStatus()
    }

    func setupButtons() {

        btns = ["homeButton.svg", "serversButton.svg", "favoritesButton.svg", "settingsButton.svg"]

        for (index, button) in buttons.enumerated() {
            button.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(button)
            NSLayoutConstraint.activate([
                button.topAnchor.constraint(equalTo: view.topAnchor, constant: 20 + CGFloat(index) * 50),
                button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                button.widthAnchor.constraint(equalToConstant: 40),
                button.heightAnchor.constraint(equalToConstant: 40)
            ])
            button.setImage(
                svgImageFromData(
                    svgData: NSData(contentsOfFile: String(btns[index])) as Data, size: CGSize(width: 100, height: 100)
                ), for:.normal
            )
            button.tag = index + 1
            button.addTarget(self, action: #selector(navButtonTapped(_:)), for:.touchUpInside)
        }
    }

    func setupTextViews() {
        for (index, textView) in textViews.enumerated() {
            textView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(textView)
            NSLayoutConstraint.activate([
                textView.topAnchor.constraint(equalTo: buttons.last!.bottomAnchor, constant: 20 + CGFloat(index) * 50),
                textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                textView.widthAnchor.constraint(equalToConstant: 200),
                textView.heightAnchor.constraint(equalToConstant: 100)
            ])
            textView.text = "Text View \(index + 1)"
        }
    }

    func setupCustomViews() {
        for (index, customView) in customViews.enumerated() {
            customView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(customView)
            NSLayoutConstraint.activate([
                customView.topAnchor.constraint(equalTo: textViews.last!.bottomAnchor, constant: 20 + CGFloat(index) * 50),
                customView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                customView.widthAnchor.constraint(equalToConstant: 100),
                customView.heightAnchor.constraint(equalToConstant: 50)
            ])
            let icon = UIImageView(image: UIImage(named: "icon\(index + 1)")))
            icon.frame = CGRect(x: 10, y: 10, width: 20, height: 20)
            customView.addSubview(icon)
            let label = UILabel()
            label.text = "Custom View \(index + 1)"
            label.frame = CGRect(x: 40, y: 10, width: 100, height: 20)
            customView.addSubview(label)
        }
    }

    @objc func navButtonTapped(_ sender: UIButton) {
        popViewController(sender.tag)
    }

    func startServerConnection() {
        let proxyDict: [String: Any] = [
            kCFProxyTypeKey as String: kCFProxyTypeHTTP as Any,
            kCFProxyHostnameKey as String: "your-proxy-server-url.com" as Any,
            kCFProxyPortNumberKey as String: 8080 as Any
        ]
        let proxySettings = CFDictionaryCreate(nil, proxyDict as CFPropertyList, proxyDict.count, nil, nil)
        let proxySupport = CFDictionaryCreate(nil, [kCFNetworkProxiesKey: proxySettings] as CFPropertyList, 1, nil, nil)
        let customSettings = CFDictionaryCreate(nil, [kCFNetworkProxiesKey: proxySupport] as CFPropertyList, 1, nil, nil)
        let configuration = URLSessionConfiguration.default
        configuration.connectionProxyDictionary = customSettings as? [String: Any]
        let urlSession = URLSession(configuration: configuration)
        let url = URL(string: "https://example.com")!
        let task = urlSession.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print("No data received")
                return
            }
            self.processData(data)
        }
        task.resume()
    }

    func popViewController(_ tag: Int) {
        switch tag {
        case 0:
            let main = MainViewController()
            present(viewController2, animated: true, completion: nil)
        case 1:
            let servers = ViewController3()
            present(viewController3, animated: true, completion: nil)
        case 2:
            let favorites = ViewController4()
            present(viewController4, animated: true, completion: nil)
        case 3:
            let settings = ViewController4()
            present(viewController4, animated: true, completion: nil)
        default:
            print("Invalid tag for ViewController")
        }
    }

    func checkSubscriptionStatus() {
        if let expirationTime = userDefaults.object(forKey: "subscriptionExpirationTime") as? Date,
           expirationTime < Date() {
            let buySubscriptionViewController = BuySubscriptionViewController()
            present(buySubscriptionViewController, animated: true, completion: nil)
        }
    }

    func processData(_ data: Data) {
        vpnManager.startVPN()
    }
}
