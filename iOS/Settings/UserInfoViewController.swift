import UIKit

class UserInfoViewController: UIViewController {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernickNameLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "User Info"
        userImageView.layer.cornerRadius = userImageView.frame.size.width / 2
        userImageView.clipsToBounds = true
        usernickNameLabel.text = "Username"
        editButton.setTitle("Edit", for:.normal)
    }
}
