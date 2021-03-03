//Created for churchApp  (15.11.2020 )

import SwiftUI




struct LoaderView: View {
    
    var show: Bool
    
    var body: some View {
        
        if show {
            Group {
                VStack {
                    Spacer()
                    iActivityIndicator(style: .rotatingShapes(count: 3, size: 30))
                    Spacer()
                }
                .background(Color.gray.opacity(0.4))
                .edgesIgnoringSafeArea(.all)
            }
        } else {
            Group {}
        }
        
        
    }
}

struct LoaderView_Previews: PreviewProvider {
    static var previews: some View {
        LoaderView(show: true)
    }
}
