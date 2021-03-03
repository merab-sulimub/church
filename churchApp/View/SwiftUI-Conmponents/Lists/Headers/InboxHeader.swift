//Created for churchApp  (29.10.2020 )

import SwiftUI

struct InboxListHeader: View {
    let text: String
    
    var body: some View {
        HStack {
            AppText(text: text, weight: .semiBold, size: 12, colorName: "Grey 4")
                .padding([.leading, .trailing], 0)
                .padding([.top, .bottom], 10)

                    Spacer()
        }//.background(Color.white)
        .listRowInsets(EdgeInsets( top: 0, leading: 24, bottom: 2, trailing: 24))
                        
    }
}
 
public struct ListSeparatorStyleModifier: ViewModifier {
    public func body(content: Content) -> some View {
        content.onAppear {
            UITableView.appearance().separatorStyle = .none
            UITableView.appearance().separatorColor = .white
            UITableView.appearance().separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            UITableViewHeaderFooterView.appearance().tintColor = .clear
            UITableView.appearance().backgroundColor = .clear // tableview background
            UITableViewCell.appearance().backgroundColor = .clear

        }
    }
}



extension View {
   public func listSeparatorStyle() -> some View {
       modifier(ListSeparatorStyleModifier())
   }
}
