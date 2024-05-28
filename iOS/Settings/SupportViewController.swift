import UIKit

class SupportViewController: UIViewController {

    @IBOutlet weak var supportTextLabel: UILabel!
    @IBOutlet weak var telegramButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Support"
        supportTextLabel.text = "If you have any questions or issues, please contact us through Telegram or Email."
        telegramButton.setTitle("Telegram", for:.normal)
        emailButton.setTitle("Email", for:.normal)
    }
}
