//Created for churchApp  (15.10.2020 )

import Foundation
import RealmSwift
 
 
struct SignInResponse: Decodable {
    let token: String?
    let profile: myProfileResponse
}

struct myProfileResponse: Decodable {
    let id: Int
    let name: String
    let email: String
    let phone: String?
    let address: String?
    var avatar: String?
    
    let isMember: Bool
    
    var token = ""
    
    /// Notifications
    let showDirrectNotifications: Bool?
    let showChatThreadNotifications: Bool?
    let showDinnerPartiesNotification: Bool?
    let showChurchNotifications: Bool?
    
    let dinnerParty: FindPartyResponse?
    
    
    private enum CodingKeys : String, CodingKey {
            case id, name, email, phone , address, avatar, isMember, showDirrectNotifications, showChatThreadNotifications, showDinnerPartiesNotification, showChurchNotifications, dinnerParty
        }
}


extension myProfileResponse {
     
    init(_ p: ProfileDB) {
        id = p.id
        name = p.name
        email = p.email
        token = p.token
        phone = p.phone
        address = p.address
        avatar = p.avatar
        
        isMember = p.isMember
        
        
        showDirrectNotifications = p.showDirrectNotifications
        showChatThreadNotifications = p.showChatThreadNotifications
        showDinnerPartiesNotification = p.showDinnerPartiesNotification
        showChurchNotifications = p.showChurchNotifications
        
        if let dp = p.DinnerParty {
            dinnerParty = FindPartyResponse(dp)
        } else {
            dinnerParty = nil
        }
    }
}





class ProfileDB: Object {
     
    @objc dynamic var id = 0
    @objc dynamic var token = ""
    @objc dynamic var name = ""
    @objc dynamic var email = ""
    
    @objc dynamic var isMember = false
    
    @objc dynamic var phone: String?
    @objc dynamic var address: String?
    @objc dynamic var avatar: String?
    
    
    @objc dynamic var showDirrectNotifications = false
    @objc dynamic var showChatThreadNotifications = false
    @objc dynamic var showDinnerPartiesNotification = false
    @objc dynamic var showChurchNotifications = false
    
    @objc dynamic var DinnerParty: DinnerPartyDB?
    
    override static func primaryKey() -> String? {
        "id"
    }
}




// MARK: - new profile response, last backend update
 
/*
"profile":{
         "id":48,
         "name":"Dev name Dev last name",
         "email":"dev@dev.com",
         "phone":null,
         "address":"Address is here",
         "show_dirrect_notifications":false,
         "show_chat_thread_notifications":false,
         "show_dinner_parties_notification":false,
         "show_church_notifications":false,
    */
