//Created for churchApp  (14.10.2020 )

import UIKit

//@IBDesignable
class CAPlacehorderTextField: UITextField {
    
    private struct Constants {
        static let sidePadding: CGFloat = 24
        static let topPadding: CGFloat = 8
        static let borderWidth: CGFloat = 2
        static let borderRadius: CGFloat = 16
        static let borderColor: UIColor = UIColor(named: "borderColor 1")!
        static let selectedBorderColor: UIColor = #colorLiteral(red: 0.4980392157, green: 0.4980392157, blue: 0.5098039216, alpha: 1)
        static let borderPlaceholderColor: UIColor = UIColor(named: "Grey 3")!
        static let borderPlaceholderFontSize: CGFloat = 12.0
    }
    
    private let textChangeNotification = UITextField.textDidChangeNotification
    private let roundedLayer = CALayer()
    private let topPlaceholder: UIInsetLabel = {
        let label = UIInsetLabel()
        
        label.textColor = Constants.borderPlaceholderColor
        label.numberOfLines = 1
        label.font = commonAppearance.InterRegular.withSize(Constants.borderPlaceholderFontSize)
        label.backgroundColor = .white
         
        return label
    }()
    
    var showBorder: Bool = true {
        didSet {roundedLayer.isHidden = !showBorder}
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(
            x: bounds.origin.x + Constants.sidePadding,
            y: bounds.origin.y + Constants.topPadding,
            width: bounds.size.width - Constants.sidePadding * 2,
            height: bounds.size.height - Constants.topPadding * 2
        )
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return self.textRect(forBounds: bounds)
    }
     
    override func awakeFromNib() {
        super.awakeFromNib()
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
    
    func setTopPlaceholder(_ t: String?) {
        topPlaceholder.text = t
    }
    
    private func setupView() {
          
        NotificationCenter.default.addObserver(self,
            selector: #selector(textDidChange),
            name: textChangeNotification,
            object: nil)
         
        
        setTopPlaceholder(placeholder)
        
        
        self.font = commonAppearance.InterRegular.withSize(16)
        
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [.foregroundColor: Constants.borderPlaceholderColor])
        //topPlaceholder.isHidden = placeholder?.isEmpty ?? true
        
        roundedLayer.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        roundedLayer.cornerRadius = Constants.borderRadius
        roundedLayer.borderWidth = Constants.borderWidth
        roundedLayer.borderColor = Constants.borderColor.cgColor
        layer.addSublayer(roundedLayer)
      
        topPlaceholder.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(topPlaceholder)
        textDidChange()
        
        NSLayoutConstraint.activate([
            topPlaceholder.heightAnchor.constraint(equalToConstant: 12.0),
            topPlaceholder.topAnchor.constraint(equalTo: topAnchor, constant: -5),
            topPlaceholder.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.sidePadding-4.0), //  <=P== - Label leftInset
        ])
        
    }
    
    @objc func textDidChange() {
        let displayTopPlaceholder = (text?.isEmpty ?? true || placeholder?.isEmpty ?? true)
        
        /// set border color
        roundedLayer.borderColor = displayTopPlaceholder ? Constants.borderColor.cgColor : Constants.selectedBorderColor.cgColor
         
         
        showPlaceholder(hide: displayTopPlaceholder)
    }
    
    
    private func showPlaceholder(hide: Bool) {
        topPlaceholder.isHidden =  hide
        
        
        UIView.animate(withDuration: 0.5) {
            self.topPlaceholder.alpha = hide ? 0 : 1
        } completion: { (finished) in
            
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
            name: textChangeNotification,
            object: nil)
    }
}
