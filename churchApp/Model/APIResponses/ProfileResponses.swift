//Created for churchApp  (15.11.2020 )

import Foundation



struct UpdateAvatarResponse: Decodable {
    let avatar: String
}

struct RemoveAvatarResponse: Decodable {
    let profile: CompactProfileResponse
}


struct CompactProfileResponse: Decodable {
    let id: Int
    let name: String
    let email: String
    let phone: String?
    let is_member: Bool?
    let address: String?
    let avatar: String?
    
}

//"profile": {
//  "id": 74,
//  "name": "dev dev",
//  "email": "dev11@dev.com",
//  "phone": null,
//  "is_member": false,
//  "address": null,
//  "avatar": null
//}


//"avatar": "/media/media/images/profiles/Screen%20Shot%202020-11-14%20at%2022.47.23.png"
