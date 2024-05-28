import UIKit

class AboutUsViewController: UIViewController {

    @IBOutlet weak var aboutUsTextLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "About Us"
        aboutUsTextLabel.text = "This is a sample app for demonstrating VPN functionality."
    }
}
