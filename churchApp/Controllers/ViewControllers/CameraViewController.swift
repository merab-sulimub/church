//Created for churchApp  (30.10.2020 )

import UIKit
import SwiftUI


final class CameraViewController: UIViewController {

    let cameraController = CameraController()
    var previewView: UIView!
    
    var errorHandler: ((Error)->Void)?
    //var cameraPhotoData: ((Data) -> Void)?
    
    
    var type: AppCameraType!
    
    init(type: AppCameraType, errorHandler: @escaping ((Error)->Void)) {
        super.init(nibName: nil, bundle: nil)
        
        self.errorHandler = errorHandler
        
        self.type = type
        
         
        //self.cameraPhotoData = photoHandler
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }
    
    
    private func setup() {
        previewView = UIView(frame: CGRect(x:0, y:0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        previewView.contentMode = UIView.ContentMode.scaleAspectFit
         
        view.addSubview(previewView)
        
         
        cameraController.prepare {(error) in
            if  self.errorHandler != nil,
                let error = error {
                //print(error)
                self.errorHandler!(error)
            }
            
            try? self.cameraController.displayPreview(on: self.previewView)
        }
    }
    
    
    func test() {}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}


extension CameraViewController: CameraControllerProtocol {
    func takePhoto() {
        print("take pto")
        cameraController.handleTakePhoto()
    }
}



struct CameraOverlayController:  UIViewControllerRepresentable{
    public typealias UIViewControllerType = CameraViewController
     
    //@Binding var photoData: Data?
    
    
    var configurator: ((CameraControllerProtocol) -> Void)? // callback
    
    
    var type: AppCameraType
    var closure: (Error) -> Void
    //var photoData: (Data) -> Void
    
    func makeUIViewController(context: Context) -> CameraViewController {
        let CVC = CameraViewController(type: type, errorHandler: closure)
        
        // callback to provide active component to caller
        configurator?(CVC)
        
        return CVC
    }
    
    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {
        print("Update")
         
        if uiViewController.cameraController.photoData != nil {
            print("✅ PHOTO DATA IS NOT A NIL")
        }
    }
}
 


//extension CameraViewController : UIViewControllerRepresentable{
//    public typealias UIViewControllerType = CameraViewController
//
//
//
//    public func makeUIViewController(context: UIViewControllerRepresentableContext<CameraViewController>) -> CameraViewController {
//        return CameraViewController(error: closure)
//    }
//
//    public func updateUIViewController(_ uiViewController: CameraViewController, context: UIViewControllerRepresentableContext<CameraViewController>) {
//    }
//}
