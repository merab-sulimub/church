//Created for churchApp  (30.09.2020 )

import UIKit
import SwiftUI


class SignInViewController: CommonViewController {

    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    
    private var authManager = AuthManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func signInTapped(sender: Any) {
        guard
            let email = emailTF.text,
            let password = passwordTF.text
        
        else {
            showError(message: "'Email', 'Password' fields is missing")
            return
        }
        
        
        if !email.isValidEmail() {
            showError(message: "Email is not valid")
            return
        }
         
        showLoader()
        authManager.signIn(email: email, password: password) {[weak self] (result) in
            guard let self = self else {return}
            self.hideLoader()
            
            switch result {
            case .failure(let err):
                self.showError(message: err.getDescription())
            case .success(let _):
                DispatchQueue.main.async {
                    self.navigateToHome()
                }
            }
        }
    }
     
    private func navigateToHome() {
        self.view.window?.rootViewController = UIHostingController(rootView: TabBarView())
        self.view.window?.makeKeyAndVisible()
    }
}
