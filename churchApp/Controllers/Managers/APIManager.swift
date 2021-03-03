//Created for churchApp  (23.09.2020 )

import Foundation
import SwiftUI



enum requestMethods: String {
    case get    = "GET"
    case head   = "HEAD"
    case post   = "POST"
    case put    = "PUT"
    case del    = "DELETE"
    case patch  = "PATCH"
}


enum headerContentType: String {
    case json           = "application/json"
    case urlencoded     = "application/x-www-form-urlencoded"
    case multipart      = "multipart/form-data"
}

struct WebservicesConfig {
    let developmentMode = true
    var host: String {self.getHost()}
    
    let devBaseURL  = "http://3.19.53.98/"
    let baseURL     = "https://xxx.xxx/" /// todo: add production server here
    
    let timeOutInterval: TimeInterval = 30
    let successRange = 200..<299
    
    ///DEBUG config
    let showsRequests = true
    let showsParams = true
    let showHeader = true
     
    
    private func getHost() -> String {
        return developmentMode ? devBaseURL : baseURL
    }
}


enum APIServiceError: Error {
        case apiReturnErrorsList(_ errors: [ErrorsResponse])
        case apiError
        case invalidEndpoint
        case invalidResponseStatusCode(_ code: Int)
        case invalidToken
        case noData
        case decodeError
        case internalManagerError
        case requestError(error: Error)
    
    
    func getDescription() -> String{
        switch self {
        case .apiError:
            return "API: the error was caused by the api"
        case .invalidEndpoint:
            return "API: Endpoint is not valid"
        case .invalidResponseStatusCode(let code):
            return "API: Invalid status code (\(code))"
        case .invalidToken:
            return "API: Invalid token returned"
        case .noData:
            return "API: data missing"
        case .decodeError:
            return "API: App can't parse response"
        case .internalManagerError:
            return "App: Internal request manager error"
        case .requestError(let err):
            return "APP: \(err.localizedDescription)"
      
        case .apiReturnErrorsList(let errors):
            return errors.compactMap({$0.value}).joined(separator: "\n")
        }
    }
}
 
// Enum Endpoints
enum Endpoint: String, CaseIterable {
    
    /// Auth
    case signUp             = "member/signup/"
    case signOut            = "member/signout/"
    case signIn             = "member/signin/"
    
    /// Profile
    case profileByToken     = "member/user/"
    case updateProfile      = "member/update-own-profile/"
    case uploadAvatar       = "member/change-avatar/"
    case removeAvatar       = "member/remove-avatar/"
     
    case contactUs          = "church/need_help/"
    
    /// Dinner Parties
    case findDP             = "dinner/find_party/"
    case askUs              = "dinner/ask_question/"
    case sendDPForm         = "member/send_onboard_form/"
    
    
    // Mark: - Leader Only Endpoints
    case mealsList          = "dinner/meals/"
    
    
    case createDinner       = "dinner/create/"
    
    
    
    public func URL(arguments: [String] = []) -> URL? {
        let url = String(format: "\(WebservicesConfig().host)\(self.rawValue)", arguments: arguments)
         
        return Foundation.URL(string: url)
    }
    
    
    public func URL(with components: [URLQueryItem]) -> URL? {
        
        guard
            let u = self.URL(),
            var URLComponents = URLComponents(url: u, resolvingAgainstBaseURL: false)
             
        else {return nil}
        
        
        URLComponents.queryItems = components
        
        if let url = URLComponents.url {
            return url
        } else {
            return nil
        }
    }
}
 
class WebServiceAPI {
    
    public static let shared = WebServiceAPI()
    private init() {}
    private let urlSession = URLSession.shared
  
    private let jsonDecoder: JSONDecoder = {
       let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
       let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
       return jsonDecoder
    }()
    
    
    private let config = WebservicesConfig()
     
