//Created for churchApp  (13.11.2020 )

import SwiftUI

struct profileEditView: View {
    @State var data: myProfileResponse
     
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var email: String = ""
    @State var phone: String = ""
    @State var address: String = ""
    
    @State var newAvatar: Image?
     
    @Binding var didShowing: Bool
     
    @State private var cameraPresented = false
    
    
    @State var loader: Bool = false
    @State var isError = false
    @State var errorString = ""
    
    
    
    @State var camera = CameraModel()
    
    var body: some View {
         ZStack {
            ScrollView {
                NavigationLink(
                    destination:
//                        CameraViewV2().environmentObject(camera).onDisappear{
//                            camera.stopSession()
//                        }, //
                        CameraView(isPresented: $cameraPresented, type: .profilePhoto)
                        .environmentObject(camera)
                        .onDisappear{ camera.stopSession() } 
                    ,
                    isActive: $cameraPresented,
                    label: { })
                 
                VStack(alignment: .leading, spacing: 0) {
                    
                    AppText(text: "Profile photo", weight: .semiBold, size: 12, colorName: "Grey 4")
                        .padding(.bottom ,16)
                    
                    // MARK: - Avatar Block
                    HStack(alignment: .top) {
                        VStack {
                            if camera.photo != nil,
                            let photo = camera.photo.image
                            {
                                AvatarView(UIimage: photo, size: 136)
                            } else {
                                UrlImageView(urlString: data.avatar, size: 136)
                            }
                        }
                        Spacer()
                        VStack(spacing: 0) {
                            
                            AppButton(type: .roundedWhiteWithBlackBorder, shadowsRadius: 0, textPading: 0, title: "Take Photo", enableHstack: false, LRpaddings: 16) { cameraPresented.toggle() }
                            
                            AppButton(type: .roundedWhiteWithBlackBorder, shadowsRadius: 0, textPading: 0, title: "Upload", enableHstack: true, LRpaddings: 16) {
                                
                                if let jpgData = camera.photo.compressedData {
                                    loader = true
                                    UserManager.shared.uploadMyAvatar(with: jpgData) { (resp) in
                                        loader = false
                                        switch resp {
                                        case .failure(let err):
                                            isError = true
                                            errorString = err.getDescription()
                                            
                                        case .success(let r):
            //                                print(r)
                                            DispatchQueue.main.async {
                                                UserManager.shared.myProfile { (res) in
                                                    setUpData()
                                                }
                                                
                                            }
                                        }
                                    }
                                } else {
                                    // todo ?
                                }
                            }.padding(.top, 8)
                            
                            Button(action: {
                                loader = true
                                UserManager.shared.removeMyAvatar { (resp) in
                                    loader = false
                                    switch resp {
                                    case .failure(let err):
                                        isError = true
                                        errorString = err.getDescription()
                                    case .success(let r):
                                        print("AVATAR: Removed")
                                        
                                        DispatchQueue.main.async {
                                            data.avatar = nil
                                            camera.photo = nil
                                            UserManager.shared.myProfile { (res) in }
                                        }
                                        
                                    }
                                }
                                
                                
                                
                            }, label: {
                                AppText(text: "Remove", weight: .semiBold, size: 16, colorName: "Red")
                                    .padding(11)
                                //.padding([.leading], 19)
                            }).padding(.top, 8)
                            
                            
                        }.frame(width: 120)
                        Spacer()
                    }
                    
                    
                    // MARK: - First & Last Block
                    VStack(alignment: .leading, spacing: 16) {
                        AppText(text: "Name".uppercased(), weight: .semiBold, size: 12, colorName: "Grey 4")
                            .padding(.top, 40)
                        
                        
                        appInputField(text: $firstName, placeholder: "First name").frame(height: 70)
                        appInputField(text: $lastName, placeholder: "Last name").frame(height: 70)
                        
                        // MARK: - Contact Block
                        AppText(text: "Contact".uppercased(), weight: .semiBold, size: 12, colorName: "Grey 4")
                            .padding(.top, 16)
                        appInputField(text: $email, placeholder: "Email", type: UIKeyboardType.emailAddress).frame(height: 70)
                        appInputField(text: $phone, placeholder: "Phone number", type: UIKeyboardType.phonePad).frame(height: 70)
                    }
                    
                    
                    // MARK: - Address Block
                    VStack(alignment: .leading, spacing: 16) {
                        AppText(text: "Address".uppercased(), weight: .semiBold, size: 12, colorName: "Grey 4")
                            .padding(.top, 32)
                         
                        appInputField(text: $address, placeholder: "Address").frame(height: 70)
                    }
                    
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Button(action: {
                            /// send to API
                            loader = true
                            
                            UserManager.shared.updateMyProfile(fist: firstName, last: lastName, email: email, phone: phone, address: address) { (result) in
                                loader = false
                                switch result {
                                case .failure(let err):
                                    isError = true
                                    errorString = err.getDescription()
                                    
                                case .success(let r):
    //                                print(r)
                                    DispatchQueue.main.async {
                                        setUpData()
                                    }
                                }
                            }
                            
                            
                        }, label: {
                            HStack {
                                Spacer()
                                AppText(text: "I’ll Bring This", weight: .semiBold, size: 18, color: .white)
                                Spacer()
                            }
                        })
                        
                        .frame(height: 48)
                        .background(Color("Green"))
                        .clipShape(Capsule())
                        
                        
                        Button(action: { didShowing = false }, label: {
                            HStack {
                                Spacer()
                                AppText(text: "Cancel", weight: .semiBold, size: 18, colorName: "Grey 2")
                                Spacer()
                            }
                        })
                        
                        .frame(height: 48)
                        .background(Color("Grey 5"))
                        .clipShape(Capsule())
                        
                        
                    }.padding(.top, 32)
                     
                    
                    Spacer()
                }.padding(24)
            }
            
            // loader
            LoaderView(show: loader)
        }
        
       
        
        
        .alert(isPresented: $isError) { () -> Alert in
            Alert(title: Text(""), message: Text(errorString), dismissButton: .default(Text("Ok")) {
                    self.isError = false
                    self.errorString = ""
            }  )
        }
        
        .onAppear {
            
            DispatchQueue.main.async {
                setUpData()
            }
        }
    }
    
    
    func setUpData() {
        DispatchQueue.main.async {
            data = myProfileResponse(DatabaseController.shared.MyProfile() ?? ProfileDB())
             
            let fullNameArr = data.name.components(separatedBy: " ")
            
            self.firstName = fullNameArr.count > 0 ?  fullNameArr[0] : ""
            self.lastName = fullNameArr.count > 1 ?  fullNameArr[1] : ""
            self.email = data.email
            self.phone = data.phone ?? ""
            self.address = data.address ?? ""
        } 
    }
}

struct profileEditView_Previews: PreviewProvider {
    static var previews: some View {
        profileEditView(data: myProfileResponse(ProfileDB()), didShowing: .constant(false))
    }
}







