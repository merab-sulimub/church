//Created for churchApp  (29.10.2020 )

import SwiftUI


struct MembersDemoList: Identifiable {
    let id = UUID()
    let name: String
    let avatar: String
    var role: String
    
    var approved: Bool = true
    var declined: Bool = true
}


let demoMembersEditList = [
    MembersDemoList(name: "Matthew Harris", avatar: "avatar", role: "Leader"),
    MembersDemoList(name: "Johnny Appleseed", avatar: "avatar1", role: "Leader"),
    MembersDemoList(name: "Sarah Jenkins", avatar: "avatar2", role: "Member"),
    MembersDemoList(name: "Jasmine Herold", avatar: "avatar3", role: "Member"),
    MembersDemoList(name: "Michael Trinity", avatar: "avatar4", role: "Leader"),
    MembersDemoList(name: "Benjamin Baptist", avatar: "avatar5", role: "Member"),
    MembersDemoList(name: "Meredith James", avatar: "avatar6", role: "Leader")
]
 

struct MembersEditor: View {
    
    @State var showHelp = false
    
    @State var memberList: [MembersDemoList] = []
    
    let rowEdges = EdgeInsets(top: 18, leading: 0, bottom: 18, trailing: 0)
    
    
    var body: some View {
        VStack(alignment: .leading) {
            
            // MARK: - HEADER
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    AppText(text: "Members", weight: .semiBold, size: 24)
                    AppText(text: "Cobble Hill Dinner Party", weight: .regular, size: 14, colorName: "Grey 3")
                }
                Spacer()
                VStack {
                    AppButton(type: .roundedWhite, shadowsRadius: 0, title: "HELP", enableHstack: false) { self.showHelp.toggle() }
                        .sheet(isPresented: $showHelp, content: { LeaderHelpView(isPresented: $showHelp) })
                    
                    .overlay(Capsule().stroke(Color("borderColor 1"), lineWidth: 2))
                }
            }.padding(.top, 40)
            
            List {
                ForEach(memberList, id: \.id) { member in
                    MembersEditorRow(data: member).listRowInsets(rowEdges)
                }
            }
            .listSeparatorStyle().onAppear() {updateListData()}
             
          
        }
        .padding([.leading, .trailing], 24)
    }
     
    func updateListData() {
        demoMembersEditList.forEach({ self.memberList.append($0)})
       
    }
}



struct MembersEditorRow: View {
    
    @State var removeTap = false
    @State var writeNewMessage = false
    
    
    var data: MembersDemoList
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            VStack {
                AvatarView(image: data.avatar,size: 40)
            }
            VStack(alignment: .leading) {
                AppText(text: data.name, weight: .semiBold, size: 18).lineLimit(1)
                
                HStack(alignment: .center, spacing: 16) {
                    AppText(text: data.role, weight: .regular, size: 14, colorName: "Grey 3")
                    
                    
                    
                    AppText(text: "Remove", weight: .semiBold, size: 12, color: Color.red).onTapGesture(count: 1, perform: {
                        print("Remove tapped")
                        removeTap.toggle()
                    })
                }
            }
            Spacer()
            VStack(alignment: .leading) {
                ZStack {
                    Circle().frame(width: 40, height: 40, alignment: .center).foregroundColor(.gray).opacity(0.05)
                    Image("write-new-message")
                   
                }
                .onTapGesture(count: 1, perform: {
                    writeNewMessage.toggle()
                    print("tapped on write new message")
                })
                
            }
        }
        
    }
}




struct MembersEditor_Previews: PreviewProvider {
    static var previews: some View {
        MembersEditor()
    }
}
