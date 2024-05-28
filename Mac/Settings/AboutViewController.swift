import Cocoa

class AboutUsViewController: NSViewController {

    @IBOutlet weak var aboutUsTextLabel: NSTextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "About Us"

        aboutUsTextLabel.stringValue = "This is a sample app for demonstrating VPN functionality."
    }
}