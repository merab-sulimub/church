//Created for churchApp  (13.11.2020 )

import SwiftUI


struct DemoMember: Identifiable {
    let id = UUID()
    let name: String = "Demo Member"
    let avatar: String
    
    
    static func generateDemoMembers(count: Int = 10) -> [DemoMember] {
        var tmp: [DemoMember] = []
        
        
        
        for _ in 0..<count {
            tmp.append(DemoMember(avatar: "/media/images/profiles/avatar_vJXVeym.png"))
        }
        
        return tmp
        
        
    }
}


let demoMembers: [DemoMember] = [
    DemoMember(avatar: "/media/images/profiles/avatar_vJXVeym.png"),
    DemoMember(avatar: "/media/images/profiles/avatar_vJXVeym.png"),
    DemoMember(avatar: "/media/images/profiles/avatar_vJXVeym.png"),
    DemoMember(avatar: "/media/images/profiles/avatar_vJXVeym.png"),
    DemoMember(avatar: "/media/images/profiles/avatar_vJXVeym.png"),
    DemoMember(avatar: "/media/images/profiles/avatar_vJXVeym.png")
    //DemoMember(avatar: "/media/images/profiles/avatar_vJXVeym.png")
    //DemoMember(avatar: "/media/images/profiles/avatar_vJXVeym.png")
    //DemoMember(avatar: "/media/images/profiles/avatar_vJXVeym.png")
]

 
struct MembersBlockView: View {
     
    let members: [FormsMembersResponse]
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 8) {
                
                AppText(text: "\(members.count) Members".uppercased()
                        , weight: .semiBold, size: 12, colorName: "Grey 2")
                 
                //if members.count >= 8 {
//                    HStack {
//                        ForEach(0..<4) { i in
//                            UrlImageView(urlString: members[i].avatar, size: 24)
//                        }
//                    }
//                    HStack {
//                        ForEach(5..<8) { i in
//                            UrlImageView(urlString: members[i].avatar, size: 24)
//                        }
//                        AppText(text: "\(members.count - 7)", weight: .semiBold, size: 12, colorName: "Grey 2")
//                            .frame(width: 24, height: 24, alignment: .center)
//                            .background(Color("Grey 4"))
//                            .clipShape(Circle())
//                    }
//                }
               
                
                var maxRows = members.count >= 5 ? 2 : 1
                    //(Double(members.count)/4.0).rounded(.awayFromZero)
                
                //Text("\(maxRows)")
                
                ForEach(0..<Int(maxRows)) { row in
                    //Text("row \(row)")
                    
                    HStack(alignment: .bottom) {
                        ForEach(range(for: row)) { i in
                            UrlImageView(urlString: members[i].avatar, size: 24)
                        }
                        
                        if row == 1 && members.count > 7 {
                            AppText(text: "\(members.count - 7)", weight: .semiBold, size: 12, colorName: "Grey 2")
                                .frame(width: 24, height: 24, alignment: .center)
                                .background(Color("Grey 4"))
                                .clipShape(Circle())
                        }
                    }
                    
                }
                
                
                
                
                
//                if members.count <= 7 && members.count >= 7 {
//                    HStack {
//                        ForEach(0..<4) { i in
//                            UrlImageView(urlString: members[i].avatar, size: 24)
//                        }
//                    }
//                    HStack {
//                        ForEach(5..<7) { i in
//                            UrlImageView(urlString: members[i].avatar, size: 24)
//                        }
//                    }
//                }
                
                    
                    
                    
//                HStack {
//                    AvatarView(image: "avatar", size: 24)
//                    AvatarView(image: "avatarSmall01", size: 24)
//                    AvatarView(image: "avatarSmall02", size: 24)
//                    AvatarView(image: "avatarSmall03", size: 24)
//                }
//
//                HStack {
//                    AvatarView(image: "avatarSmall02", size: 24)
//                    AvatarView(image: "avatarSmall03", size: 24)
//                    AvatarView(image: "avatarSmall01", size: 24)
//                    AppText(text: "5", weight: .semiBold, size: 12, colorName: "Grey 2") .frame(width: 24, height: 24, alignment: .center)
//                        .background(Color("Grey 4"))
//                        .clipShape(Circle())
//                }
            }
            .frame(width: 152-32, height: 111-32, alignment: .topLeading)
            .padding(16)
            .background(Color("Grey 6"))
            .cornerRadius(16.0)
        }
    }
    
    
//    func rows() -> Int {
//
//        if members.count >= 5 {
//            return 2
//        }
//
//        if members.count <= 4 {
//            return 1
//        }
//
//
//
//    }
    
    
    func range(for row: Int) -> Range<Int> {

        
        if row == 0 {
            if members.count >= 4 {
                return 0..<4
            } else {
                return 0..<members.count
            }
        }


        if row == 1 {
            if members.count >= 7 {
                return 4..<7
            } else {
                return 4..<members.count
            }
        }
        
        return 0..<0
    }
}

struct MembersBlockView_Previews: PreviewProvider {
    static var previews: some View {
        MembersBlockView(members: [FormsMembersResponse(id: 0, name: "123", avatar: "/images/profiles/avatar_vJXVeym.png", role: "member")] )
    }
}
