//
//  LoginViewController.swift
//  MEME
//
//  Created by 이동현 on 1/9/24.
//

import UIKit
import KakaoSDKUser
import AuthenticationServices

final class LoginViewController: UIViewController {
    private let userDefaultManager = UserDefaultManager.shared
    private let authManager = AuthManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction private func kakaoLoginButtonTapped(_ sender: Any) {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk { [weak self] oauthToken, error in
                guard
                    error == nil,
                    let self = self,
                    let idToken = oauthToken?.idToken
                else {
                    print("카카오톡 로그인 에러 발생",error)
                    return
                }
                
                login(idToken: idToken, provider: .KAKAO)
            }
        } else {
            UserApi.shared.loginWithKakaoAccount { [weak self] oauthToken, error  in
                guard
                    error == nil,
                    let self = self,
                    let idToken = oauthToken?.idToken
                else {
                    print("카카오톡 로그인 에러 발생",error)
                    return
                }
                login(idToken: idToken, provider: .KAKAO)
            }
        }
    }
    
    @IBAction private func appleLoginButtonTapped(_ sender: Any) {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
          authorizationController.delegate = self
          authorizationController.presentationContextProvider = self
          authorizationController.performRequests()
    }
}

// MARK: - login 로직
extension LoginViewController {

    private func login(idToken: String, provider: SocialProvider) {
        print("===============디버깅 용 소셜 idToken, provider: \(provider.rawValue)===========")
        print(idToken)
        print("========id token 끝 ======================================================")
        userDefaultManager.saveProvider(provider.rawValue)
        userDefaultManager.saveIdToken(idToken)
        
        authManager.login(
            idToken: idToken,
            socialProvider: .KAKAO
        ) { loginResult in
            var baseVC: UIViewController
            
            switch loginResult {
            case .success(let loginDTO):
                // TODO: - 로그인 리스폰스 확정되면 수정 예정입니다! 일단 임시로 아티스트 홈으로 이동
                baseVC = ArtistTabBarController()
            case .failure(let error):
                baseVC = TermsAgreementViewController()
            }
            
            (UIApplication.shared
                .connectedScenes
                .first?
                .delegate
             as? SceneDelegate)?.changeRootVC(baseVC, animated: false)
        }
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard
            let credential = authorization.credential as? ASAuthorizationAppleIDCredential,
            let identityToken = credential.identityToken,
            let tokenString = String(data: identityToken, encoding: .utf8)
        else { return }
        
        login(idToken: tokenString, provider: .APPLE)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error.localizedDescription)
    }
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}
