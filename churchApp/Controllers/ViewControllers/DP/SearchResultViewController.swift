//Created for churchApp  (01.10.2020 )

import UIKit
import GoogleMaps


class SearchResultViewController: CommonViewController {

    @IBOutlet weak var mapView: GoogleMapView!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var result: [FindPartyResponse] = []
    var searchByZip: String?
    
     
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setMapsStyle(mapView: mapView.mapView) 
        //mapView.mapView.setMinZoom(12, maxZoom: 16)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateResultList()
    }
    
    
    private func updateResultList() {
        
        if let zip = searchByZip {
            resultLabel.text = "Dinner Parties near \(zip)"
        } else {
            resultLabel.text = "All Dinner Parties" 
        }
         
        
        if
        let minLat = result.min(by: { $0.latitude < $1.latitude })?.latitude,
        let minLong = result.min(by: { $0.longitude < $1.longitude })?.longitude,
        
        let maxLat = result.max(by: { $0.latitude < $1.latitude })?.latitude,
        let maxLong = result.max(by: { $0.longitude < $1.longitude })?.longitude {
              
            mapView.setCameraCenter(
                by: CLLocationCoordinate2D(latitude: Double(minLat), longitude: Double(minLong)),
                pMax: CLLocationCoordinate2D(latitude: Double(maxLat),longitude: Double(maxLong)))
            
        }
        
        for dp in result {
            let dpPos = CLLocationCoordinate2D(latitude: Double(dp.latitude), longitude: Double(dp.longitude))
            
            mapView.createMarker(dpPos, type: .DPInfoMarker)
        }
       
        
        
        
        
        tableView.reloadData()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension SearchResultViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DinnerSearchResultCell
        cell.setup(with: result[indexPath.row]) 
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if  let stb = storyboard,
            
            let vc = stb.instantiateViewController(withIdentifier: "DPInfoViewController") as? DPInfoViewController {
            
            vc.dinnerParty = result[indexPath.row]
            
            navigationController?.pushViewController(vc, animated: true)
        } 
    }
}
 
 
