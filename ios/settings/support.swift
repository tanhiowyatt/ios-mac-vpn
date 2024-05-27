import UIKit

// This class is a custom subclass of UIViewController, which is used to manage the Support view in the application.
class SupportViewController: UIViewController {

    // The @IBOutlet keyword is used to create a reference from a storyboard to a property in a class.
    // This property is a weak reference to a UILabel object, which is used to display a message to the user about how they can get support.
    @IBOutlet weak var supportTextLabel: UILabel!

    // This property is a weak reference to a UIButton object, which is used to open Telegram when the user taps on it.
    @IBOutlet weak var telegramButton: UIButton!

    // This property is a weak reference to a UIButton object, which is used to open the Mail app when the user taps on it.
    @IBOutlet weak var emailButton: UIButton!

    // This method is called when the view controller's view is about to be added to a view hierarchy.
    // It is a good place to set up the user interface and configure the initial state of the view.
    override func viewDidLoad() {
        super.viewDidLoad()

        // This line of code sets the title of the navigation bar to "Support".
        title = "Support"

        // This line of code sets the text of the supportTextLabel to a message about how the user can get support.
        supportTextLabel.text = "If you have any questions or issues, please contact us through Telegram or Email."

        // This line of code sets the title of the telegramButton to "Telegram" for the normal state.
        telegramButton.setTitle("Telegram", for:.normal)

        // This line of code sets the title of the emailButton to "Email" for the normal state.
        emailButton.setTitle("Email", for:.normal)
    }
}
