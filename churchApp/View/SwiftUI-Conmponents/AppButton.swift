//Created for churchApp  (27.10.2020 )

import SwiftUI


enum AppButtons {
    case wachLive,
         findDinnerParty,
         newMessage,
         roundedWhite,
         roundedWhiteWithBorder,
         roundedWhiteWithBlackBorder,
         uploadVideo
}
 
struct AppButton: View {
    var type: AppButtons? = nil
    var shadowsRadius: CGFloat = 10
    var lineLimit = 1
    var textPading: CGFloat = 24
    var title: String? = nil
    var enableHstack: Bool? = nil
    
    var LRpaddings: CGFloat?
//    var title: String = "Find a Dinner Party"
//
    //var height: CGFloat = 64.0
//
//
//    var backgroundColor = Color("Grey 1")
//
//    var textColor: Color = .white
//    var fontSize: CGFloat = 18.0
//    var dFont: UIFont = commonAppearance.InterSemiBold
//
//    var HStackEnabled: Bool = true
//
//    var icon: String = ""
    
    
    let action: () -> Void
     
    var body: some View {
        Button(action: action, label: {
             
                HStack {
                    if enableHstack != nil ? enableHstack! : config().HStackEnabled { Spacer() }
                    
                    Text(title != nil ? title! : config().title)
                        .padding([.leading, .trailing], textPading)
                        .font(Font(config().dFont.withSize(config().fontSize)))
                        .lineLimit(lineLimit)
                        .foregroundColor(config().textColor)
                        .frame(height: config().height)
                    
                    if enableHstack != nil ? enableHstack! : config().HStackEnabled { Spacer() }
                    
                    if !config().icon.isEmpty {
                        Image(config().icon)
                            //.resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding([.trailing], 24)
                            .padding(.leading, -24)
                    }
                    
                }
                .background(config().backgroundColor)
                .cornerRadius(config().height/2)
  
        })
        
        .padding([.leading, .trailing], LRpaddings != nil ? LRpaddings! : config().LRpaddings)
        .overlay(Capsule().stroke(
                    config().overlayBorderColor,
                    lineWidth: (self.type == .roundedWhiteWithBorder || self.type == .roundedWhiteWithBlackBorder) ? 2 : 0)
        )
        .shadow(radius: shadowsRadius)
    }
    
    
    func config() -> (
        title: String,
        height: CGFloat,
        LRpaddings: CGFloat,
        backgroundColor: Color,
        textColor: Color,
        fontSize: CGFloat,
        dFont: UIFont,
        HStackEnabled: Bool,
        icon: String,
        overlayBorderColor: Color
    ) {
        
        
        var title: String = "Find a Dinner Party"
        
        var height: CGFloat = 64.0
        var LRpaddings: CGFloat = 24.0
        
        var backgroundColor = Color("Grey 1")
        
        var textColor: Color = .white
        var fontSize: CGFloat = 18.0
        let dFont: UIFont = commonAppearance.InterSemiBold
        
        var HStackEnabled: Bool = true
        
        var icon: String = ""
        
        var overlayBorderColor = Color("borderColor 1")
         
         
        switch type {
        case .findDinnerParty: break
        case .wachLive:
            title = "Watch Church Live"
            height = 40
            LRpaddings = 0
            fontSize = 16.0
            HStackEnabled = false
            icon = "camera-icon"
        
        case .newMessage:
            title = "New Message"
            fontSize = 16.0
            height = 40.0
            LRpaddings = 0
            
        case .roundedWhite:
            title = "Welcome Video"
            fontSize = 16.0
            height = 40.0
            LRpaddings = 0
            backgroundColor = .white
            textColor = Color("Grey 1")
            
        case .uploadVideo:
            title = "Upload Video"
            height = 48
            LRpaddings = 0
            fontSize = 16.0
             
        case .roundedWhiteWithBorder:
            title = "$roundedWhiteWithBorder"
            height = 40
            LRpaddings = 0
            fontSize = 16.0
            backgroundColor = .white
            textColor = Color("Grey 1")
        
        case .roundedWhiteWithBlackBorder:
            title = "$roundedWhiteWithBorder"
            height = 40
            LRpaddings = 0
            fontSize = 16.0
            backgroundColor = .white
            textColor = Color("Grey 1")
            overlayBorderColor = Color("Grey 1")
            
            
        case .none: break
       
        }
        
        
        
        return ( title, height, LRpaddings, backgroundColor, textColor, fontSize, dFont, HStackEnabled, icon, overlayBorderColor)
    }
}









struct AppButton_Previews: PreviewProvider {
    static var previews: some View {
        AppButton(type: .uploadVideo) {}
    }
}
