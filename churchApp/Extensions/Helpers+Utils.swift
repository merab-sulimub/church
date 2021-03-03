//Created for churchApp  (05.10.2020 )

import UIKit



class Utils {
     
    /// will display installed fonts
    func displayFonts() {
        for family: String in UIFont.familyNames
        {
             print("\(family)")
            for names: String in UIFont.fontNames(forFamilyName: family)
             {
                 print("== \(names)")
             }
        }
    }
}





func setupNavigationBarAppearace() {
    let appearance = UINavigationBar.appearance()

    let defaultColor = UIColor(named: "Grey 1")!
    let font = UIFont(name: "Inter-SemiBold", size: 18)!
    
    
    appearance.tintColor = defaultColor
    
    appearance.barTintColor = .red
    appearance.isTranslucent = true
    
    appearance.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
    appearance.shadowImage = UIImage()
    
    let navBtnsApp = UIBarButtonItem.appearance()
    
    let offset = UIOffset(horizontal: 8, vertical: 0)
    
    
    navBtnsApp.setTitleTextAttributes([.font : font], for: .normal)
    navBtnsApp.tintColor = defaultColor
     
    navBtnsApp.setBackButtonTitlePositionAdjustment(offset, for: .default)
    
    
    
    
        
//        UINavigationBar.appearance().clipsToBounds = false
        //UINavigationBar.appearance().backgroundColor = UIColor.redColor()
//        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName : (UIFont(name: "FONT NAME", size: 18))!, NSForegroundColorAttributeName: UIColor.whiteColor()] }
}


func setupBackButton(_ navC: UINavigationController?) {
     
    
    
    guard let backImage = UIImage(named: "back-btn-icon") else {
        print("‼️ NavBar: Back Button is missing.")
        return
    }
    
    guard let nv = navC else {
        print("‼️ NavBar: is nil")
        return
    } 
    nv.navigationBar.backIndicatorImage = backImage
    nv.navigationBar.backIndicatorTransitionMaskImage = backImage
    //navigationItem.backBarButtonItem?.image = backImage
      
}
