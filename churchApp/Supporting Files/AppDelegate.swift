//Created for churchApp  (22.09.2020 )

import UIKit

/// App Center
//import AppCenter
//import AppCenterAnalytics
//import AppCenterCrashes

/// Google Maps
import GoogleMaps


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
 
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // MS App Center (test)
//        MSAppCenter.start("9e0b980f-d89d-44d6-9d35-43f2bf36cc76", withServices:[
//          MSAnalytics.self,
//          MSCrashes.self
//        ])
        
        // MS App Center (Client test), disabled for testFlight
//        MSAppCenter.start("08bcbaf8-ea29-4f75-8d23-0dfbbc280a99", withServices:[
//          MSAnalytics.self,
//          MSCrashes.self
//        ])
        
        // Init Google Maps Services
        GMSServices.provideAPIKey("AIzaSyCAKnYVy72ROFmcchfXHW6i7RV718gG18s")
         
        // Setup Navigation Bar Appearace
        setupNavigationBarAppearace()
        
        // setup AVAudioSession
        AppConfigurator.setupAVAudioSession()
        
        // init Realm
        AppConfigurator.realmSetup()
        
        
        ///todo
        NotificationCenter.default.addObserver(self, selector: #selector(recived), name: .signOut, object: nil)
        

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}


extension AppDelegate {
    
    @objc func recived() {
        print("Notificition recived: SignOut")
        AuthManager.shared.signOut { [weak self] (res) in
            switch res {
            case .failure(let _):
                self?.signOut()
                //self?.showError(message: err.getDescription())
            case .success(let r):
                if r.errors.count == 0 {
                    self?.signOut()
                } else {
                    //self?.showError(message: "ERRORS: ARE NOT nil !")
                }
            }
        }
    }
    
    @objc private func signOut() {
        
        DispatchQueue.main.async {
            let story = UIStoryboard(name: "Main", bundle:nil)
                let vc = story.instantiateViewController(withIdentifier: "firstNavigationController") as! UINavigationController
                UIApplication.shared.windows.first?.rootViewController = vc
                UIApplication.shared.windows.first?.makeKeyAndVisible()
        }
    }
}
