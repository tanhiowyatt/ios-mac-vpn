import Cocoa

class PrivacyPolicyViewController: NSViewController {

    @IBOutlet weak var privacyPolicyTextLabel: NSTextField!
    @IBOutlet weak var linkButton: NSButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Privacy Policy"

        privacyPolicyTextLabel.stringValue = "Our privacy policy can be found at:"
        linkButton.title = "https://example.com/privacy-policy"
    }
}