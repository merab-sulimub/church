//Created for churchApp  (10.11.2020 )

import SwiftUI

struct SwitchView: View {
    
    @Binding var selected: Bool
    
    var body: some View {
        ZStack {
            Capsule().foregroundColor(selected ? Color("Violet 1") : Color("Grey 5"))
             
            Circle()
                .padding(0.5)
                .background(Circle().stroke(lineWidth: 1.0).foregroundColor(Color("borderColor 3") ))
                .foregroundColor(Color.white)
                .mask(
                ZStack {
                  Circle().fill(Color.white)
                     
                    Image(systemName: selected ? "checkmark" : "xmark")
                        .resizable()
                        .frame(width: 10, height: 10, alignment: .center)
                        .font(.system(size: 18))
                        .foregroundColor(Color.black)
                }
                  .compositingGroup()
                  .luminanceToAlpha()
                ).offset(x: selected ? 8 : -8 , y: 0)
        }
        .padding(0.5)
        .frame(width: 48, height: 32, alignment: .center)
        .background(Capsule().stroke(lineWidth: 1.0).foregroundColor(Color("borderColor 3") ))
        .onTapGesture(count: 1, perform: {
            withAnimation { selected.toggle() }
        })
    }
}
