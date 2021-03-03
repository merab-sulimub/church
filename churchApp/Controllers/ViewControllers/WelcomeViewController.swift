//Created for churchApp  (25.09.2020 )

import UIKit

class WelcomeViewController: UIViewController {
    
    
    var dismissCallback: (() -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
     
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("DEBUG: Onboarding set to FALSE")
        UserManager.shared.showOnboarding = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
         
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
      
    @IBAction func dismiss(_ sender: UIButton) {
         
        if dismissCallback != nil {
            dismissCallback!()
        }
       
        
        if let nv = self.navigationController {
            nv.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
