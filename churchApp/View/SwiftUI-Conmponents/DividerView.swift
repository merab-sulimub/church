//Created for churchApp  (27.10.2020 )

import SwiftUI

struct DividerView: View {
    
    var topBottomPaddings: CGFloat = 32
    
    var body: some View {
        
        Group { 
            Rectangle().fill(Color("borderColor 2") )
                .frame(height: 4)
                .padding([.top, .bottom], topBottomPaddings)
                .edgesIgnoringSafeArea(.horizontal)
        }
    }
}

struct DividerView_Previews: PreviewProvider {
    static var previews: some View {
        DividerView()
    }
}
