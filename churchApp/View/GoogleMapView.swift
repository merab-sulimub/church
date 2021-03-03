//Created for churchApp  (08.10.2020 )

import UIKit
import GoogleMaps

enum googleMarkerType {
    case DPInfoMarker
    case searchMarker
}


class GoogleMapView: UIView { //@IBDesignable
    
    
    private struct Constants {
        static let marginsForCentering: CGFloat = 60.0
        
        static let CenteringEdgeInsets = UIEdgeInsets(top: marginsForCentering, left: marginsForCentering, bottom: marginsForCentering, right: marginsForCentering)
    }
    
    var mapView = GMSMapView()
    
    /*
     
     Create fake non-designable view of GMSMapView to prevent error:
     
     dlopen(GoogleMaps.framework, 1): no suitable image found.  Did find:     GoogleMaps.framework: mach-o, but wrong filetype
     
     
     */
    
    
    func setCameraCenter(by pMin: CLLocationCoordinate2D, pMax: CLLocationCoordinate2D) {
        let bounds = GMSCoordinateBounds(coordinate: pMin, coordinate: pMax)
        let camera = mapView.camera(for: bounds, insets: Constants.CenteringEdgeInsets)!
        mapView.camera = camera
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)

        mapView = GMSMapView(frame: bounds) 
        addSubview(mapView)

        /// disable User Interaction as Default
        isUserInteractionEnabled = false
        
//        let camera = GMSCameraPosition.camera(
//          withLatitude: 0.0,
//          longitude: 0.0,
//          zoom: 16
//        )
//        mapView = GMSMapView.map(withFrame: bounds, camera: camera)

    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        mapView.frame = bounds
    }
    
    
    func createMarker(_ position: CLLocationCoordinate2D, type: googleMarkerType) {
         
        let dpMarker = GMSMarker(position: position)
        
        switch type {
        case .DPInfoMarker:
            dpMarker.icon = mapsAppearance.DPInfoMarkerImage
            dpMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5) /// maker marker on center
        case .searchMarker:
            dpMarker.icon = mapsAppearance.markerImage
        }
        
        
        dpMarker.map =  mapView//self
         
    }
}
