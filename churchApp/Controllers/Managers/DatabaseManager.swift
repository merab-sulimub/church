//Created for churchApp  (07.11.2020 )

import Foundation
import RealmSwift

class DatabaseController {
    
    let realm: Realm
    
    public static let shared = DatabaseController()
    private init()  {
        do {
            self.realm = try Realm()
        } catch {
            print(error)
            fatalError("❌ Realm: Can't be Init()") 
        }
    }
     
    
    func saveProfile(_ data: myProfileResponse, with token: String? = nil) {
        do {
            try realm.write {
                var tmp: [String : Any] = [
                    "id" : data.id,
                    "name": data.name,
                    "email": data.email,
                    "isMember": data.isMember,
                    "avatar": data.avatar as Any,
                    "phone": data.phone as Any,
                    "address": data.address as Any,
                    
                    "showDirrectNotifications": data.showDirrectNotifications as Any,
                    "showChatThreadNotifications": data.showChatThreadNotifications as Any,
                    "showDinnerPartiesNotification": data.showDinnerPartiesNotification as Any,
                    "showChurchNotifications": data.showChurchNotifications as Any
                ]
                
                // check if token exist
                if let t = token {
                    tmp["token"] = t
                }
                
                
                
                
                
                // check if user in DP
                if let dp = data.dinnerParty {
                    var members: [Any] = []
                    
                    if dp.members.count > 0 {
                        for m in dp.members {
                             
                            members.append([
                                "id": m.id,
                                "name": m.name,
                                "avatar": m.avatar ?? "",
                                "role": m.role
                            ])
                        }
                    }
                    
                     
                    tmp["DinnerParty"] = [
                        "id": dp.id,
                        "title": dp.title,
                        "date": dp.date,
                        "zip_code": dp.zipCode,
                        //"type"
                        "rsvp": dp.rsvp,
                        "latitude": dp.latitude,
                        "longitude": dp.longitude,
                        "members": members
                    ]
                    
                    //tmp["DinnerParty"]["members"]
                    
                    
                    
                    
                    
                } else {
                    tmp["DinnerParty"] = nil
                }
                 
//                    @objc dynamic var type = "online"
//                    @objc dynamic var rsvp = 0
//
//                    @objc dynamic var DinnerParty: [DinnerPartyMemberDB] = []
//
           
                realm.create(ProfileDB.self, value: tmp, update: .modified)
                 
                print("🗒 DB: Profile saved/updated !")
            }
              
        } catch let error {
          // Handle error
          print(error.localizedDescription)
        }
    }
     
    func MyProfile() -> ProfileDB? {
         
        
        if let profile = realm.objects(ProfileDB.self).first {
            if profile.isInvalidated {return nil} else {
                return profile
            }
           
        } else {
            return nil
        }
    }
     
     
    func clearDB() {
        do {
            let profile = realm.objects(ProfileDB.self).first
             
            try realm.write {
                
                if let p = profile, !p.isInvalidated {
                    realm.delete(p)
                } else {
                    print("❌ Database: isInvalidated ")
                }
                //realm.deleteAll()
            }
        } catch {
            print("❌ Database: clearDB error: \(error.localizedDescription)")
        }
        
    }
}
