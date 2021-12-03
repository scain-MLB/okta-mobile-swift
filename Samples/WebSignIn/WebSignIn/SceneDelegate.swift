//
// Copyright (c) 2021-Present, Okta, Inc. and/or its affiliates. All rights reserved.
// The Okta software accompanied by this notice is provided pursuant to the Apache License, Version 2.0 (the "License.")
//
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0.
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
// WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//
// See the License for the specific language governing permissions and limitations under the License.
//

import UIKit
import WebAuthenticationUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    weak var windowScene: UIWindowScene?
    weak var signInViewController: UIViewController?
    
    func signIn() {
        guard let tabController = window?.rootViewController as? UITabBarController else { return }

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let signInController = storyboard.instantiateViewController(withIdentifier: "SignIn")
        
        signInViewController = signInController
        tabController.present(signInController, animated: false)
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        windowScene = scene
        
        NotificationCenter.default.addObserver(forName: .userChanged, object: nil, queue: .main) { notification in
            if notification.object == nil {
                self.signIn()
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        guard signInViewController == nil,
              UserManager.shared.current == nil
        else {
            return
        }
        
        DispatchQueue.main.async {
            self.signIn()
        }
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        print(URLContexts)
        do {
            try WebAuthentication.shared?.resume(with: URLContexts)
        } catch {
            print(error)
        }
    }
}
