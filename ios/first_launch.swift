import UIKit

// Struct to hold the data needed for each ViewController
struct ViewControllerData {
    let titleText: String
    let titleColor: UIColor
    let descriptionText: String
    let descriptionColor: UIColor
    let backgroundColor: UIColor
    let backgroundImagePath: String
    let nextButtonTitle: String
    let nextButtonColor: Color
    let nextButtonAction: () -> Void
    let skipButtonTitle: String
    let skipButtonColor: Color
    let skipButtonAction: () -> Void
}

// AbstractViewController is a subclass of UIViewController and serves as a base class for other view controllers
class AbstractViewController: UIViewController {
    // IBOutlet for the UILabel that displays the title text
    @IBOutlet var title: UILabel!
    // IBOutlet for the UILabel that displays the description text
    @IBOutlet var descriptionLabel: UILabel!
    // IBOutlet for the UIButton that triggers the button action
    @IBOutlet var nextButton: UIButton!
    // IBOutlet for the UIButton that triggers the skip action
    @IBOutlet var skipButton: UIButton!
    // IBOutlet for the UIView that creates the parallax effect
    @IBOutlet var parallaxView: UIView!
    // IBOutlet for the UIImage
    @IBOutlet var backgroundImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Call the updateUI function to update the user interface for the current index
        updateUI(forIndex: 0)
    }

    // Function to update the user interface for the specified index
    func updateUI(forIndex index: Int) {
        // Set the current index to the specified index
        currentIndex = index
        // Get the ViewControllerData for the current index
        let viewControllerData = getViewControllerData(forIndex: index)
        // Set the descriptionText property to the descriptionText of the ViewControllerData
        title.text = viewController.titleText
        title.textColor = viewController.titleColor
        descriptionLabel.text = viewControllerData.descriptionText
        descriptionLabel.textColor = viewControllerData.descriptionColor
        // Set the backgroundColor property to the backgroundColor of the ViewControllerData
        view.backgroundColor = viewControllerData.backgroundColor

        nextButton.setTitle(viewControllerData.nextButtonTitle, forState: UIControlState.Normal)
        nextButton.backgroundColor = viewControllerData.nextButtonColor
        nextButton.addTarget(self, action: viewControllerData.nextButtonAction, forControlEvents: UIControlEvents.TouchUpInside)

        skipButton.setTitle(viewControllerData.skipButtonTitle, forState: UIControlState.Normal)
        skipButton.backgroundColor = viewControllerData.skipButtonColor
        skipButton.addTarget(self, action: viewControllerData.skipButtonAction, forControlEvents: UIControlEvents.TouchUpInside)

        backgroundImage.image = UIImage(named:viewControllerData.backgroundImagePath)
    }

    // Function to get the ViewControllerData for the specified index
    func getViewControllerData(forIndex index: Int) -> ViewControllerData {
        // Array of ViewControllerData objects
        let skyBlue = Color(red: 0.4627, green: 0.8392, blue: 1.0)
        let backgroundColor = .black
        let viewControllerDataArray = [
            ViewControllerData(
                titleText: "Private Browsing",
                titleColor: .white,
                descriptionText: "Keep your online actions unseen and secure from external access",
                descriptionColor: .white,
                backgroundImagePath: "first_launch_1_backgroundImage.svg",
                backgroundColor: backgroundColor,
                nextButtonTitle: "Next",
                nextButtonColor: skyBlue,
                nextButtonAction: { [weak self] in self?.nextButtonTapped() },
                skipButtonTitle: "Skip",
                skipButtonColor: .clear,
                skipButtonAction: { [weak self] in self?.skipToMainViewController() }
            ),
            ViewControllerData(
                titleText: "Unleash Boundless Access",
                titleColor: .white,
                descriptionText: "Access content from anywhere bypass geo-restrictions with ease. The whole interner is just a click away.",
                descriptionColor: .white,
                backgroundImagePath: "first_launch_2_backgroundImage.svg",
                backgroundColor: backgroundColor,
                nextButtonTitle: "Next",
                nextButtonColor: skyBlue,
                nextButtonAction: { [weak self] in self?.nextButtonTapped() },
                skipButtonTitle: "Skip",
                skipButtonColor: .clear,
                skipButtonAction: { [weak self] in self?.skipToMainViewController() }
            ),
            ViewControllerData(
                titleText: "Choose Your Path",
                titleColor: .white,
                descriptionText: "Customizable VPN protocols to suit Whether it's streaming or we've got you covered",
                descriptionColor: .white,
                backgroundImagePath: "first_launch_3_backgroundImage.svg",
                backgroundColor: backgroundColor,
                nextButtonTitle: "Next",
                nextButtonColor: skyBlue,
                nextButtonAction: { [weak self] in self?.nextButtonTapped() },
                skipButtonTitle: "Skip",
                skipButtonColor: .clear,
                skipButtonAction: { [weak self] in self?.skipToMainViewController() }
            )
        ]
        // Return the ViewControllerData object at the specified index
        return viewControllerDataArray[index]
    }

    // Function that is triggered when the button is tapped
    @objc func buttonTapped() {
        // If the buttonAction property is not nil, perform the specified action
        if let action = buttonAction, let selector = NSSelectorFromString(action) {
            perform(selector)
        }
    }

    // Function that is triggered when the "Next" button is tapped
    func nextButtonTapped() {
        // Calculate the index of the next ViewController
        let nextIndex = currentIndex + 1
        // If the next index is less than 4, create a new instance of AbstractViewController, update its user interface for the next index, and push it onto the navigation stack. Animate the transition to the new ViewController.
        if nextIndex < 4 {
            let nextViewController = AbstractViewController()
            nextViewController.updateUI(forIndex: nextIndex)
            navigationController?.pushViewController(nextViewController, animated: false)
            animateTransition(to: nextViewController)
        }
    }

    // Function to skip to the MainViewController
    func skipToMainViewController() {
        // Create a new instance of MainViewController and pop to it on the navigation stack
        let mainViewController = MainViewController()
        navigationController?.popToViewController(mainViewController, animated: true)
    }

    // Function to animate the transition to the specified ViewController
    func animateTransition(to viewController: UIViewController?) {
        // If the viewController is nil, return from the function
        guard let viewController = viewController else { return }
        // Get the width and height of the screen
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        // Get the current view and the view of the specified ViewController
        let fromView = view
        let toView = viewController.view
        // Calculate the x and y offsets for the parallax effect
        let xOffset = view.bounds.width * 0.2
        let yOffset = view.bounds.height * 0.2
        // Set the duration of the animation
        let animationDuration = 0.3
        // Animate the transition using a cross dissolve effect. Move the current view and the parallaxView of the specified ViewController to their final positions.
        UIView.transition(with: fromView, duration: animationDuration, options: .transitionCrossDissolve, animations: {
            fromView.transform = CGAffineTransform(translationX: -xOffset, y: -yOffset)
            toView.transform = CGAffineTransform.identity
        }, completion: { _ in
            // If the specified ViewController is an instance of AbstractViewController, animate the parallaxView to its final position
            if let viewController = viewController as? AbstractViewController {
                viewController.parallaxView.transform = CGAffineTransform(translationX: -xOffset, y: -yOffset)
                UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseInOut, animations: {
                    viewController.parallaxView.transform = CGAffineTransform.identity
                })
            }
        })
    }
}