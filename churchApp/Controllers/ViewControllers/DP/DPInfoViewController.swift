//Created for churchApp  (03.10.2020 )

import UIKit
import GoogleMaps

class DPInfoViewController: CommonViewController {

    @IBOutlet weak var dinnerName: UILabel!
    @IBOutlet weak var dinnerStartAt: UILabel!
    
    @IBOutlet weak var mapView: GoogleMapView!
    @IBOutlet weak var askUs: UIView!
    
    
    var dinnerParty: FindPartyResponse!
     
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setMapsStyle(mapView: mapView.mapView)
        setup()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupData()
    }
    
    
    
    
    
    private func setup() {
         
        mapView.mapView.setMinZoom(15, maxZoom: 15)
          
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(askUsTapped))
        
        askUs.addGestureRecognizer(tapGesture)
        
    }
    
    
    
    private func setupData() {
        
        dinnerName.text = dinnerParty.title
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE 'at' h:mma"
  
        dinnerStartAt.text = dateFormatter.string(from: dinnerParty.date)
        
        // Center the camera on DP
        let dp = CLLocationCoordinate2D(latitude: Double(dinnerParty.latitude), longitude: Double(dinnerParty.longitude))
        
        mapView.createMarker(dp, type: .DPInfoMarker)
        
         
        let dpCam = GMSCameraUpdate.setTarget(dp)
        mapView.mapView.moveCamera(dpCam)
    }
    
    
    
    
    @objc func askUsTapped() {
        if  let stb = storyboard,
            let nv = navigationController,
            let vc = stb.instantiateViewController(withIdentifier: "AskUsViewController") as? AskUsViewController {
            
            vc.dinnerID = dinnerParty.id
            
            //self.present(vc, animated: true, completion: nil)
            nv.pushViewController(vc, animated: true)
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? JoinDPViewController {
            vc.selectedDP = self.dinnerParty
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         Get the new view controller using segue.destination.
         Pass the selected object to the new view controller.
    }
    */

}
