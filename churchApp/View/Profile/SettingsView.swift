//Created for churchApp  (10.11.2020 )

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let type: settingsRows
     
    var body: some View {
        VStack(alignment: .leading, spacing: 0, content: {
             
            VStack {
                switch type {
                case .dinnerParty:
                    SettingsDPView()
                case .Notifications:
                    SettingsNotificationsView()
                case .DataStorage:
                    StorageSettingsView()
                case .permissions:
                    PermissionsSettingsView()
                }
                
                Spacer()
            }
            .padding([.leading, .trailing], 20)
            .padding(.top, 36)
             
             
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action : {
                self.presentationMode.wrappedValue.dismiss()
            }){
                HStack {
                    Image("back-btn-icon").resizable().frame(width: 32, height: 32, alignment: .center)
                    AppText(text: type == .DataStorage ? "Data and Storage" : type.rawValue, weight: .extraBold, size: 28)
                }
            })
        })
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(type: .DataStorage)
    }
}



struct SettingsDPView: View {
    
    var myDP = DatabaseController.shared.MyProfile()?.DinnerParty
    
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            AppText(text: "your Dinner party".uppercased(), weight: .semiBold, size: 12, colorName: "Grey 4")
            
            AppText(text: myDP?.title ?? "No Dinner Party", weight: .regular, size: 16)
            
            ToogleView(title: "Share my contact info", isSelected: false).padding(.top, 20)
            
            AppText(text: "Giving Dinner Party leaders access to your contact information allows them to reach out outside of Church App.", weight: .regular, size: 14, colorName: "Grey 3").padding(.top, 14-8)
            
        }
    }
}


struct SettingsNotificationsView: View {
    
    var myProfile = DatabaseController.shared.MyProfile()
    
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 8) {
              
            ToogleView(title: "Show direct message notifications", isSelected: false).padding(.top, 20)
            
            ToogleView(title: "Show chat thread notifications", isSelected: true).padding(.top, 24)
            ToogleView(title: "Show Dinner Party notifications", isSelected: true).padding(.top, 24)
            ToogleView(title: "Show church notifications", isSelected: false).padding(.top, 24)
             
            
        }
    }
}







struct PermissionsSettingsView: View {
    
    var myProfile = DatabaseController.shared.MyProfile()
    
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 8) { 
            ToogleView(title: "Allow access to camera", isSelected: true).padding(.top, 20)
            ToogleView(title: "Allow access to microphone", isSelected: false).padding(.top, 24)
            ToogleView(title: "Allow push notifications", isSelected: false).padding(.top, 24)
        }
    }
}




struct StorageSettingsView: View {
    
    var myProfile = DatabaseController.shared.MyProfile()
    
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            
            DataStorageRow(title: "Photos", value: "Wi-Fi and Cellular").padding(.top, 20)
            DataStorageRow(title: "Video files", value: "Wi-Fi").padding(.top, 24)
            DataStorageRow(title: "Video chat", value: "Wi-Fi").padding(.top, 24)
             
        }
    }
}




struct ToogleView: View {
    
    var title: String = "(title)"
    
    @State var isSelected: Bool
    
    var body: some View {
        HStack(alignment: .center, spacing: 0, content: {
            AppText(text: title, weight: .regular, size: 16).lineLimit(1)
            Spacer()
            SwitchView(selected: $isSelected)
        })
    }
}
 
struct DataStorageRow: View {
    
    var title: String = "(title)"
    
    var value: String
    
    var body: some View {
        
        
        HStack(alignment: .center, spacing: 0, content: {
            AppText(text: title, weight: .regular, size: 16).lineLimit(1)
            Spacer()
            
            AppText(text: value, weight: .semiBold, size: 16).lineLimit(1)
                .padding(8)
                .background(Color("Grey 5"))
                .cornerRadius(8)
             
        })
    }
}

