//Created for churchApp  (15.10.2020 )

import UIKit

class QuestionTableViewCell: UITableViewCell, checkBoxValueChangedDelegate {
     
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var questionsStackView: UIStackView!
     
    var cellValue: FormQuestionsResponse! //todo: force unwrap ?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup(_ data: FormQuestionsResponse) {
        cellValue = data
        
        questionsStackView.removeAllArrangedSubviews()
          
        questionLabel.text = data.question
        
        for answer in data.answers {
            
            let checkBox = CheckBoxView()
            
            checkBox.inputData = answer
            checkBox.labelText = answer.body
            
            checkBox.delegate = self
            
            questionsStackView.addArrangedSubview(checkBox)
        }
    }
    
    
    func valueChnaged(checked: Bool, withID: Int?) {
        if
            let id = withID,
            let index = cellValue.answers.firstIndex(where: { $0.id == id }) {
            cellValue.answers[index].checked = checked
             
    }
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    } 
}
