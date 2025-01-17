/*
 * Copyright (c) 2017 Adventech <info@adventech.io>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import AsyncDisplayKit
import AuthenticationServices
import GoogleSignIn
import UIKit

class LoginController: ASDKViewController<ASDisplayNode>, LoginControllerProtocol {
    weak var loginView: LoginView? { return node as? LoginView }
    var presenter: LoginPresenterProtocol?

    override init() {
        super.init(node: LoginView())

        loginView?.anonymousButton.addTarget(self, action: #selector(loginAction(sender:)), forControlEvents: .touchUpInside)
        loginView?.googleButton.addTarget(self, action: #selector(loginAction(sender:)), forControlEvents: .touchUpInside)
        self.addAppleSignInButtonTarget()

        // GIDSignIn.sharedInstance()?.presentingViewController = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("storyboards are incompatible with truth and beauty")
    }
    
    func addAppleSignInButtonTarget() {
        if #available(iOS 13.0, *) {
            (loginView?.signInWithAppleButton?.view as? ASAuthorizationAppleIDButton)?.addTarget(self, action: #selector(appleSignInTapped), for: .touchUpInside)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.configure()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *) {
            if UIApplication.shared.applicationState != .background && self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                self.view.backgroundColor = AppStyle.Base.Color.background
                self.loginView?.configureStyles()
                self.loginView?.setNeedsLayout()
                self.addAppleSignInButtonTarget()
            }
        }
    }

    @objc func loginAction(sender: LoginButton) {
        switch sender.type {
        case .google:
            presenter?.loginActionGoogle()
        case .anonymous:
            presenter?.loginActionAnonymous()
        }
    }
    
    @available(iOS 13, *)
    @objc func appleSignInTapped() {
        presenter?.loginActionApple()
    }
}
