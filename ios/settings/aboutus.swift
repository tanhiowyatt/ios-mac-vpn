import UIKit

// This class is a subclass of UIViewController and it's responsible for managing the About Us screen of the app.
class AboutUsViewController: UIViewController {

    // This is an IBOutlet property that's connected to a UILabel in the storyboard. It's used to display the about us text.
    @IBOutlet weak var aboutUsTextLabel: UILabel!

    // This method is called when the view controller's view is fully loaded into memory. It's a good place to set up the user interface and start data loading.
    override func viewDidLoad() {
        super.viewDidLoad()

        // This line sets the title of the navigation bar for this view controller.
        title = "About Us"

        // This line sets the text of the aboutUsTextLabel to a string that describes the purpose of the app.
        aboutUsTextLabel.text = "This is a sample app for demonstrating VPN functionality."
    }
}
