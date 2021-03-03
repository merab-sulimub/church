//Created for churchApp  (28.09.2020 )

import UIKit


class roundedView: UIView { // @IBDesignable

    
    private let roundedLayer = CALayer()
    
    
    @IBInspectable var radius: CGFloat {
        get {return roundedLayer.cornerRadius}
        set {roundedLayer.cornerRadius = newValue}
    }
    
    @IBInspectable var borderW: CGFloat {
        get {return roundedLayer.borderWidth}
        set {roundedLayer.borderWidth = newValue}
    }
      
    override func layoutSubviews() {
        super.layoutSubviews()
         
        roundedLayer.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
    }
    
    /// initWithFrame to init view from code
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    /// initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      setupView()
    }
    
    private func setupView() {
        roundedLayer.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        
        roundedLayer.cornerRadius = 2
        roundedLayer.borderWidth = 1
        roundedLayer.borderColor = UIColor(named: "borderColor 1")?.cgColor
        
        layer.addSublayer(roundedLayer)
       
    }
}
