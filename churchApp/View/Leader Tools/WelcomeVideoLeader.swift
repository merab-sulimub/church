//Created for churchApp  (27.10.2020 )

import SwiftUI

struct WelcomeVideoLeader: View {
    
    @Binding var isPresented: Bool
    
    @State var isVideoPresent = false
     
    var body: some View {
         
        VStack(alignment: .leading) {
            HStack{Spacer()}
            
            AppText(text: "Welcome Video", weight: .semiBold, size: 24, colorName: "Grey 1")
            AppText(text: "Create a welcome video greeting those taking interest in your Dinner Party.", weight: .regular, size: 14, colorName: "Grey 3").lineSpacing(2)
             
            ZStack(alignment: .bottomTrailing) {
                 
                //Rectangle()
                
                
                Image(isVideoPresent ? "welcome-preview-img" : "uploadVideoPlaceHolder")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
                
                if isVideoPresent {
                     
                        
                    Button(action: {}, label: {
                        AppText(text: "PLAY", weight: .semiBold, size: 12)
                            .padding([.leading, .trailing], 16)
                            .padding([.top, .bottom], 8)
                            .background(Color.white)
                            .clipShape(Capsule())
                    }).padding([.bottom, .trailing], 32)
                }
                
                
            }.padding(32)
            
            
            if isVideoPresent {
                VStack(alignment: .leading) {
                    AppText(text: "last updated".uppercased(), weight: .semiBold, size: 12, colorName: "Grey 3")
                    AppText(text: "Matthew Harris, April 15, 2020", weight: .regular, size: 14, colorName: "Grey 1")
                }
            }
            
            Spacer()
             
            
            AppButton(type: .uploadVideo) {}.padding([.leading, .trailing], 32)
            
                 
            HStack(alignment: .center) {
                
                Spacer()
                Button(action: {
                    isPresented = false
                }, label: {
                    AppText(text: "Cancel", weight: .semiBold, size: 16, colorName: "Grey 3")
                })
                Spacer()
            }.padding(16)
             
        }
        .padding(.top, 40)
        .padding([.leading, .trailing], 24)
        
        
    }
}

//struct WelcomeVideoLeader_Previews: PreviewProvider {
//    @Binding var isPresented: Bool
//    
//    static var previews: some View {
//        WelcomeVideoLeader()
//    }
//}
