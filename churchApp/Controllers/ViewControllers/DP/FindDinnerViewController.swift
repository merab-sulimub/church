//Created for churchApp  (26.09.2020 )

import UIKit

class FindDinnerViewController: CommonViewController {
 
    
    private let dpManager = DPManager.shared
    
    @IBOutlet weak var searchTF: UITextField!
    private var zipCode: String? {
        didSet {
            updateZipTF()
        }
    }
     
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }
    

    
    
    @IBAction func numberTapped(num: UIButton) {
        let tag = num.tag - 100
        
        if tag >= 0 {
            
            /// remove button
            if let tf = searchTF.text,
               tag == 10 {
                
                if tf.count >= 1 {
                    
                    searchTF.text?.removeLast()
                    if let newZip = searchTF.text {
                        zipCode = "\(newZip)"
                    }
                }
                
            } else {
                /// number tapped
                if let zip = zipCode {
                    zipCode = "\(zip)\(tag)"
                } else {
                    zipCode = "\(tag)"
                }
            }
        }
    }
    
    @IBAction func searchTapped(sender: Any) {
        //todo:
        guard
            let zipStr = zipCode,
            let zip = Int(zipStr) else {
            showError(message: "Can't parse ZIP Code.")
            return
        }
        showLoader()
        dpManager.findBy(with: zip) {[weak self] (res) in
            self?.hideLoader()
            
            switch res {
            case .failure(let err):
                self?.showError(message: err.getDescription())
            case .success(let d):
                if d.data?.dpList.count == 0 {
                    self?.showError(message: "nothing was found for this zip code")
                } else {
                    DispatchQueue.main.async { [weak self] in
                        self?.openResultPage(with: d.data, zip: self?.zipCode)
                    }
                }
            }
        }
    }
    
    @IBAction func viewAllDPTapped(sender: Any) {
        //todo:
        showLoader()
        dpManager.getAllDPs {[weak self] (res) in
            self?.hideLoader()
            
            switch res {
            case .failure(let err):
                self?.showError(message: err.getDescription())
            case .success(let d):
                DispatchQueue.main.async {
                    self?.openResultPage(with: d.data)
                }
            }
        }
    }
    
    private func openResultPage(with data: FindPartiesResponse?, zip: String? = nil) {
        guard let vc = storyboard?.instantiateViewController(identifier: "SearchResultViewController") as? SearchResultViewController
        
        else {return}
        
        if let d = data {
            vc.result = d.dpList
            vc.searchByZip = zip
        }
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    private func updateZipTF() {
        guard let code = zipCode else {return}
        
        searchTF.text = code
    }
}
