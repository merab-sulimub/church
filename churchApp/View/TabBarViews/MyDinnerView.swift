//Created for churchApp  (28.10.2020 )

import SwiftUI

struct MyDinnerView: View {
    
    @State var showFindDPView = false
    
    @State var myProfile =  myProfileResponse(DatabaseController.shared.MyProfile() ?? ProfileDB())
    
    var body: some View {
        
        if
            myProfile.dinnerParty != nil  {
            DPInfoView(dp: myProfile.dinnerParty!)
             
        } else {
            VStack(alignment: .leading, spacing: 0) {
                //MARK: - HEADER
                ZStack {
                    HStack {
                        NavigationLink(
                            destination:
                                 
                                ProfileView(data: myProfile) ,
                            label: {
                                UrlImageView(
                                    urlString: myProfile.avatar,
                                    size: 40)
                                
                            })
                        Spacer()
                    }
                    HStack(alignment: .center) {
                        Image("C3NYC-logo-small")
                    }
                    
                }.background(Color.clear)
                
                .padding([.top, .bottom], 8)
                 
                AppText(text: "Join a Dinner Party", weight: .semiBold, size: 24, colorName: "Grey 1").padding(.top, 24)
                
                AppText(text: "Every Wednesday across New York City and beyond we meet at Dinner Parties to share stories, unpack scripture, pray, meet new friends and build community. Our prayer is that no one would be isolated.", weight: .regular, size: 16, colorName: "Grey 3").padding(.top, 8)
                 
                
                if myProfile.isMember == true
                   {
                    AppButton(type: .findDinnerParty) { showFindDPView = false }
                        .padding(.top, 32)
                        .opacity(0.6)
                        .disabled(true)
                    
                } else {
                    AppButton(type: .findDinnerParty) { showFindDPView.toggle() }
                        .padding(.top, 32)
                }
                 
                /// some bug with callback in
                NavigationLink(
                    destination: FindDPController().navigationBarTitle("", displayMode: .inline)
                    
                    
                    ,
                    isActive: $showFindDPView, label: {})
                
                Spacer()
            }.padding([.leading, .trailing], 24)
            
            .onAppear {
                myProfile = myProfileResponse(DatabaseController.shared.MyProfile() ?? ProfileDB())
            }
            
            .navigationBarHidden(true)
        }
        
        
        
        
        
    }
}

struct MyDinnerView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MyDinnerView()
        }
    }
}


class MyDinnerHostingController: UIHostingController<MyDinnerView> {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder,rootView: MyDinnerView());
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
