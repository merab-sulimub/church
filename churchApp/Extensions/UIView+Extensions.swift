//Created for churchApp  (23.09.2020 )

import UIKit

// MARK:- Borders Extension 
extension UIView {
    @IBInspectable var borderColor: UIColor? {
        get {
            if let cgcolor = layer.borderColor {
                return UIColor(cgColor: cgcolor)
            } else {
                return nil
            }
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
}

// MARK:- Shadows Extension
extension UIButton {
    @IBInspectable var shadowColor: UIColor? {
        get {
            if let cgcolor = layer.shadowColor {
                return UIColor(cgColor: cgcolor)
            } else {
                return nil
            }
        }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }
    
    @IBInspectable
    var masksToBounds: Bool {
        get { return layer.masksToBounds }
        set { layer.masksToBounds = newValue }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get { return layer.shadowOffset }
        set { layer.shadowOffset = newValue }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get { return layer.shadowOpacity }
        set { layer.shadowOpacity = newValue }
    }
}
 
extension FloatingPoint {
    var isInt: Bool {
        return floor(self) == self
    }
}
 
extension UIStackView {
    @discardableResult
    func removeAllArrangedSubviews() -> [UIView] {
        return arrangedSubviews.reduce([UIView]()) { $0 + [removeArrangedSubViewProperly($1)] }
    }

    func removeArrangedSubViewProperly(_ view: UIView) -> UIView {
        removeArrangedSubview(view)
        NSLayoutConstraint.deactivate(view.constraints)
        view.removeFromSuperview()
        return view
    }
}

public enum ImageFormat {
    case PNG
    case JPEG(CGFloat)
}

extension UIImage {
 
    public func base64() -> String? {
        if let d = jpegData(compressionQuality: 0.8) {
            return d.base64EncodedString()
        } else {return nil}
    }
    
    
}

 

extension UITextView {

    func addDoneButton() {
          
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0,
                                              width: UIScreen.main.bounds.size.width,
                                              height: 44.0))//1
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)//2
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneButtonAction))//3
        toolBar.setItems([flexible, barButton], animated: false)//4
        self.inputAccessoryView = toolBar//5
    }
    
    
    @objc func doneButtonAction()
    {
        self.resignFirstResponder()
    }
    
    
    
    
    
    
}

extension CGSize {
    func scaledToWidth(_ newWidth: CGFloat) -> CGSize {
        let newHeight = self.height * (newWidth / self.width)
        return CGSize(width: newWidth, height: newHeight)
    }
    
    func scaledToHeight(_ newHeight: CGFloat) -> CGSize {
        let newWidth = self.width * (newHeight / self.height)
        return CGSize(width: newWidth, height: newHeight)
    }
    
    var aspectRatio: CGFloat {
        return self.width / self.height
    }
}
