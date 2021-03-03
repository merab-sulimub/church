//Created for churchApp  (28.10.2020 )

import SwiftUI

struct VerticalInfoView: View {
    
    var title: String
    var value: String
    
    var valueWidth: CGFloat?
    
    var body: some View {
       HStack {
            VStack(alignment:.leading) {
                Text(title.uppercased())
                    .font(Font(commonAppearance.InterSemiBold.withSize(12)))
                    .foregroundColor(Color("Grey 4"))
                 
                if let w = valueWidth {
                    Text(value).frame(width: w, alignment: .leading)
                } else {
                    Text(value)
                }
                
                     
                
                
            }
       }.padding(.top, 24)
    }
}

struct VerticalInfoView_Previews: PreviewProvider {
    static var previews: some View {
        VerticalInfoView(title: "address", value: "316 Church St New York, NY 10013")
    }
}
