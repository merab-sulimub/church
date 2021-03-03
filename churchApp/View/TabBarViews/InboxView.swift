//Created for churchApp  (29.10.2020 )

import SwiftUI
struct InboxDemoData: Identifiable {
    let id = UUID()
    let name: String
    let messages: [messageDemoData]
    let members: [membersDemoData]
    
    
    
    func getTime() -> String {
        return messages.last != nil ? messages.last!.date.formated(.hoursAndMinutes) : ""
    }
    
}


struct messageDemoData: Identifiable {
    let id = UUID()
    let text: String
    let date: Date
     
    
    static func generateMessages(_ count: Int) -> [messageDemoData] {
        var tmp: [messageDemoData] = []
        
        for i in 0..<count {
            tmp.append(messageDemoData(text: "message \(i)", date: Date(timeIntervalSinceNow: Double(-i*60) ) )
            )
        }
        
        return tmp
    }
}


struct membersDemoData: Identifiable {
    let id = UUID()
    let name: String
    let avatar: String
    
    
    static func generate(_ count: Int) -> [membersDemoData] {
        var tmp: [membersDemoData] = []
        
        let demoMembers: [membersDemoData] = [
            oneDemoinbox, DemoInbox2, DemoInbox3, DemoInbox4
        ]
        
        for _ in 0..<count {
            if let randomUsr = demoMembers.randomElement() {
                tmp.append(randomUsr)
            }
        }
        return tmp
    }
}

var oneDemoinbox = membersDemoData(name: "First Last", avatar: "avatar")
var DemoInbox2 = membersDemoData(name: "First Last", avatar: "avatarSmall01")
var DemoInbox3 = membersDemoData(name: "First Last", avatar: "avatarSmall02")
var DemoInbox4 = membersDemoData(name: "First Last", avatar: "avatarSmall03")


var inboxDemoData = InboxDemoData(name: "Looking for a roommate", messages: messageDemoData.generateMessages(20), members: membersDemoData.generate(102) )


var demoSampleInbox: [InboxDemoData] = [
    InboxDemoData(name: "Dinner Party Leaders",
                  messages: messageDemoData.generateMessages(42),
                  members: membersDemoData.generate(4)),
    InboxDemoData(name: "Benjamin Baptist", messages: messageDemoData.generateMessages(10), members: membersDemoData.generate(14)),
    InboxDemoData(name: "DP this week!", messages: messageDemoData.generateMessages(200), members: membersDemoData.generate(1)),
    InboxDemoData(name: "South BK Classifieds", messages: messageDemoData.generateMessages(95), members: membersDemoData.generate(1)),
    
    inboxDemoData
]

struct InboxView: View {
    
    let Insets = EdgeInsets( top: 0, leading: 24, bottom: 0, trailing: 24)
    
    @State var inboxList: [InboxDemoData] = demoSampleInbox
    @State var pinnedList: [InboxDemoData] = [inboxDemoData]
    init() {
        if #available(iOS 14.0, *) {
            // iOS 14 doesn't have extra separators below the list by default.
        } else {
            // To remove only extra separators below the list:
            UITableView.appearance().tableFooterView = UIView()
        }

        // To remove all separators including the actual ones:
        UITableView.appearance().separatorStyle = .none
    }
    
    var body: some View {
       return VStack(alignment: .leading) {
            
            AppText(text: "Inbox", weight: .semiBold, size: 24.0).padding([.leading, .trailing], 24)
             
            List {
                Section(header: InboxListHeader(text: "PINNED")) {
                    ForEach(pinnedList, id: \.id) { pinned in
                        InboxViewRow(data: pinned)
                    }
                }
                
                Section(header: InboxListHeader(text: "ALL MESSAGES") ) { //DividerView()
                    
                    ForEach(inboxList, id: \.id) { list in
                        InboxViewRow(data: list)
                    }
                }
            }
            .listSeparatorStyle()
            .listStyle(GroupedListStyle())// Leave off for sticky headers
             
            Spacer()
        }
    }
}
 



struct InboxViewRow: View {
    
    @State var isOnline = true
    
    var data: InboxDemoData
     
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            //HStack {Spacer()}
            HStack(alignment: .top) {
                // MARK: Left Side
                VStack(alignment: .leading, spacing: 4) {
                    HStack(alignment: .bottom, spacing: 4) {
                        AppText(text: data.name, weight: .semiBold, size: 18).lineLimit(1)
                        AppText(text: data.getTime(), weight: .regular, size: 10, colorName: "Grey 4")
                            .lineLimit(1)
                    }.padding(.top, 4)
                    
                    HStack(alignment: .center, spacing: 0) {
                        
                        if isOnline {
                            Circle()
                                .frame(width: 10, height: 10, alignment: .center)
                                .foregroundColor(.green)
                                .padding(.trailing, 8 )
                        }
                        
                        AppText(text: "\(data.messages.count) new messages", weight: .regular, size: 14, colorName: "Grey 3").lineLimit(1)
                    }
                }
                Spacer()
                // MARK: Right Side - avatars block
                VStack {
                    ZStack {
                        if data.members.count > 3 {
                            ForEach(0..<3) { indx in
                                AvatarView(image: data.members[indx].avatar, size: 32)
                                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                    .offset(x: CGFloat(-12*indx))
                            }
                            
                            AppText(text: "\(data.members.count)", weight: .semiBold, size: 10, color: .white).padding(4)
                                .background(Color("Grey 4"))
                                .cornerRadius(8)
                                .offset(x: 10, y: 16)
                                  
                        } else {
                            if data.members.count == 1 {
                                AvatarView(image: data.members[0].avatar, size: 40)
                                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                            }
                            else {
                                ForEach(0..<data.members.count) { indx in
                                     
                                    AvatarView(image: data.members[indx].avatar, size: 32)
                                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                        .offset(x: CGFloat(-12*indx))
                                }
                            }
                        }
                    }
                    
                    
                }.padding(.leading, 32)
            }
        }
        .navigationBarHidden(true)
        
    }
}


struct InboxView_Previews: PreviewProvider {
    static var previews: some View {
        InboxView()
        //InboxViewRow(data: inboxDemoData)
    }
}



class InboxHostingController: UIHostingController<InboxView> {
    required init?(coder: NSCoder) {
        super.init(coder: coder,rootView: InboxView());
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
