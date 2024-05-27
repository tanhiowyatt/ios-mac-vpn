import Cocoa

struct ViewControllerData {
    let descriptionText: String
    let backgroundColor: NSColor
    let buttonTitle: String
    let buttonAction: ActionType
}

enum ActionType {
    case next
    case skip
}

class WelcomeViewController: NSViewController {
    @IBOutlet let descriptionLabel: NSTextField!
    @IBOutlet let button: NSButton!
    @IBOutlet let parallaxView: NSView!

    let navigationStack = NSMutableArray()

    var currentIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateUI(forIndex: currentIndex)
    }

    func setupUI() {
        view.backgroundColor = .white
        parallaxView.backgroundColor = backgroundColor
        descriptionLabel.stringValue = descriptionText
        button.title = buttonTitle
        button.target = self
        switch buttonAction {
        case .next:
            button.action = #selector(nextButtonTapped)
        case .skip:
            button.action = #selector(skipToMainViewController)
        }
    }

    func updateUI(forIndex index: Int) {
        currentIndex = index
        let viewControllerData = getViewControllerData(forIndex: index)
        descriptionLabel.stringValue = viewControllerData.descriptionText
        parallaxView.backgroundColor = viewControllerData.backgroundColor
        button.title = viewControllerData.buttonTitle
        buttonAction = viewControllerData.buttonAction
    }

    func getViewControllerData(forIndex index: Int) -> ViewControllerData {
        let viewControllerDataArray = [
            ViewControllerData(
                descriptionText: "This is View Controller 1",
                backgroundColor: .red,
                buttonTitle: "Next",
                buttonAction: .next
            ),
            ViewControllerData(
                descriptionText: "This is View Controller 2",
                backgroundColor: .green,
                buttonTitle: "Next",
                buttonAction: .next
            ),
            ViewControllerData(
                descriptionText: "This is View Controller 3",
                backgroundColor: .blue,
                buttonTitle: "Next",
                buttonAction: .next
            ),
            ViewControllerData(
                descriptionText: "This is View Controller 4",
                backgroundColor: .yellow,
                buttonTitle: "Lets go!",
                buttonAction: .skip
            )
        ]
        return viewControllerDataArray[index]
    }

    @objc func nextButtonTapped() {
        let nextIndex = currentIndex + 1
        if nextIndex < viewControllerDataArray.count {
            let nextViewController = WelcomeViewController()
            nextViewController.updateUI(forIndex: nextIndex)
            navigationStack.add(nextViewController)
            if let previousViewController = navigationStack.lastObject as? NSViewController {
                navigationStack.removeObject(previousViewController)
            }
            presentViewController(nextViewController, animator: nil)
            animateTransition(to: nextViewController)
        }
    }

    @objc func skipToMainViewController() {
        let mainViewController = MainViewController()
        navigationStack.removeAllObjects()
        presentViewController(mainViewController, animator: nil)
    }

    func animateTransition(to viewController: NSViewController?) {
        guard let viewController = viewController else { return }
        let screenWidth = NSScreen.main?.frame.width ?? 0
        let screenHeight = NSScreen.main?.frame.height ?? 0

        let fromView = view
        let toView = viewController.view

        let xOffset = view.bounds.width * 0.2
        let yOffset = view.bounds.height * 0.2
        let animationDuration = 0.3

        NSAnimationContext.runAnimationGroup({ context in
            context.duration = animationDuration
            context.timingFunction = .easeInOut
            fromView.animator().alphaValue = 0
            toView.animator().alphaValue = 1
        }) {
            if let viewController = viewController as? WelcomeViewController {
                viewController.parallaxView.animator().transform = CGAffineTransform(translationX: -xOffset, y: -yOffset)
                NSAnimationContext.runAnimationGroup({ context in
                    context.duration = animationDuration
                    context.timingFunction = .easeInOut
                    viewController.parallaxView.animator().transform = CGAffineTransform.identity
                })
            }
        }
    }
}