    func fetchResources<T: Decodable>(
        _ endpoint: Endpoint? = nil,
        with forcedUrl: URL? = nil,
        params: [String: Any] = [:],
        paramsAsQueryItems: [URLQueryItem] = [],
        method: requestMethods? = nil,
        multipartFile: multipartFile? = nil,
        contentType: headerContentType = .json,
        appendBaseContainer: Bool = false,
        completion: @escaping (Result<T, APIServiceError>) -> Void) {
         
         func extract() {}
        var url: URL? = nil
         
        /// Endpoint check
        if
            let endpointURL = endpoint,
            let u = endpointURL.URL() {
            
            url = u
        }
         
        // if user forced URL
        if let u = forcedUrl {
            url = u
        }
         
        
        guard
            let requestURL = url else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        
        var request  = URLRequest(url: requestURL)
        /// set time out interval
        request.timeoutInterval = config.timeOutInterval
        /// set methods
        request.httpMethod = params.count == 0 || paramsAsQueryItems.count == 0 ? "GET" : "POST"
        
        if params.count == 0 && paramsAsQueryItems.count == 0 {
            request.httpMethod = "GET"
        } else {
            request.httpMethod = "POST"
        }
        
        
        /// you can select method manually
        if let selectedMethod = method {
            request.httpMethod = selectedMethod.rawValue
        }
        
        /// default header for requests
        request.allHTTPHeaderFields = [
               "Accept": "*/*" ]
        
        
        request.addValue(contentType.rawValue, forHTTPHeaderField: "Content-Type")
        
        
        
        
        
        /// added token (headers), if exist
        if let token = UserManager.shared.token  {
            request.addValue("Token \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if !params.isEmpty  {
            request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: .prettyPrinted) //todo: force unwrap?
        }
        
        if paramsAsQueryItems.count != 0 {
            var reqBodyComponents = URLComponents()
             
            reqBodyComponents.queryItems = paramsAsQueryItems
            
            request.httpBody = reqBodyComponents.query?.data(using: .utf8)
        }
        
        func generateMultipartRequest(for url: URL, file: multipartFile) -> URLRequest {
             
            var r = URLRequest(url: url)
            r.httpMethod = "PUT"
            
            
            // Set Content-Type in HTTP header.
            let boundaryConstant = "Boundary-\(UUID().uuidString)"; // This should be auto-generated.
            let mimeType = "image/jpg"
            
             
            /// default header for requests
//            r.allHTTPHeaderFields = [
//                   "Content-Type": "*/*" ]
            r.addValue("multipart/form-data; boundary=" + boundaryConstant, forHTTPHeaderField: "Content-Type")
              
            /// added token (headers), if exist
            if let token = UserManager.shared.token  {
                r.addValue("Token \(token)", forHTTPHeaderField: "Authorization")
            }
              
            let boundaryStart = "--\(boundaryConstant)\r\n"
            let boundaryEnd = "--\(boundaryConstant)--\r\n"
            let contentDispositionString = "Content-Disposition: form-data; name=\"\(file.fieldName)\"; filename=\"\(file.fileName)\"\r\n"
            let contentTypeString = "Content-Type: \(mimeType)\r\n\r\n"
            
            
            // Prepare the HTTPBody for the request.
            var requestBodyData = Data()
            requestBodyData.append(boundaryStart.data(using: .utf8)!)
            requestBodyData.append(contentDispositionString.data(using: .utf8)!)
            requestBodyData.append(contentTypeString.data(using: .utf8)!)
            requestBodyData.append(file.fileContents)
            requestBodyData.append("\r\n".data(using: .utf8)!)
            requestBodyData.append(boundaryEnd.data(using: .utf8)!)
             
            
            
            r.httpBody = requestBodyData
             
            return r
        }
        
        /// multypart data
        if let file = multipartFile {
            request = generateMultipartRequest(for: requestURL, file: file)
        }
        
        
        
        
        
        
        
        prettyPrint(request)
        
        urlSession.dataTask(with: request) {[weak self] (result) in
            
            guard let self = self else {
                completion(.failure(.internalManagerError))
                return
            }
            
            switch result {
                case .success(let (response, data)):
                    self.prettyPrint(response, data: data)
                    
                    let statCode = (response as? HTTPURLResponse)?.statusCode
 
                    /// do aditional checks
                    if let v = try? self.jsonDecoder.decode(ServerResponse<EmptyObject>.self, from: data) {
                     
                        var errors: [ErrorsResponse] = []
                         
                        
                        // Do check if backend return some errors list
                        if v.errors.count != 0 {
                            v.errors.forEach {errors.append($0)}
                        }
                        
                        if errors.count > 0 {
                            completion(.failure(.apiReturnErrorsList(errors))); return
                        }
                         
                        /// check the status code range
//                        if let statusCode = statCode, !(self.config.successRange ~= statusCode) { completion(.failure(.invalidResponseStatusCode(statCode ?? 0)));return }
                    }
                     
                    if let v = try? self.jsonDecoder.decode(ErrorDetailResponse.self, from: data),
                       !v.detail.isEmpty {
                        var errors: [ErrorsResponse] = [ErrorsResponse(key: "detailError", value: v.detail)]
                        completion(.failure(.apiReturnErrorsList(errors)) );return
                    }
                    
                    
                    
                    do {
                        if appendBaseContainer {
                            let values = try self.jsonDecoder.decode(ServerResponse<T>.self, from: data)
                            
                            if let d = values.data {
                                completion(.success(d))
                            } else {
                                completion(.failure(.noData))
                            }
                        } else {
                            let values = try self.jsonDecoder.decode(T.self, from: data)
                            completion(.success(values))
                        }
                         
                        
                    } catch {
                        print("❌ Decode Error:" , error)
                        completion(.failure(.decodeError))
                    }
                case .failure(let error): /// todo: pass error -> complition, test it !
                    completion(.failure(.requestError(error: error)))
                }
         }.resume()
    }
    
    
    
    
    
    
    //MARK: - Download Image/Resurces
    func download(_ patch: String, completion: @escaping (Result<Data, APIServiceError>) -> Void) {
         
        let requestURL = URL(string: patch)!
        
        var request  = URLRequest(url: requestURL)
         
        urlSession.dataTask(with: request) {[weak self] (result) in
            
            guard let self = self else {
                completion(.failure(.internalManagerError))
                return
            }
            
            
            switch result {
            
            case .failure(let err):
                
                print(err)
                completion(.failure(.requestError(error: err)))
                
                 
            case .success(let (response, data)):
                print(response)
                completion(.success(data))
                 
            }
            
            
            
            
        }
    }
        
        
        
        
    // MARK: - DEBUG print requests/response
    /*
     📤 - request
     📥 - response
     */
    
