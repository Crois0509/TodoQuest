// MARK: - AppCoordinator Delegate Methods

extension AppCoordinator: LaunchCoordinatorDelegate {
    /// Launch에서 Main으로 화면전환을 요청하는 메소드
    func pushMainViewController() {
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
