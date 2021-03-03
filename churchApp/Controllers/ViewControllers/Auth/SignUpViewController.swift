//Created for churchApp  (29.09.2020 )

import UIKit
import SwiftUI

class SignUpViewController: CommonViewController {
 
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var termsPpLabel: UILabel!
    
    private let authManager = AuthManager.shared
     
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
     
    
     
    private func setup() {
        termsPpLabel.isUserInteractionEnabled = true
        termsPpLabel.lineBreakMode = .byWordWrapping
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tappedOnLabel(_:)))
        tapGesture.numberOfTouchesRequired = 1
        termsPpLabel.addGestureRecognizer(tapGesture)
    }
     
    
    private func verify() -> [String] {
        var tmp: [String] = []
        ///todo: !? rules ?
         
        // Password check
        if let pass = passwordTF.text {
            if pass.count < 8 {
                tmp.append("This password is too short. It must contain at least 8 characters.")
            }
           } else {
            tmp.append("Password field is reqired")
        }
          
        return tmp
    }
      
    // MARK:- ACTIONS
    @IBAction func createAccountTapped(sender: Any?) {
        if let first = firstNameTF.text,
           let last = lastNameTF.text,
           let email = emailTF.text,
           let password = passwordTF.text,
           verify().count == 0 {
            
            showLoader()
            authManager.signUp(firstName: first, lastName: last, email: email, password: password) { [weak self] (result) in
                guard let self = self else {return}
                self.hideLoader()
                 
                switch result {
                case .failure(let err):
                    self.showError(message: err.getDescription())
                case .success(let response):
                        DispatchQueue.main.async {
                            self.navigateToHome()
                        }
                    
                    print(response)
                }
            }
        } else {
            showError(message: verify().joined(separator: "\n"))
        }
    }
    
    
    private func navigateToHome() {
        self.view.window?.rootViewController = UIHostingController(rootView: TabBarView())
        self.view.window?.makeKeyAndVisible()
    }
     
    @objc func tappedOnLabel(_ gesture: UITapGestureRecognizer) {
        guard let text = termsPpLabel.text else { return }
        let terms = (text as NSString).range(of: "Terms of Service")
        let ppRange = (text as NSString).range(of: "Privacy Policy")
        if gesture.didTapAttributedTextInLabel(label: self.termsPpLabel, inRange: terms) {
            print("Terms of Service tapped")
            
            if let vc = storyboard?.instantiateViewController(identifier: "TermsOfServiceViewController") {
                self.present(vc, animated: true, completion: nil)
            }
            
            
            
            
        } else if gesture.didTapAttributedTextInLabel(label: self.termsPpLabel, inRange: ppRange) {
            /// todo: split for PP
            if let vc = storyboard?.instantiateViewController(identifier: "TermsOfServiceViewController") {
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
 
}
