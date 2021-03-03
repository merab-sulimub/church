//Created for churchApp  (10.11.2020 )

import SwiftUI

enum settingsRows: String {
    case dinnerParty    = "Dinner Party"
    case Notifications  = "Notifications"
    case DataStorage    = "Data and Storage Usage"
    case permissions    = "Permissions"
}

struct settingsRow: View {
    
    
    let type: settingsRows
    var action: () -> Void
    
    
    var body: some View {
        ZStack() {
            Rectangle().foregroundColor(.white)
            VStack(alignment: .leading, spacing: 0) {
                DividerView(topBottomPaddings: 0)
                
                HStack {
                    AppText(text: type.rawValue, weight: .semiBold, size: 18)
                    Spacer()
                    Image("arrow-big-icon")
                }
                .padding([.top, .bottom], 25)
                .padding([.leading, .trailing], 20)
                 
                
            }
            
            .padding([.leading, .trailing], -24)
        }.onTapGesture(count: 1, perform: {
            self.action()
        })

    }
}

struct SettingsRow_Previews: PreviewProvider {
    static var previews: some View {
        settingsRow(type: .dinnerParty) { }
    }
}
