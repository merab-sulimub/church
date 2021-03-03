//Created for churchApp  (07.10.2020 )

import UIKit

//let storyBoard = UIStoryboard(name: "Main", bundle: nil)

let tabBarAppearance = AppAppearance.TabBarAppearance()
let commonAppearance = AppAppearance.CommonAppearance()

let mapsAppearance = AppAppearance.MapsAppearance()
 
struct AppAppearance {
    
    struct CommonAppearance {
        /// Inter-SemiBold.ttf
        let InterSemiBold = UIFont(name: "Inter-SemiBold", size: 18.0)!
        /// Inter-Regular.ttf
        let InterRegular = UIFont(name: "Inter-Regular", size: 18.0)!
        /// Inter-Bold.ttf
        let InterBold = UIFont(name: "Inter-Bold", size: 18.0)!
        /// Inter-ExtraBold.ttf
        let InterExtraBold = UIFont(name: "Inter-ExtraBold", size: 18.0)!
        
        
    }
    
    struct MapsAppearance {
        let markerImage = UIImage(named: "mapMarker-icon")!
        let DPInfoMarkerImage = UIImage(named: "DPInfoMapMarker")!
        
        
        
    }
    
    struct TabBarAppearance {
        let shadowColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 0.3)
        let sliderColor = UIColor(red: 1.0, green: 0.48, blue: 0.0, alpha: 1.0)
        let sliderRadius: CGFloat = 2.0
        
    }
}
