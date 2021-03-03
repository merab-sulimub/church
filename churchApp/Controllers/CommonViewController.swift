//Created for churchApp  (29.09.2020 )

import UIKit
import GoogleMaps

import AgoraRtmKit

class CommonViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    } 
}




extension UIViewController {
    
    func showLoader() {
        DispatchQueue.main.async {
            SwiftLoader.show(animated: true)
        }
    }
    
    func hideLoader() {
        DispatchQueue.main.async {
            SwiftLoader.hide()
        }
    }
    
    
    func showError(message: String, _ title: String = "Error") {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    
    func showError(
        message: String,
        title: String = "",
        //yesAction: UIAlertAction,
        cancelAction: UIAlertAction? = nil,
        
        okClosure: @escaping (UIAlertAction) -> Void
    ) {
    
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: okClosure)
            
            
            alert.addAction(okAction)
            if let cancelAct = cancelAction {
                alert.addAction(cancelAct)
                //UIAlertAction(title: "Cancel", style: .cancel, handler: nil
            }
     

            self.present(alert, animated: true, completion: nil)
        }
    }
     
    
    /// set custom style for maps
    func setMapsStyle(mapView: GMSMapView) {
        if let styleURL = Bundle.main.url(forResource: "GoogleMapsStyle", withExtension: "json") {
            
            do {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
           
            } catch {
                print("❌ One or more of the map styles failed to load. \(error)")
            }
        } else {
            NSLog("Unable to find GoogleMapsStyle.json")
        }
    }
    
}
