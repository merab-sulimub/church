//Created for churchApp  (07.10.2020 )

import UIKit

 
@IBDesignable
class formRoundedView: UIView { //
     
    @IBInspectable var placeholderText: String? = nil {
        didSet {
            placeholder.isHidden = placeholderText == nil
            placeholder.text = placeholderText
        }
    }
    
    var showBorder: Bool = true {
        didSet {roundedLayer.isHidden = !showBorder}
    }
    
    private let roundedLayer = CALayer()
    
    private let placeholder: UIInsetLabel = {
        let label = UIInsetLabel()
        
        label.textColor = #colorLiteral(red: 1, green: 0.4784313725, blue: 0, alpha: 1)
        label.numberOfLines = 1
        label.font = commonAppearance.InterSemiBold.withSize(8.0)
        label.backgroundColor = .white
         
        return label
    }()
    
    open override func layoutSubviews() {
        super.layoutSubviews()
         
        roundedLayer.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
    }
    
    /// initWithFrame to init view from code
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    /// initWithCode to init view from xib or storyboard
    required public init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      setupView()
    }
    
    private func setupView() {
         
        placeholder.isHidden = placeholderText == nil
        
        roundedLayer.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        roundedLayer.cornerRadius = 4
        roundedLayer.borderWidth = 1
        roundedLayer.borderColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
        layer.addSublayer(roundedLayer)
      
        placeholder.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(placeholder)
        
        NSLayoutConstraint.activate([
            placeholder.heightAnchor.constraint(equalToConstant: 12.0),
            placeholder.topAnchor.constraint(equalTo: topAnchor, constant: -5),
            placeholder.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14-4), // 14 <=P== - label margin
        ])
        
    }
    
    private func updatePlaceholder() {
        placeholder.text = placeholderText
    }
}

