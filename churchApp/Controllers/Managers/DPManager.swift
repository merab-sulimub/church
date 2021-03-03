//Created for churchApp  (09.10.2020 )
import Foundation
  

class DPManager {
    public static let shared = DPManager()
    private init() {}
    
    private let webService = WebServiceAPI.shared 
     
    func findBy(with zip: Int, result: @escaping result<ServerResponse<FindPartiesResponse>>) {
         
        let componens = [URLQueryItem(name: "zip", value: "\(zip)")]
        
        guard let url = Endpoint.findDP.URL(with: componens) else {
            result(.failure(.invalidEndpoint));return
        }
        
        webService.fetchResources(with: url, completion: result)
    }
    
    func getAllDPs(result: @escaping result<ServerResponse<FindPartiesResponse>>) {
        webService.fetchResources(.findDP, completion: result)
    }
    
    
    func askUs(dinnerId: Int, text: String, result: @escaping result<ServerResponse<AskUsResponse>>) {
        let params = [
            "text":"\(text)",
            "dinner_id": "\(dinnerId)"
        ]
         
        webService.fetchResources(.askUs, params: params, completion: result)
    }
    
    func joinParty(
        _ id: Int,
        username: String,
        email: String,
        phone: String,
        questionnaire: [[String: String]],
        result: @escaping result<ServerResponse<AskUsResponse>>
    ) {
        let params = [ 
            "dinner_id": "\(id)",
            "user_name": username,
            "user_email": email,
            "user_phone": phone,
            "questionnaire": questionnaire
        ] as [String : AnyObject]
        
        
        webService.fetchResources(.sendDPForm, params: params, completion: result)
    }
    
    
    //MARK: - DP Leader Only Methods
    func getMealsList(result: @escaping result<MealsListResponse>) {
        webService.fetchResources(.mealsList, appendBaseContainer: true, completion: result) 
    }
}
