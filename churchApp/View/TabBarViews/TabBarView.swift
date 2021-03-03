//Created for churchApp  (12.11.2020 )

import SwiftUI


struct TabBarView: View {
    
    @State private var selected = 0
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor.white
        UITabBar.appearance().backgroundImage = UIImage()
          
    }
    
    var body: some View {
        
        NavigationView {
            TabView(selection: $selected) {
                
                FeedView().tabItem {
                    Text("")
                   
                        Image(selected == 0 ? "feed-selected-icon" : "feed-unselected-icon")
                     
                     
                }.tag(0)
                
                MyDinnerView().tabItem {
                    Text("")
                    Image(selected == 1 ? "dinnerParty-selected-icon" : "dinnerParty-unselected-icon")
                    
                }.tag(1)
                
                InboxView().tabItem {
                    Text("")
                    Image(selected == 2 ? "inbox-selected-icon" : "inbox-unselected-icon")
                    
                }.tag(2)
            }.shadow(radius: 10 )
        }
        
        
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}


extension UIImage {
class func colorForNavBar(color: UIColor) -> UIImage {
    //let rect = CGRectMake(0.0, 0.0, 1.0, 1.0)

    let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 1.0, height: 4.0))

    UIGraphicsBeginImageContext(rect.size)
    let context = UIGraphicsGetCurrentContext()

    context!.setFillColor(color.cgColor)
    context!.fill(rect)

    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()


     return image!
    }
}
