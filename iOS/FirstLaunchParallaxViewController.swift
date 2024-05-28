import UIKit

struct ViewControllerData {
    let titleText: String
    let titleColor: UIColor
    let descriptionText: String
    let descriptionColor: UIColor
    let backgroundColor: UIColor
    let backgroundImagePath: String
    let nextButtonTitle: String
    let nextButtonColor: UIColor
    let nextButtonAction: () -> Void
    let skipButtonTitle: String
    let skipButtonColor: UIColor
    let skipButtonAction: () -> Void
}

class AbstractViewController: UIViewController {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var parallaxView: UIView!
    @IBOutlet weak var backgroundImage: UIImageView!

    var currentIndex: Int = 0
    var viewControllerData: ViewControllerData?

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI(forIndex: currentIndex)
    }

    func updateUI(forIndex index: Int) {
        guard let viewControllerData = getViewControllerData(forIndex: index) else { return }
        self.viewControllerData = viewControllerData
        title.text = viewControllerData.titleText
        title.textColor = viewControllerData.titleColor
        descriptionLabel.text = viewControllerData.descriptionText
        descriptionLabel.textColor = viewControllerData.descriptionColor
        view.backgroundColor = viewControllerData.backgroundColor
        nextButton.setTitle(viewControllerData.nextButtonTitle, for:.normal)
        nextButton.backgroundColor = viewControllerData.nextButtonColor
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for:.touchUpInside)
        skipButton.setTitle(viewControllerData.skipButtonTitle, for:.normal)
        skipButton.backgroundColor = viewControllerData.skipButtonColor
        skipButton.addTarget(self, action: #selector(skipButtonTapped), for:.touchUpInside)
        backgroundImage.image = UIImage(named: viewControllerData.backgroundImagePath)
    }

    func getViewControllerData(forIndex index: Int) -> ViewControllerData? {
        let skyBlue = UIColor(red: 0.4627, green: 0.8392, blue: 1.0, alpha: 1.0)
        let backgroundColor = UIColor.black
        let viewControllerDataArray = [
            ViewControllerData(
                titleText: "Private Browsing",
                titleColor:.white,
                descriptionText: "Keep your online actions unseen and secure from external access",
                descriptionColor:.white,
                backgroundImagePath: "first_launch_1_backgroundImage.svg",
                backgroundColor: backgroundColor,
                nextButtonTitle: "Next",
                nextButtonColor: skyBlue,
                nextButtonAction: { [weak self] in self?.nextButtonTapped() },
                skipButtonTitle: "Skip",
                skipButtonColor:.clear,
                skipButtonAction: { [weak self] in self?.skipToMainViewController() }
            ),
            ViewControllerData(
                titleText: "Unleash Boundless Access",
                titleColor:.white,
                descriptionText: "Access content from anywhere bypass geo-restrictions with ease. The whole interner is just a click away.",
                descriptionColor:.white,
                backgroundImagePath: "first_launch_2_backgroundImage.svg",
                backgroundColor: backgroundColor,
                nextButtonTitle: "Next",
                nextButtonColor: skyBlue,
                nextButtonAction: { [weak self] in self?.nextButtonTapped() },
                skipButtonTitle: "Skip",
                skipButtonColor:.clear,
                skipButtonAction: { [weak self] in self?.skipToMainViewController() }
            ),
            ViewControllerData(
                titleText: "Choose Your Path",
                titleColor:.white,
                descriptionText: "Customizable VPN protocols to suit Whether it's streaming or we've got you covered",
                descriptionColor:.white,
                backgroundImagePath: "first_launch_3_backgroundImage.svg",
                backgroundColor: backgroundColor,
                nextButtonTitle: "Next",
                nextButtonColor: skyBlue,
                nextButtonAction: { [weak self] in self?.nextButtonTapped() },
                skipButtonTitle: "Skip",
                skipButtonColor:.clear,
                skipButtonAction: { [weak self] in self?.skipToMainViewController() }
            )
        ]
        guard index >= 0 && index < viewControllerDataArray.count else { return nil }
        return viewControllerDataArray[index]
    }

    @objc func nextButtonTapped() {
        guard let viewControllerData = viewControllerData else { return }
        let nextIndex = currentIndex + 1
        if nextIndex < 4 {
            let nextViewController = AbstractViewController()
            nextViewController.currentIndex = nextIndex
            nextViewController.updateUI(forIndex: nextIndex)
            navigationController?.pushViewController(nextViewController, animated: false)
            animateTransition(to: nextViewController)
        }
    }

    @objc func skipButtonTapped() {
        let mainViewController = MainViewController()
        navigationController?.popToViewController(mainViewController, animated: true)
    }

    func animateTransition(to viewController: UIViewController?) {
        guard let viewController = viewController else { return }
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let fromView = view
        let toView = viewController.view
        let xOffset = view.bounds.width * 0.2
        let yOffset = view.bounds.height * 0.2
        let animationDuration = 0.3

        UIView.transition(with: fromView, duration: animationDuration, options:.transitionCrossDissolve, animations: {
            fromView.transform = CGAffineTransform(translationX: -xOffset, y: -yOffset)
            toView.transform = CGAffineTransform.identity
        }, completion: { _ in
            if let viewController = viewController as? AbstractViewController {
                viewController.parallaxView.transform = CGAffineTransform(translationX: -xOffset, y: -yOffset)
                UIView.animate(withDuration: animationDuration, delay: 0, options:.curveEaseInOut, animations: {
                    viewController.parallaxView.transform = CGAffineTransform.identity
                })
            }
        })
    }
}