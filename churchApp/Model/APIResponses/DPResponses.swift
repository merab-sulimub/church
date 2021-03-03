//Created for churchApp  (15.10.2020 )

import Foundation
import RealmSwift

struct AskUsResponse: Decodable {  let response: String  }

 
struct FindPartiesResponse: Decodable {
    let dpList: [FindPartyResponse]
}

struct FindPartyResponse: Decodable {
    let id: Int
    let title: String
    let date: Date
    let zipCode: Int
    let members: [FormsMembersResponse]
    //let highlights:
    let latitude: Float
    let longitude: Float
    let rsvp: Int?
    
    let formQuestions: [FormQuestionsResponse]
}


extension FindPartyResponse {
    init(_ p: DinnerPartyDB) {
        id = p.id
        title = p.title
        date = p.date
        zipCode = p.zip_code
        latitude = p.latitude
        longitude = p.longitude
        
        rsvp = p.rsvp.value
        
        ///todo
        var memArr: [FormsMembersResponse] = []
        
        
        for m in p.members {
            memArr.append(FormsMembersResponse(id: m.id, name: m.name, avatar: m.avatar.isEmpty ? nil : m.avatar, role: m.role) )
        }
        
        members = memArr
        formQuestions = []
    }
}


struct FormsMembersResponse: Decodable {
    let id: Int
    let name: String
    let avatar: String?
    let role: String
}
 
struct FormQuestionsResponse: Decodable {
    let id: Int
    let churchId: Int
    let question: String
    var answers: [FormAnswersResponse]
     
}

struct FormAnswersResponse: Decodable {
    let id: Int
    let body: String
    var checked: Bool? = false
}


class DinnerPartyDB: Object {
     
    @objc dynamic var id = 0
    @objc dynamic var title = ""
    @objc dynamic var date = Date()
    @objc dynamic var zip_code = 0
    
    @objc dynamic var type = "online"
    let rsvp = RealmOptional<Int>()
    
    let members = List<DinnerPartyMemberDB>()
    
    @objc dynamic var latitude: Float = 0.0
    @objc dynamic var longitude: Float = 0.0
    
    
    override static func primaryKey() -> String? {
        "id"
    }
}


class DinnerPartyMemberDB: Object {
     
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var avatar = ""
    @objc dynamic var role = ""
    
    override static func primaryKey() -> String? {
        "id"
    }
}
