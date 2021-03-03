//Created for churchApp  (25.09.2020 )

import Foundation
import RealmSwift

struct UserManagerConfig {
    let onboarding =  "onboarding"
    
}

class UserManager {
    public static let shared = UserManager()
    private init() {}
    
    private let defaults = UserDefaults.standard
    private let config = UserManagerConfig()
    private let webService = WebServiceAPI.shared
    
    
    
    var token: String? {self.myToken()}
    var isLoginned: Bool {self.isUserLoginned()}
     
    var showOnboarding: Bool  {
        set { defaults.set(newValue, forKey: config.onboarding) }
        get { defaults.bool(forKey: config.onboarding) }
    }
    
    
    var profile: myProfileResponse {self.myProfileRes()}
    
    
    
    func myToken() -> String? {
        if let profile = DatabaseController.shared.MyProfile(),
           profile.token.count > 0 {
            return profile.token
        } else {
            return nil
        }
    }
      
    
    func getUserID() -> Int? {
        if let profile = DatabaseController.shared.MyProfile(),
           profile.id > 0 {
            return profile.id
        } else {
            return nil
        }
    }
     
    private func isUserLoginned() -> Bool {
        if let profile = DatabaseController.shared.MyProfile(),
           !profile.token.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    
    
    
    private func myProfileRes() -> myProfileResponse {
        return myProfileResponse(DatabaseController.shared.MyProfile() ?? ProfileDB())
    }
    
    
    //MARK: - API Methods
    
    func updateMyProfile(
        fist: String,
        last: String,
        email: String,
        phone: String,
        address: String,
        
        
        result: @escaping result<SignInResponse>) {
        
        let params: [String: Any] = [
            "first_name": fist,
            "last_name": last,
            "email": email,
            "phone": phone,
            "address": address
        ]
        
        
        webService.fetchResources(.updateProfile, params: params, method: .put, appendBaseContainer: true) { (resp: response<SignInResponse>) in
         
        //webService.fetchResources(.updateProfile, appendBaseContainer: true) { (resp: response<SignInResponse>) in
            switch resp {
            case .success(let r):
                 
                //print(r)
                /// update profile on open
                
                DispatchQueue.main.async {
                  
                    DatabaseController.shared.saveProfile(r.profile)
                }
                
            case .failure(let err):
                break
                //print(err.getDescription())
            }
            
            result(resp)
        }
    }
     
    func uploadMyAvatar(with data: Data,result: @escaping result<UpdateAvatarResponse>) {
        
        let fileName = "\(UserManager.shared.getUserID() ?? 0)_\(UUID().uuidString).jpg"
        let file = multipartFile(fieldName: "file", fileName: fileName, fileContents: data)
         
        webService.fetchResources(.uploadAvatar, multipartFile: file, appendBaseContainer: true, completion: result)
    }
    
    func removeMyAvatar(result: @escaping result<RemoveAvatarResponse>) {
        webService.fetchResources(.removeAvatar, method: .patch, appendBaseContainer: true, completion: result)
    }
    
    
    
    func myProfile(result: @escaping result<SignInResponse>) {
        // Mark: - .profileByToken return data -> profile only, we can use SignInResponse becouse other data is optional
        webService.fetchResources(.profileByToken, appendBaseContainer: true) { (resp: response<SignInResponse>) in
            switch resp {
            case .success(let r):
                print("Profile Verify: ✅ User \(r.profile.name) ur welcome !")
                
                /// update profile on open
                
                DispatchQueue.main.async {
                    DatabaseController.shared.saveProfile(r.profile)
                }
                
            case .failure(let err):
                print(err.getDescription())
            }
            
            result(resp)
        }
    }
    
    
    func contactUS(text: String, result: @escaping result<ResponseResponse>) {
        
        let params = [
            "text": text
        ]
        
        webService.fetchResources(.contactUs, params: params, appendBaseContainer: true, completion: result)
    }
    
}
