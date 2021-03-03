//Created for churchApp  (02.10.2020 )

import UIKit

class DinnerSearchResultCell: UITableViewCell {

    
    @IBOutlet weak var DPLabel: UILabel!
    @IBOutlet weak var DPStartAt: UILabel!
    @IBOutlet weak var DPTypeLabel: UILabel!
    
    @IBOutlet weak var DPImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
        
        DPImageView.cornerRadius = 16.0
    }
    
    
    
    func setup(with data: FindPartyResponse) {
        DPLabel.text = data.title
         
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE 'at' h:mma"
  
        DPStartAt.text = dateFormatter.string(from: data.date)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
