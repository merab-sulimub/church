//Created for churchApp  (22.09.2020 )

import UIKit

class LoginViewController: UIViewController {

    private let authManager = AuthManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        setupBackButton(navigationController)     }
       
    @IBAction func signUpGoogleTapped(sender: UIButton) {  }
    
    @IBAction func signUpAppleTapped(sender: UIButton) { }


}

