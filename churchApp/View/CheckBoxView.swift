//Created for churchApp  (14.10.2020 )

import UIKit


protocol checkBoxValueChangedDelegate {
    func valueChnaged(checked: Bool, withID: Int?)
}


@IBDesignable
class CheckBoxView: UIView {

    private struct Constants {
        static let size: CGFloat = 28
        static let leftMargin: CGFloat = 8
        static let topMargin: CGFloat = 4
        
        
        static let chekedImage = UIImage(named: "checkBox-checked")
        static let uncheckedImage = UIImage(named: "checkBox-unchecked")
        static let font: UIFont = commonAppearance.InterRegular.withSize(14.0)
        
        
        
        static let sidePadding: CGFloat = 24
        static let topPadding: CGFloat = 8
        static let borderWidth: CGFloat = 1
        static let borderRadius: CGFloat = 16
        static let borderColor: UIColor = UIColor(named: "borderColor 1")!
        static let selectedBorderColor: UIColor = #colorLiteral(red: 0.4980392157, green: 0.4980392157, blue: 0.5098039216, alpha: 1)
        static let borderPlaceholderColor: UIColor = UIColor(named: "Grey 3")!
        static let borderPlaceholderFontSize: CGFloat = 12.0
    }
     
    
    @IBInspectable open var labelText: String = "" {
        didSet {
            checkLabel.text = labelText
        }
    }
    
    @IBInspectable open var isChecked: Bool = false {
        didSet {
            checkBox.image = isChecked ? Constants.chekedImage : Constants.uncheckedImage
            // todo: ?
        }
    }
    
    var inputData: Any?
     
    var delegate: checkBoxValueChangedDelegate?
    
    
    private let checkBox: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .clear
        iv.image = Constants.uncheckedImage
        iv.isUserInteractionEnabled = true
        
        return iv
    }()
    
    
    @objc func tappedOnImage() {
        isChecked = !isChecked
        
        
        if let d = inputData as? FormAnswersResponse {
            self.delegate?.valueChnaged(checked: isChecked, withID: d.id)
        }
        print("is checked: \(isChecked)")
        
    }
    
    private let checkLabel: UILabel = {
        let lbl = UILabel()
         
        lbl.text = "$checkBox Label"
        lbl.font = Constants.font
        
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        return lbl
    }()
    
    
    
    /// public ?
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
     

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    
    private func commonInit() {
        backgroundColor = .white
        ///dev
//        layer.borderWidth = 1.0
//        layer.borderColor = UIColor.blue.cgColor
//
        
        
        /// append checkbox view
        addSubview(checkBox)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedOnImage))
        checkBox.addGestureRecognizer(tap)
        
        addSubview(checkLabel)
        setupConstraints()
         
    }
    
    
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            checkBox.heightAnchor.constraint(equalToConstant: Constants.size),
            checkBox.widthAnchor.constraint(equalToConstant: Constants.size),
             
            checkBox.leftAnchor.constraint(equalTo: leftAnchor, constant: Constants.leftMargin),
            
            checkBox.topAnchor.constraint(equalTo: topAnchor, constant: Constants.topMargin),
            checkBox.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Constants.topMargin),
            
            checkLabel.centerYAnchor.constraint(equalTo: checkBox.centerYAnchor),
            checkLabel.leftAnchor.constraint(equalTo: checkBox.rightAnchor, constant: Constants.leftMargin)
        
        ])
    }
}
