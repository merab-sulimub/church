//Created for churchApp  (09.10.2020 )

import UIKit

class JoinDPViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var joinDPTitleLabel: UILabel!
    
    @IBOutlet weak var firstNameTF: CAPlacehorderTextField!
    @IBOutlet weak var lastNameTF: CAPlacehorderTextField!
    @IBOutlet weak var phoneTF: CAPlacehorderTextField!
    @IBOutlet weak var emailTF: CAPlacehorderTextField!
    
    @IBOutlet weak var questionsTableView: UITableView!
    @IBOutlet weak var questionsHeight: NSLayoutConstraint!
    
    
    var selectedDP: FindPartyResponse!
    
    var questionnaire: [FormQuestionsResponse] = []
//    {
//        return
//    }
    
    private let dpManager = DPManager.shared
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
         
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

         
        self.view.layoutIfNeeded()
        self.questionsHeight.constant = self.questionsTableView.contentSize.height
        self.view.layoutIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateQAHeight()
    }
    
    
    private func generateQuestionnaires() -> [[String: String]] {
        
        var tmp: [[String: String]] = []
        
        
        for cell in questionsTableView.visibleCells {
            if let c = cell as? QuestionTableViewCell {
                var tmp2: [String: String] = [
                    "question": c.cellValue.question,
                    "answer": ""
                ]
                 
                for q in c.cellValue.answers {
                    if q.checked ?? false,
                       let currAns = tmp2["answer"] {
                         
                        tmp2["answer"] = currAns.isEmpty ? q.body : "\(currAns), \(q.body)"
                    }
                }
                
                tmp.append(tmp2)
                
                 
            }
        }
        
        
        return tmp
         
    }
    
    
    
     
    @IBAction func joinTapped(_ sender: UIButton) {
        updateQAHeight()
        //todo: verify fields
        let generated = generateQuestionnaires()
        
        
        guard
            let first = firstNameTF.text,
            let last = lastNameTF.text,
            let phone = phoneTF.text,
            let email = emailTF.text,
            !first.isEmpty || !last.isEmpty || !phone.isEmpty || !email.isEmpty
        else {
            showError(message: "Some fields can't be empty.")
            return
        }
        
        showLoader()
        dpManager.joinParty(
            selectedDP.id,
            username: "\(first) \(last)",
            email: email,
            phone: phone,
            questionnaire: generated
        ) {[weak self] (res) in
            self?.hideLoader()
            
            switch res {
            case .failure(let err):
                self?.showError(message: err.getDescription())
            case .success(let d):
                DispatchQueue.main.async {
                    self?.UpdateProfileData()
                }
            }
        }
    }
    
    
    
    
    private func wasSentSuccessfully(_ data: Any?) {
         
        if let nv = navigationController,
           let vc = storyboard?.instantiateViewController(identifier: "DPWelcomeViewController") as? DPWelcomeViewController
        
        { 
            nv.pushViewController(vc, animated: true)
        }
        
        
        else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    private func UpdateProfileData() {
        if let token = UserManager.shared.token, UserManager.shared.isLoginned {
            print("✅ App has stored token: \(token)")
              
            /// try to fetch my profile
            UserManager.shared.myProfile { [weak self] (res) in
                guard let self = self else { return }
                switch res {
                case .failure(let err):
                    self.showError(message: err.getDescription()) { (action) in
                         
                    }
                case .success(let d):
                    print("Verify Data: \(d.profile)")
                    
                    DispatchQueue.main.async {
                        self.showError(message: "The request has been successfully sent.", okClosure: { (act) in
                            self.wasSentSuccessfully(d)
                        })
                    }
                }
            }
        }
    }
    
     
    
    private func updateQAHeight() {
        DispatchQueue.main.async {
                
                self.questionsTableView.reloadData()
                self.view.layoutIfNeeded()
            
                self.questionsTableView.isScrollEnabled = false
                self.questionsHeight.constant = self.questionsTableView.contentSize.height
                self.view.layoutIfNeeded()
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



extension JoinDPViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedDP.formQuestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! QuestionTableViewCell
        
        cell.setup(selectedDP.formQuestions[indexPath.row])
        
        return cell
    }
}
