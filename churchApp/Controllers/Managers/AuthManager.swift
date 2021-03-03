//Created for churchApp  (25.09.2020 )

import Foundation

//let authManager = AuthManager()

typealias result<T> = (Result<T, APIServiceError>) -> Void
typealias response<T> = Result<T, APIServiceError>
 
class AuthManager {
    public static let shared = AuthManager() 
    private init() {}
    
    private let webService = WebServiceAPI.shared
    private let userManager = UserManager.shared
    
     
    func signIn(email: String, password: String, result: @escaping result<SignInResponse>) {
         
        let params = [
            "email": email,
            "password": password
        ]
         
        webService.fetchResources(.signIn, params: params, appendBaseContainer: true) { (WSResult: response<SignInResponse>) in
             
            switch WSResult {
            case .success(let r):
                
                if let token = r.token {
                      
                    DispatchQueue.main.async {
                        DatabaseController.shared.saveProfile(r.profile, with: token)
                    }
                    print("Auth: ✅ User Logined successfully with token: \(token)")
                    
                } else {
                    result(.failure(.invalidToken))
                }
                 
            case .failure( _): break
            }
             
            result(WSResult)
        }
    }
    
    func signUp(
        firstName: String,
        lastName: String,
        email: String,
        password: String,
        result: @escaping result<SignInResponse>) {
        
        let params = [
            "first_name": firstName,
            "last_name": lastName,
            "email": email,
            "password": password 
        ]
          
        webService.fetchResources(.signUp, params: params, appendBaseContainer: true) { (WSResult: response<SignInResponse>) in
            
            
            
            switch WSResult {
            case .success(let r):
                
                if let token = r.token {
                    
                    
                    DispatchQueue.main.async {
                        self.userManager.showOnboarding = true
                        DatabaseController.shared.saveProfile(r.profile, with: token)
                    }
                     
                } else {
                    result(.failure(.invalidToken))
                }
                
                
                
                
                print("TokenManager: ✅ User Logined successfully with token: \(r.token)")
            case .failure( _):break
                
            }
            
            result(WSResult)
        }
    }
    
    
    func signOut(result: @escaping result<ServerResponse<[SignInResponse]>>) {
        webService.fetchResources(.signOut) { (resp: response<ServerResponse<[SignInResponse]>>) in
            
             
            
            switch resp {
            case .success(let r):
                if r.errors.count == 0 {
                    //self.tokenManager.set(token: nil)
                    print("TokenManager: ✅ User signOut successfully")
                    
                    
                }
            case .failure( _): break
            }
            
            DispatchQueue.main.async {
                DatabaseController.shared.clearDB()
                
            }
             
            result(resp)
        }
    }
    
    

    
    
 
    

    
} 
