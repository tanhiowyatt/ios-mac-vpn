
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var navigationController: UINavigationController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()

        let viewController = AbstractViewController()
        viewController.updateUI(forIndex: 0)
        navigationController = UINavigationController(rootViewController: viewController)
        window?.rootViewController = navigationController

        return true
    }
}