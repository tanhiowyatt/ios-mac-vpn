import Cocoa

class SupportViewController: NSViewController {

    @IBOutlet weak var supportTextLabel: NSTextField!
    @IBOutlet weak var telegramButton: NSButton!
    @IBOutlet weak var emailButton: NSButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Support"

        supportTextLabel.stringValue = "If you have any questions or issues, please contact us through Telegram or Email."
        telegramButton.title = "Telegram"
        emailButton.title = "Email"
    }
}