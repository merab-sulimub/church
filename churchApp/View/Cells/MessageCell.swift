//Created for churchApp  (20.10.2020 )

import UIKit
import SwiftUI
import Nuke

class MessageCell: UITableViewCell {
    @IBOutlet weak var rightUserLabel: UILabel!
    @IBOutlet weak var rightContentLabel: UILabel!
    @IBOutlet weak var leftUserLabel: UILabel!
    @IBOutlet weak var leftContentLabel: UILabel!
    
    @IBOutlet weak var rightUserBgView: UIView!
    @IBOutlet weak var rightContentBgView: UIView!
    //@IBOutlet weak var leftUserBgView: UIView!
    
    @IBOutlet weak var leftAvatar: UIImageView!
    @IBOutlet weak var rightAvatar: UIImageView!
    
    
    @IBOutlet weak var leftContentBgView: UIView!
    
    private let defaultFont = commonAppearance.InterSemiBold.withSize(14.0)
    
    private static let largeConfig = UIImage.SymbolConfiguration(pointSize: 140, weight: .bold, scale: .large)
    private let defaultImage = UIImage(systemName: "person.crop.circle.fill", withConfiguration: largeConfig)!.maskWithColor(color: UIColor.lightGray)!
    
    
    
    
    override func awakeFromNib() {
        rightUserBgView.layer.cornerRadius = 20
        rightContentBgView.layer.cornerRadius = 5
        
        //leftUserBgView.layer.cornerRadius = 20
        leftContentBgView.layer.cornerRadius = 5
    }
    
    private var type: CellType = .right {
        didSet {
            let rightHidden = type == .left ? true : false
            
            rightUserLabel.isHidden = rightHidden
            rightContentLabel.isHidden = rightHidden
        
            leftUserLabel.isHidden = !rightHidden
            leftContentLabel.isHidden = !rightHidden
            
            rightUserBgView.isHidden = rightHidden
            rightContentBgView.isHidden = rightHidden
            
            //leftUserBgView.isHidden = !rightHidden
            
            leftAvatar.isHidden = !rightHidden
            leftContentBgView.isHidden = !rightHidden
        }
    }
    
    private var user: String? {
        didSet {
            switch type {
            case .left:  leftUserLabel.text = user
            case .right: rightUserLabel.text = user
            }
        }
    }
    
    private var content: String? {
        didSet {
            switch type {
            case .left:  leftContentLabel.text = content
            case .right: rightContentLabel.text = content
            }
        }
    }
    
    func update(type: CellType, message: Message) {
        self.type = type
        self.user = message.userId
        self.content = message.text
        
        let textFont = message.isInfo ? defaultFont.withSize(8) : defaultFont
        let textColor: UIColor = message.isInfo ? .gray : .black
         
        print("info: \(message.isInfo)")
        
        leftContentLabel.font = textFont
        rightContentLabel.font = textFont
        
        leftContentLabel.textColor = textColor
        rightContentLabel.textColor = textColor
    }
    
    func setupAvatar(with url: String) {
        
        
        guard let url = URL(string: WebservicesConfig().host+url) else { return }
        
        
        
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 140, weight: .bold, scale: .large)
        let defaultImage = UIImage(systemName: "person.crop.circle.fill", withConfiguration: largeConfig)?.maskWithColor(color: UIColor.lightGray)!
        
        
        let options = ImageLoadingOptions(
            placeholder: defaultImage,
            transition: .fadeIn(duration: 0.33)
        )
        
        Nuke.loadImage(with: url, options: options, into: leftAvatar)
         
    }
    
    
    
    func setDefaultAvatar() {
        leftAvatar.image = defaultImage
    }
    
    
    
}
