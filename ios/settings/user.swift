import UIKit

// This class is responsible for managing and displaying the user's information
class UserInfoViewController: UIViewController {

    // An outlet for the image view that displays the user's profile picture
    @IBOutlet weak var userImageView: UIImageView!

    // An outlet for the label that displays the user's nickname
    @IBOutlet weak var usernickNameLabel: UILabel!

    // An outlet for the button that allows the user to edit their information
    @IBOutlet weak var editButton: UIButton!

    // This function is called when the view controller's view is first loaded into memory
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the title of the navigation bar
        title = "User Info"

        // Set the userImageView to be a circle by adjusting the corner radius
        userImageView.layer.cornerRadius = userImageView.frame.size.width / 2

        // Clip the image to the bounds of the image view
        userImageView.clipsToBounds = true

        // Set the default text for the nickname label
        usernickNameLabel.text = "Username"

        // Set the title for the edit button
        editButton.setTitle("Edit", for:.normal)
    }
}
