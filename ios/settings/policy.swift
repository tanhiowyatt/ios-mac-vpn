import UIKit

// This class is responsible for managing the Privacy Policy view in the application
class PrivacyPolicyViewController: UIViewController {

    // This is an IBOutlet for a UILabel that will display the text for the Privacy Policy
    @IBOutlet weak var privacyPolicyTextLabel: UILabel!

    // This is an IBOutlet for a UIButton that will be used to link to the full Privacy Policy
    @IBOutlet weak var linkButton: UIButton!

    // This function is called when the view is first loaded into memory
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the title of the view to "Privacy Policy"
        title = "Privacy Policy"

        // Set the text of the privacyPolicyTextLabel to "Our privacy policy can be found at:"
        privacyPolicyTextLabel.text = "Our privacy policy can be found at:"

        // Set the title of the linkButton to the URL for the full Privacy Policy
        linkButton.setTitle("https://example.com/privacy-policy", for:.normal)
    }
}
