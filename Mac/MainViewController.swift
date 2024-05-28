import Cocoa
import CFNetwork
import NetworkExtension

class MyViewController: NSViewController {

    let backgroundImage = NSImage(named: "backgroundImage")
    @IBOutlet var buttons: [NSButton]!
    @IBOutlet var textViews: [NSTextView]!
    @IBOutlet var customViews: [NSView]!
    let keychain = KeychainSwift()
    let userDefaults = UserDefaults.standard
    let vpnManager = VPNManager(password: "mypassword")

    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer?.contents = backgroundImage
        setupButtons()
        setupTextViews()
        setupCustomViews()
        checkSubscriptionStatus()
    }

    func setupButtons() {
        for (index, button) in buttons.enumerated() {
            button.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(button)
            NSLayoutConstraint.activate([
                button.topAnchor.constraint(equalTo: view.topAnchor, constant: 20 + CGFloat(index) * 50),
                button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                button.widthAnchor.constraint(equalToConstant: 40),
                button.heightAnchor.constraint(equalToConstant: 40)
            ])
            button.image = NSImage(named: "button\(index + 1)")
            button.tag = index + 1
            button.target = self
            button.action = #selector(buttonTapped(_:))
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
            textView.string = "Text View \(index + 1)"
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
            let icon = NSImageView(image: NSImage(named: "icon\(index + 1)"))
            icon.frame = CGRect(x: 10, y: 10, width: 20, height: 20)
            customView.addSubview(icon)
            let label = NSTextField(labelWithString: "Custom View \(index + 1)")
            label.frame = CGRect(x: 40, y: 10, width: 100, height: 20)
            customView.addSubview(label)
        }
    }

    @objc func buttonTapped(_ sender: NSButton) {
        switch sender.tag {
        case 1:
            if userDefaults.bool(forKey: "accessGranted") {
                startServerConnection()
            } else {
                print("Access denied")
            }
        case 2, 3, 4:
            popViewController(sender.tag)
        default:
            print("Unknown button tapped")
        }
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
        case 2:
            let viewController2 = ViewController2()
            presentAsModalWindow(viewController2)
        case 3:
            let viewController3 = ViewController3()
            presentAsModalWindow(viewController3)
        case 4:
            let viewController4 = ViewController4()
            presentAsModalWindow(viewController4)
        default:
            print("Invalid tag for ViewController")
        }
    }

    func checkSubscriptionStatus() {
        if let expirationTime = userDefaults.object(forKey: "subscriptionExpirationTime") as? Date,
           expirationTime < Date() {
            let buySubscriptionViewController = BuySubscriptionViewController()
            presentAsModalWindow(buySubscriptionViewController)
        }
    }

    func processData(_ data: Data) {
        vpnManager.startVPN()
    }

    func presentAsModalWindow(_ viewController: NSViewController) {
        let windowController = NSWindowController(window: NSWindow(contentViewController: viewController))
        windowController.window?.level =.mainMenu
        windowController.showWindow(nil)
    }
}