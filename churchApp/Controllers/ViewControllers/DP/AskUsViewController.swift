//Created for churchApp  (08.10.2020 )

import UIKit

class AskUsViewController: UIViewController {

    
    @IBOutlet weak var inputText: KMPlaceholderTextView!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    private let dpManager = DPManager.shared
    
    var dinnerID: Int?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addKeyboardObserver()
    }
    
    
    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardFrameWillChange(notification:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    
    @objc func keyboardFrameWillChange(notification: Notification) {
        
        let n = KeyboardNotification(notification)
        let keyboardFrame = n.frameEndForView(view: self.view)
          
        let viewFrame = self.view.frame
        let newBottomOffset = (viewFrame.maxY - keyboardFrame.minY) + 8

        self.view.layoutIfNeeded()
        
        UIView.animate(
            withDuration: n.animationDuration,
            delay: 0.0,
            options: n.animationOptions,
            animations: { [weak self] in
                
                guard let strongSelf = self else { return }
                strongSelf.bottomConstraint.constant =  newBottomOffset
                strongSelf.view.layoutIfNeeded()
                
        }, completion: nil)
    }
    
    
    @IBAction func submitTapped(_ sender: UIButton) {
        guard
            let text = inputText.text,
            let id = dinnerID, !text.isEmpty
            else {
            showError(message: "You need to enter a question.")
            return
        }
        
        showLoader()
        dpManager.askUs(dinnerId: id, text: text) {[weak self] (res) in
            self?.hideLoader()
            
            switch res {
            case .failure(let err):
                self?.showError(message: err.getDescription())
            case .success(let d):
                DispatchQueue.main.async {
                    self?.showError(message: "The question has been successfully sent.", okClosure: { (act) in
                        self?.sentSuccessfuly(d.data?.response)
                    })
                }
            }
        }
    }
    
    
    private func sentSuccessfuly(_ response: String?) {
        if let nv = navigationController {
            nv.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
