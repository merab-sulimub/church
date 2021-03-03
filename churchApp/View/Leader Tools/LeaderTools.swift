//Created for churchApp  (27.10.2020 )

import SwiftUI

struct LeaderTools: View {
    
    @State var welcomeEditorPresented = false
    @State var mealEditorPresented = false
    @State var membersEditorPresented = false
    @State var attendanceIsPresented = false
    
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 0) {
                HStack {Spacer()} /// use full width
                ///HEADER
               
                    AppText(text: "Cobble Hill", weight: .semiBold, size: 28, colorName: "Grey 1")
                    AppText(text: "Dinner Party", weight: .semiBold, size: 14, colorName: "Grey 3")
          
                
                ///Members & buttons block
                HStack(alignment: .top, spacing: 0) {
                    // MARK: Block: Left side
                    VStack(alignment: .leading) {
                        VStack(alignment: .leading, spacing: 8) {
                            AppText(text: "12 Members".uppercased(), weight: .semiBold, size: 12, colorName: "Grey 2")
                            HStack {
                                AvatarView(image: "avatar", size: 24)
                                AvatarView(image: "avatarSmall01", size: 24)
                                AvatarView(image: "avatarSmall02", size: 24)
                                AvatarView(image: "avatarSmall03", size: 24)
                            }
                            HStack {
                                AvatarView(image: "avatarSmall02", size: 24)
                                AvatarView(image: "avatarSmall03", size: 24)
                                AvatarView(image: "avatarSmall01", size: 24)
                                AppText(text: "5", weight: .semiBold, size: 12, colorName: "Grey 2") .frame(width: 24, height: 24, alignment: .center)
                                    .background(Color("Grey 4"))
                                    .clipShape(Circle())
                            }
                            
                        }.padding(16)
                    }
                    .onTapGesture(count: 1, perform: { membersEditorPresented.toggle() })
                    .sheet(isPresented: $membersEditorPresented, content: { MembersEditor() })
                    .background(Color("Grey 6"))
                    .cornerRadius(16)
                    
                    Spacer()
                      
                    // MARK: Block: Right side
                    VStack(alignment: .leading) {
                        AppButton(type: .newMessage, textPading: 4) {  }.padding(.bottom, 16)
                         
                        AppButton(type: .roundedWhite, shadowsRadius: 0, textPading: 4) { welcomeEditorPresented.toggle() }
                            .sheet(isPresented: $welcomeEditorPresented, content: {
                                WelcomeVideoLeader(isPresented: self.$welcomeEditorPresented)
                            })
                            .overlay(Capsule().stroke(Color("borderColor 1"), lineWidth: 2))
                        
                    }.padding(.leading, 12)
                    Spacer()
                }.padding(.top, 24)
                DividerView().padding([.leading, .trailing], -24)
                 
                /// Week OF header
                    HStack {
                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                            Image("back-btn-icon")
                        })
                        Spacer()
                        VStack {
                            AppText(text: "Week of".uppercased(), weight: .semiBold, size: 12, colorName: "Grey 4")
                            AppText(text: "October 21, 2020", weight: .semiBold, size: 18, colorName: "Grey 1").padding(.top, 2)
                        }
                        Spacer()
                        
                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                            Image("back-btn-icon").rotationEffect(.degrees(180))
                        })
                    }
                    
                VStack(alignment: .leading, spacing: 0) {
                    AppText(text: "Attendance", weight: .semiBold, size: 18)
                    
                    HStack(alignment: .center, spacing: 0, content: {
                        Circle()
                            .foregroundColor(Color.red)
                            .frame(width: 10, height: 10, alignment: .center)
                            .padding(.trailing, 6)
                        AppText(text: "Incomplete", weight: .regular, size: 14, colorName: "Grey 3")
                    })
                    
                }
                .onTapGesture(perform: { attendanceIsPresented.toggle() })
                .sheet(isPresented: $attendanceIsPresented, content: { AttendanceView() })
                .padding(.top, 32)
            
                
                VStack(alignment: .leading) {
                    AppText(text: "Meal", weight: .semiBold, size: 18)
                    AppText(text: "Bring your own", weight: .regular, size: 14, colorName: "Grey 3")
                    
                }.padding(.top, 32).onTapGesture(perform: {
                    mealEditorPresented.toggle()
                }).sheet(isPresented: $mealEditorPresented, content: {
                    EditMeal()
                })
                
                
                
                Spacer()
            }.padding([.leading, .trailing], 24)
        }
        
        .navigationBarTitle("Leader Tools")
    }
}

struct LeaderTools_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LeaderTools()
        }
    }
}








struct AppText: View {
    
    let text: String
    var weight: AppFonts = .regular
    var size: CGFloat = 16.0
    var colorName: String = "Grey 1"
    var color: Color?
    
    var body: some View {
        Text(text).font(.app(size: size, weight: weight)).foregroundColor(color != nil ? color! :Color(colorName))
    }
}



public enum AppFonts: String {
    case extraBold = "Inter-Bold"
    case bold = "Inter-ExtraBold"
    case semiBold = "Inter-SemiBold"
    case regular = "Inter-Regular"
}


extension Font {
    public static func app(size: CGFloat, weight: AppFonts = .regular) -> Font {
        return Font.custom(weight.rawValue, size: size)
    }
}
