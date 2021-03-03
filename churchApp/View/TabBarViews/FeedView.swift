//Created for churchApp  (18.10.2020 )

import UIKit
import SwiftUI

struct FeedView: View {
    @State var loader: Bool = false
    
    @State var isLive: Bool = true
    @State var isLeader: Bool = false
    
    @State var showFindDP = false
    @State var showStream = false
    
    @State var showOnboarding: Bool = false
     
    @State var myProfile = myProfileResponse(DatabaseController.shared.MyProfile() ?? ProfileDB())
    
    var body: some View {
        ZStack { /// loader
            VStack(spacing: 0) {
                //MARK: - HEADER
                ZStack {
                    HStack {
                        NavigationLink(
                            destination: ProfileView(data: myProfile) ,
                            label: {
                                UrlImageView( urlString: myProfile.avatar, size: 40)
                            })
                        Spacer()
                        NavigationLink(
                            destination: WelcomeLiveController(shows: $showStream).navigationBarHidden(true),
                            isActive: $showStream,
                            label: {})
                    }
                    HStack(alignment: .center) {
                        if isLive {
                            
                            if !isLeader {Spacer()}
                            
                            AppButton(type: .wachLive) {
                                withAnimation { loader = true }
                                
                                AgoraManager.shared.login { (status, msg) in
                                    withAnimation { loader = false }
                                    if status {
                                        self.showStream = true
                                    } else {
                                        /// show error
                                    }
                                }
                            }.padding([.trailing, .leading], 0)
                        } else {
                            Image("C3NYC-logo-small")
                        }
                    }
                    
                    if isLeader {
                    HStack {
                        Spacer()
                        NavigationLink(
                            destination: LeaderTools(),
                            label: { Image("burger-icon") })
                        }
                    }
                    
                }.background(Color.clear)
                .padding([.leading, .trailing], 24)
                .padding([.top, .bottom], 8)
                 
                //MARK: - CONTENT
                ScrollView(.vertical) {
                     
                    VStack(alignment: .leading) {
                        Text("Welcome to your feed")
                            .font(Font(commonAppearance.InterSemiBold.withSize(24)))
                            .foregroundColor(Color("Grey 1"))
                             
                            .padding([.top, .bottom], 8)
                        
                        Text("This is where updates from the church will appear. As you get connected, this is where you’ll also get Dinner Party and events reminders, as well as your latest messages from friends in the church.")
                            .font(Font(commonAppearance.InterRegular.withSize(16)))
                            .foregroundColor(Color("Grey 3"))
                         
                    }.padding([.leading, .trailing], 24)
                     
                    DividerView()
                    
                    if let dp = myProfile.dinnerParty {
                        HStack {
                            
                            VStack(alignment: .leading) {
                                AppText(text: "Dinner Party", weight: .semiBold, size: 24)
                                AppText(text: dp.date.formated(.thisDayMMdd), weight: .regular, size: 14, colorName: "Grey 3")
                            }
                            Spacer()
                            
                            
                            Button(action: {}, label: {
                                AppText(text: "RSVP", weight: .semiBold, size: 16).padding([.leading, .trailing], 16)
                            })
                            .frame(height: 40)
                            .overlay(Capsule().stroke(Color("Grey 1"), lineWidth: 2))
                             
                        }.padding([.leading, .trailing], 24)
                    } else { 
                        if myProfile.isMember == true
                        {
                            AppButton(type: .findDinnerParty) { showFindDP = false }
                                .padding(.top, 32)
                                .opacity(0.6)
                                .disabled(true)
                            
                        } else {
                            AppButton { showFindDP.toggle() }
                        }
                        
                        
                        
                    }
                     
                    /// some bug with callback in
                    NavigationLink(
                        destination: FindDPController()
                            .navigationBarTitle("", displayMode: .inline),
                        isActive: $showFindDP, label: {})
                    DividerView()
                     
                    VStack{
                        HStack {
                            Text("Latest message".uppercased())
                                .font(Font(commonAppearance.InterSemiBold.withSize(12)))
                                .foregroundColor(Color("Grey 4"))
                            Spacer()
                        }
                        
                        Image("lstMsgFeed")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                         
                        HStack {
                            Text("Tap to watch or listen to this weeks’ message.")
                                .font(Font(commonAppearance.InterRegular .withSize(14)))
                                .foregroundColor(Color("Grey 4"))
                            Spacer()
                        }
                    }.padding([.leading, .trailing], 24)
                     
                    Spacer()
                }
                .navigationBarHidden(true)
            }
            // Loader
            LoaderView(show: loader)
            
            NavigationLink(
                destination: OnboardingController(shows: $showOnboarding)
                    ,
                isActive: $showOnboarding,
                label: {})
              
        }.onAppear() {
            // check onboarding
            showOnboarding = UserManager.shared.showOnboarding
            print("DEBUG: onAppear Feed showOnboarding: \(showOnboarding)")
            
            
            //renew profile var
            
            myProfile = myProfileResponse(DatabaseController.shared.MyProfile() ?? ProfileDB())
            print("Update myProfile data")
           
            
            if
                let profile = DatabaseController.shared.MyProfile(),
                let dp = profile.DinnerParty {
                
                let resp = FindPartyResponse(dp)
                 
                resp.members.forEach { if $0.role == "leader" {
                    isLeader = true
                    print("✅ Leader Detected")
                }
                }
            }
        }
        
        
        .navigationBarTitle("") //this must be empty
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        
    }
}

struct FeedSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            FeedView(showOnboarding: true)
        }
    }
}
 


struct FindDPController: UIViewControllerRepresentable {
    typealias UIViewControllerType = FindDinnerViewController
     
    func makeUIViewController(context: Context) -> FindDinnerViewController {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "FindDinnerViewController") as! FindDinnerViewController
        return vc
    }
    
    func updateUIViewController(_ uiViewController: FindDinnerViewController, context: Context) {
    }
}


struct WelcomeLiveController: UIViewControllerRepresentable {
    typealias UIViewControllerType = WelcomeLiveViewController
     
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var shows: Bool
    
    
    
    class Coordinator: NSObject, UINavigationControllerDelegate {
        var parent: WelcomeLiveController

        init(_ parent: WelcomeLiveController) {
            self.parent = parent
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func dissmiss() {
        print("dissmiss")
        shows = false
        presentationMode.wrappedValue.dismiss()
    }
    
    func makeUIViewController(context: Context) -> WelcomeLiveViewController {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "WelcomeLiveViewController") as! WelcomeLiveViewController
        vc.dismissCallback = dissmiss
        return vc
    }
    
    func updateUIViewController(_ uiViewController: WelcomeLiveViewController, context: Context) {
    }
}
 


struct OnboardingController: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var shows: Bool
    
    
    func dissmiss() {
        print("dissmiss")
        shows = false
        presentationMode.wrappedValue.dismiss()
    }
    
    
    func makeUIViewController(context: Context) -> WelcomeViewController {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "WelcomeViewController") as! WelcomeViewController
        
        vc.dismissCallback = dissmiss
        return vc
    }
    func updateUIViewController(_ uiViewController: WelcomeViewController, context: Context) {
    }
    
    typealias UIViewControllerType = WelcomeViewController
}
