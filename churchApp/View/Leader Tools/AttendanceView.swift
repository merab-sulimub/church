//Created for churchApp  (30.10.2020 )

import SwiftUI

struct AttendanceView: View {
    @State var searchText: String = ""
    
    @State var isError = false
    @State var errorString = ""
    
    @State var memberList: [MembersDemoList] = demoMembersEditList
    
    @State var submitBtnText = "Submit"
    
    
    var body: some View {
        let binding = Binding<String>(get: { self.searchText },
                        set: { self.searchText = $0
                    // do whatever you want here
                    //filterResult(by: $0)
                    print($0)
                })
        let rowEdges = EdgeInsets(top: 18, leading: 24, bottom: 18, trailing: 24)
        
        VStack(alignment: .leading) {
            AppText(text: "Attendance", weight: .semiBold, size: 24).padding(.top, 40)
            AppText(text: "Week of October 28, 2020", weight: .regular, size: 14, colorName: "Grey 3")
            /// Search box
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 16).frame(height: 48).foregroundColor(Color("Grey 6"))
                    TextField("Add a note...", text: binding).padding([.leading, .trailing], 16)
                }
            }
            
            ZStack(alignment: .bottom) {
                
                List {
                    
                    Section(footer: Color.clear.frame(height: 64)) {
                        ForEach(memberList.indices) { member in
                            AttendanceViewRow(data: self.$memberList[member], action: { updateSubmit() }).listRowInsets(rowEdges)
                        }
                    }
                     
                }
                
                .padding([.leading, .trailing], -24)
                .listSeparatorStyle()
                
                AppButton(type: .findDinnerParty, shadowsRadius: 0, title: submitBtnText, LRpaddings: 0) {
                    print("Submit tapped")
                }
                .disabled(submitCount() == 0)
                .opacity(submitCount() == 0 ? 0.8 : 1)
            }
             
            
            Spacer()
        }
        .padding([.leading, .trailing], 24)
        .alert(isPresented: $isError) { () -> Alert in
            Alert(title: Text(""), message: Text(errorString), dismissButton: .default(Text("Ok")) {
                    self.isError = false
                    self.errorString = ""
            }  )
        }
        .onAppear() { updateList() }
    }
    
    
    
    func submitCount() -> Int {
        return memberList.filter {$0.approved != $0.declined}.count
    }
    
    func updateSubmit() {
      let count = submitCount()
        
        if count > 0 {
            submitBtnText = "Submit \(count)"
        } else {
            submitBtnText = "Submit"
        }
    }
    
    func updateList() {
        self.memberList = demoMembersEditList
        
        //demoMembersEditList.forEach({ self.memberList.append($0)})
    }
}

struct AttendanceView_Previews: PreviewProvider {
    static var previews: some View {
        AttendanceView()
    }
}



struct AttendanceViewRow: View {
    @Binding var data: MembersDemoList
    let action: () -> Void
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            VStack {
                AvatarView(image: data.avatar,size: 40)
            }
            VStack(alignment: .leading) {
                AppText(text: data.name, weight: .semiBold, size: 18)
                    .lineLimit(1)
                
                HStack(alignment: .center, spacing: 16) {
                    AppText(text: data.role, weight: .regular, size: 14, colorName: "Grey 3")
                }
            }
            Spacer()
            VStack(alignment: .leading) {
                HStack(spacing: 8) {
                    Image(data.declined ? "decline-active-icon" : "decline-icon").frame(width: 32, height: 32, alignment: .center).onTapGesture(count: 1, perform: {
                        data.declined.toggle()
                        
                        if !data.declined && !data.approved {data.declined = true; data.approved = true}
                        
                        action()
                         
                    })
                    Image(data.approved ? "approve-active-icon" : "approve-icon").frame(width: 32, height: 32, alignment: .center).onTapGesture(count: 1, perform: {
                        data.approved.toggle()
                        
                        if !data.declined && !data.approved {data.declined = true; data.approved = true}
                        
                        action()
                    })
                }
            }
        }
        
    }
}
