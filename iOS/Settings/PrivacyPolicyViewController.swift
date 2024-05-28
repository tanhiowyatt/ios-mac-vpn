import UIKit

class PrivacyPolicyViewController: UIViewController {

    @IBOutlet weak var privacyPolicyTextLabel: UILabel!
    @IBOutlet weak var linkButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Privacy Policy"
        privacyPolicyTextLabel.text = "Our privacy policy can be found at:"
        linkButton.setTitle("https://example.com/privacy-policy", for:.normal)
    }
}
