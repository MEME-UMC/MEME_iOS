//
//  SceneDelegate.swift
//  MEME
//
//  Created by 이동현 on 1/9/24.
//

import UIKit
import KakaoSDKAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let vc = getRootViewController()
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = vc
        window.makeKeyAndVisible()
        
        self.window = window
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
           if let url = URLContexts.first?.url {
               if (AuthApi.isKakaoTalkLoginUrl(url)) {
                   _ = AuthController.handleOpenUrl(url: url)
               }
           }
       }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}

extension SceneDelegate {
    func getRootViewController() -> UIViewController {
        let vc = NavigationController(nibName: nil, bundle: nil)
        vc.navigationBar.isHidden = true
        // TODO: - 로그인 여부, 아티스트 여부에 따라 rootVC 설정 필요
        var isLogin: Bool = UserDefaultManager.shared.getIsLogin() ?? false
        
        if isLogin == true {
            let role = KeyChainManager.read(forkey: .role) ?? "ARTIST"
            var isArtist: Bool = role == "ARTIST"
            
            if isArtist == true {
                let mainVC = ArtistTabBarController(
                    nibName: ArtistTabBarController.className,
                    bundle: ArtistTabBarController.bundle
                )
                vc.viewControllers = [mainVC]
            } else {
                let mainVC = ModelTabBarController(
                    nibName: ModelTabBarController.className,
                    bundle: ModelTabBarController.bundle
                )
                vc.viewControllers = [mainVC]
            }
        } else {
            let loginVC = LoginViewController(
                nibName: LoginViewController.className,
                bundle: LoginViewController.bundle
            )
            vc.viewControllers = [loginVC]
        }
    
        return vc
    }
    
    func changeRootVC(_ vc:UIViewController, animated: Bool) {
        guard let window = self.window else { return }
        let navigationcontroller = NavigationController(nibName: nil, bundle: nil)
        window.rootViewController = navigationcontroller
        navigationcontroller.viewControllers = [vc]
        UIView.transition(with: window, duration: 0.2, options: [.transitionCrossDissolve], animations: nil, completion: nil)
    }

}

