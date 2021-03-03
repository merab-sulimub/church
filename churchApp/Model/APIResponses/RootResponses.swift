//Created for churchApp  (15.10.2020 )

import Foundation


struct EmptyObject: Decodable { }
struct ErrorDetailResponse: Decodable { let detail: String }
struct ErrorMessageResponse: Decodable { let message: String }

struct ResponseResponse: Decodable { let response: String }

struct ErrorsResponse: Decodable {
    let key: String
    let value: String
}

struct ServerResponse<Element: Decodable>: Decodable {
    let data: Element?
    var errors: [ErrorsResponse] = []
    
    var errorsList: String {return getErrorDescription()}
    
    
    enum CodingKeys: String, CodingKey {
        case data,errors
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decode(Element.self, forKey: .data)
        
        
        if let error = try? container.decode(ErrorMessageResponse.self, forKey: .errors) {
            errors.append(ErrorsResponse(key: "message", value: error.message))
        }
        
        if let error = try? container.decode(ErrorDetailResponse.self, forKey: .errors) {
            errors.append(ErrorsResponse(key: "message", value: error.detail))
        }
        
        /// todo: test it !
        if let errorsArr = try? container.decode([ErrorsResponse].self, forKey: .errors) {
            errorsArr.forEach {errors.append($0)}
        }
    }
    
    private func getErrorDescription() -> String {
        if errors.count > 0 {
            return self.errors.compactMap({$0.value}).joined(separator: "\n")
        }
        return NSLocalizedString("no errors", comment: "")
    }
}

 
