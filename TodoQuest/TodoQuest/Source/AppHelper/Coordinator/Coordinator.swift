// MARK: - AppCoordinator Delegate Methods

extension AppCoordinator: LaunchCoordinatorDelegate {
    /// Launch에서 Main으로 화면전환을 요청하는 메소드
    func pushMainViewController() {
// MARK: - LaunchCoordinator

final class LaunchCoordinator: Coordinator {
    private let nav: UINavigationController
    weak var delegate: LaunchCoordinatorDelegate?
    
    init(nav: UINavigationController) {
        self.nav = nav
    }
    
    func start() {
        let vc = LaunchViewController()
        vc.delegate = delegate
        nav.viewControllers = [vc]
    }
}

// MARK: - MainCoordinator

final class MainCoordinator: Coordinator {
    private let nav: UINavigationController
    
    init(nav: UINavigationController) {
        self.nav = nav
    }
    
    func start() {
        let vc = MainViewController()
        nav.viewControllers = [vc]
    }
}
