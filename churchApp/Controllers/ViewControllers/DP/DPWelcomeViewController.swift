//Created for churchApp  (09.10.2020 )

import UIKit

class DPWelcomeViewController: UIViewController {

    @IBOutlet weak var leaderName: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
     
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false) 
    }
    
    
    
    @IBAction func goToHome(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
        //navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func playTapped(_ sender: UIButton) {
        
    } 

}
