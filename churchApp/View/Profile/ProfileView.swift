//Created for churchApp  (26.10.2020 )

import UIKit
import SwiftUI

struct ProfileView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var isEditing: Bool = false
    
    @State private var action: Int? = 0 /// nav tags for settings rows
      
    let data: myProfileResponse
     
    var body: some View {
            ZStack {
                if isEditing {
                    profileEditView(data: data, didShowing: $isEditing)
                        .opacity(isEditing ? 1 : 0)
                } else {
                    ScrollView {
                    VStack(alignment: .leading) {
                        Text("Personal Info")
                            .font(Font(commonAppearance.InterSemiBold.withSize(18)))
                            .padding(.top, 16)
                           
                        // MARK: - User Personal Info Rows
                        Group {
                            HStack  {
                                VStack(alignment: .leading) {
                                    Text("Name".uppercased())
                                        .font(Font(commonAppearance.InterSemiBold.withSize(12)))
                                        .foregroundColor(Color(UIColor(named: "Grey 4")!))
                                    
                                    Text(data.name)
                                }
                                
                                Spacer()
                                VStack(alignment:.trailing) {
                                    UrlImageView(urlString: data.avatar)
                                }
                            }
                        }
                            
                        // MARK: - User Info Rows
                        Group {
                            VerticalInfoView(title: "Email", value: data.email).padding(.top, -24)
                            VerticalInfoView(title: "Phone", value: data.phone ?? " -- ")
                            VerticalInfoView(title: "address", value: data.address ?? " -- ", valueWidth: 250)
                        }
                         
                        // MARK: - Settings Rows
                        Group {
                            VStack(spacing: 0) {
                                settingsRow(type: .dinnerParty, action: {action = 1}).padding(.top, 40)
                                settingsRow(type: .Notifications, action: {action = 2})
                                settingsRow(type: .DataStorage, action: {action = 3})
                                settingsRow(type: .permissions, action: {action = 4})
                                DividerView(topBottomPaddings: 0) .padding([.leading, .trailing], -24)
                            }.padding(.bottom, 40)
                              
                            NavigationLink(destination: SettingsView(type: .dinnerParty), tag: 1, selection: $action) { EmptyView() }
                            NavigationLink(destination: SettingsView(type: .Notifications), tag: 2, selection: $action) { EmptyView() }
                            NavigationLink(destination: SettingsView(type: .DataStorage), tag: 3, selection: $action) { EmptyView() }
                            NavigationLink(destination: SettingsView(type: .permissions), tag: 4, selection: $action) { EmptyView() }
                        }
                        
                        // MARK: - Help Block
                        Group {
                            VStack(alignment: .leading, spacing: 0) {
                                VStack(alignment: .leading, spacing: 0) {
                                    HStack {
                                        AppText(text: "Need help?", weight: .semiBold, size: 18)
                                        Spacer()
                                        NavigationLink(
                                            destination: ContactUsView(),
                                            label: {
                                                VStack {
                                                    AppText(text: "Contact us", weight: .semiBold)
                                                        .padding([.leading, .trailing], 16)
                                                        .padding([.top, .bottom], 8)
                                                }.overlay(Capsule().stroke(lineWidth: 2.0).foregroundColor(Color("Grey 1")))
                                            })
                                    }.padding(.top, 4)
                                    HStack {
                                        AppText(text: "Drop us a line if you have any questions or need help with your account. ", weight: .regular, size: 14, colorName: "Grey 2")
                                    }.padding(.top, 11)
                                }.padding(24)
                            }
                            .background(Color("Grey 6"))
                            .cornerRadius(16)
                        }
                         
                        Spacer()
                        // MARK: - SignOut Button
                        HStack {
                            Spacer()
                            Button(action: {
                                NotificationCenter.default.post(name: .signOut, object: nil)
                            }, label: {
                                Text("Sign Out").foregroundColor(Color("Red"))
                                    .font(Font(commonAppearance.InterSemiBold.withSize(12)))
                                    .padding(8)
                                    .padding([.leading, .trailing], 16)
                                    .overlay(RoundedRectangle(cornerRadius: 20.0) .stroke(lineWidth: 2.0).foregroundColor(Color("Red")))
                            })
                        }
                        .padding([.top, .bottom], 24)
                    }
                    .opacity(isEditing ? 0 : 1)
                    .padding(24)
                }
                }
            }
     
        
                    .navigationBarTitle("", displayMode: .inline)
                   .navigationBarBackButtonHidden(true)
                   .navigationBarItems(leading: Button(action : {
                       self.presentationMode.wrappedValue.dismiss()
                   }){
                       HStack {
                        Image("back-btn-icon").resizable().frame(width: 32, height: 32, alignment: .center)
                        AppText(text: "Settings", weight: .extraBold, size: 28)
                       }
                   },
                   
                   trailing:
                    
                    Button(action: {
                        withAnimation{ isEditing = true}
                             
                    }, label: {
                        AppText(text: "Edit", weight: .semiBold, size: 16, colorName: isEditing ? "Grey 5" : "Grey 1")
                            .padding([.leading, .trailing], 12)
                            .padding([.top, .bottom], 8)
                            .background(Color("Grey 6"))
                            .cornerRadius(18)
                    }).disabled(isEditing)
                   )
    }
} 

 
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        //settingsRow(type: .dinnerParty, action: {})
        ProfileView(data: myProfileResponse(ProfileDB()))
    }
}
