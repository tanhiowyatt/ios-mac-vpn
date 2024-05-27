import Cocoa

class UserInfoViewController: NSViewController {

    @IBOutlet weak var userImageView: NSImageView!
    @IBOutlet weak var usernickNameLabel: NSTextField!
    @IBOutlet weak var editButton: NSButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "User Info"

        userImageView.layer?.cornerRadius = userImageView.frame.size.width / 2
        userImageView.wantsLayer = true

        usernickNameLabel.stringValue = "Username"
        editButton.title = "Edit"
    }
}