    private func prettyPrint(_ request: URLRequest, isRequest: Bool = true) {
        if config.showsRequests {
            
            let icon = isRequest ? "📤" : "📥"
            print("[\(icon) \(Timestamp())] \(request.url?.path ?? "URL ❌")")
             
            
            /// print request header
            if let header = request.allHTTPHeaderFields, config.showHeader && isRequest {
                print("🗒 Header: ", header.debugDescription)
            }
            
            
            
            if
                let body = request.httpBody,
                let str = String(data: body, encoding: .utf8),
                config.showsParams  {
                print(str)
            }
        }
    }
    private func prettyPrint(_ response: URLResponse, data: Data) {
        if
            let res = response as? HTTPURLResponse,
            config.showsRequests {
            
            let statusCode = res.statusCode
            let statusString = "\(statusCode) \(config.successRange ~= statusCode ? "": "❌")"
            
            print("[📥 \(Timestamp())] \(res.url?.path ?? "URL ❌") \(statusString)")
             
            if
                let str = String(data: data, encoding: .utf8),
                config.showsParams  {
                print(str)
            }
        }
    }
    
    private func Timestamp() -> String {
        return  DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .long)
    }
}



extension URLSession {
    
    func dataTask(with request: URLRequest, result: @escaping (Result<(URLResponse, Data), Error>) -> Void) -> URLSessionDataTask {
        return dataTask(with: request) { (data, response, error) in
        if let error = error {
            result(.failure(error))
            return
        }
        guard
            let response = response,
            let data = data else {
                let error = NSError(domain: "error", code: 0, userInfo: nil)
                result(.failure(error))
                return
        }
        result(.success((response, data)))
        }
    }
}



struct multipartFile {
    let fieldName: String
    let fileName: String
    let fileContents: Data
}
