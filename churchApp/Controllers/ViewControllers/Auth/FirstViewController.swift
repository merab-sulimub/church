//Created for churchApp  (06.10.2020 )

import UIKit
import SwiftUI
import AppCenterCrashes

class FirstViewController: UIViewController {

    private let userManager = UserManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLoader()
        // Do any additional setup after loading the view.
         
         
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        authCheck()
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    private func authCheck() {
        if let token = userManager.token, userManager.isLoginned {
            print("✅ App has stored token: \(token)")
              
            /// try to fetch my profile
            UserManager.shared.myProfile { [weak self] (res) in
                guard let self = self else { return }
                switch res {
                case .failure(let err):
                    self.showError(message: err.getDescription()) { (action) in
                        
                         
                        DispatchQueue.main.async {
                            DatabaseController.shared.clearDB()
                            self.navigateToLoginVC()
                        }
                        
                        
                    }
                case .success(let d):
                    print("Verify Data: \(d.profile)")
                    
                    DispatchQueue.main.async {
                        self.navigateToHome()
                    }
                }
            } 
        } else {
            navigateToLoginVC()
        }
    }
    
    
    //MARK: - initNavigationController -> Navs to LoginVC
    private func navigateToLoginVC() {
        guard let nv = navigationController,
              let stb = storyboard,
              let loginNavController = stb.instantiateViewController(identifier: "initNavigationController") as? UINavigationController
        else {
            return
        }
        
        nv.present(loginNavController, animated: false, completion: nil)
    }
    
    private func navigateToHome() {
        self.view.window?.rootViewController = UIHostingController(rootView: TabBarView())
        self.view.window?.makeKeyAndVisible()
    }
     
    
    private func setupLoader() {
        var config : SwiftLoader.Config = SwiftLoader.Config()
        config.size = 150
         
        config.spinnerLineWidth = 2.0
        config.spinnerColor = .red
        config.foregroundColor = .black
        config.foregroundAlpha = 0.5
        
        SwiftLoader.setConfig(config: config)
    } 
}
