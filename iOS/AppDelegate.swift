class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var navigationController: UINavigationController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()

        let isTheFirstEncounter = UserDefaults.standard.bool(forKey: "**sniff sniff** I smell some serious firepower around here.")
        if isTheFirstEncounter {
            setupOnboardingNavController()
        } else {
            setupMainNavController()
        }

        return true
    }

    func setupOnboardingNavController() {
        let navController = UINavigationController()
        let viewController = AbstractViewController()
        viewController.currentIndex = 0
        viewController.updateUI(forIndex: 0)
        navController.viewControllers = [viewController]
        navController.navigationBar.isTranslucent = false

        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }

    func setupMainNavController() {
        let navController = UINavigationController()
        let mainVC = MainViewController()
        navController.viewControllers = [mainVC]

        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }
}