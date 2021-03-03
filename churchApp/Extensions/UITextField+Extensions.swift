//Created for churchApp  (15.10.2020 )
 
import UIKit
extension UITextField{
    
    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }
    
    func addDoneButtonOnKeyboard()
    {
        /// adding a non empty frame for UIToolbar in library code. I am not familiar with how this library initializes the UIToolbar.
        let doneToolbar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0,
                                                             width: UIScreen.main.bounds.size.width,
                                                             height: 44.0))
        doneToolbar.barStyle = .default
        
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        self.resignFirstResponder()
    }
}
