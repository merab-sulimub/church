//Created for churchApp  (13.11.2020 )

import SwiftUI

struct ContactUsView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var questionText = ""
    @State private var textStyle = UIFont.TextStyle.body
    
    @State var loader: Bool = false
    @State var isError = false
    @State var errorString = ""
    
    @State private var isSuccess = false
    
    var body: some View {
        
        ZStack {
            // loader
            LoaderView(show: loader)
             
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                AppText(text: "Drop us a line if you have any questions or need help with your account.", weight: .regular, size: 16, colorName: "Grey 3")
                
                //                MultilineTextField("Enter your message", text: $questionText) {
                //
                //                }
                //                .frame(height: 100, alignment: .center)
                //                .border(Color("Grey 5"), width: 2)
                //                .cornerRadius(16)
                
                
                TextView(text: $questionText, textStyle: $textStyle).frame(height: 240, alignment: .leading).padding()
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color("Grey 5"), lineWidth: 2))
                    .padding(.top, 24)
                
                
                AppButton(type: .uploadVideo, shadowsRadius: 0,  title: "Submit") {
                    
                    loader = true
                    UserManager.shared.contactUS(text: questionText) { (resp) in
                        loader = false
                        
                        switch resp {
                        case .failure(let err):
                            isError = true
                            errorString = err.getDescription()
                        case .success(let d):
                            isSuccess = true
                            isError = true // to show alert msg
                            errorString = d.response
                        }
                    }
                     
                }.padding(.top, 24)
                Spacer()
                
                
            }.padding([.leading, .trailing], 24)
             
            
            }.alert(isPresented: $isError) { () -> Alert in
            Alert(title: Text(""), message: Text(errorString), dismissButton: .default(Text("Ok")) {
                    self.isError = false
                    self.errorString = ""
                
                
                if isSuccess {
                    presentationMode.wrappedValue.dismiss()
                }
            }  )
        }
         
        /// navbar
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action : {
            self.presentationMode.wrappedValue.dismiss()
        }){
            HStack {
                Image("back-btn-icon").resizable().frame(width: 32, height: 32, alignment: .center)
                AppText(text: "Contact Us", weight: .extraBold, size: 28)
            }
        })}
    }
}

struct ContactUsView_Previews: PreviewProvider {
    static var previews: some View {
        ContactUsView()
    }
}
