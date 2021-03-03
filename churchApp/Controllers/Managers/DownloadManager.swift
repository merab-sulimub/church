//Created for churchApp  (13.11.2020 )
 
import SwiftUI
import Combine
import Foundation

enum downloadTypes {
    case avatar
}



class DownloadManager {
    public static let shared = DownloadManager()
    private init() {}
    
    private let webService = WebServiceAPI.shared
    private let userManager = UserManager.shared
 
    
    
    
    
    
    func downloadImage(_ patch: String, type: downloadTypes = .avatar) {
        
        
        
        // remove "/" - first char from patch (alredy included in host patch)
        let imgPatch = String(patch.dropFirst())
        
        
        guard let fileURL = URL(string: WebservicesConfig().host+imgPatch) else {
            return
        }
         
        
        print("FILE URL",fileURL)
        
        
    }
    
    
    func downloadAvatar(_ patch: String) {
    
    }
    
    
}
    



class ImageLoader: ObservableObject {
    var didChange = PassthroughSubject<Data, Never>()
    var data = Data() {
        didSet {
            didChange.send(data)
        }
    }

    init(urlString:String) {
        
        // remove "/" - first char from patch (alredy included in host patch)
        let imgPatch = String(urlString.dropFirst())
        guard let url = URL(string: WebservicesConfig().host+imgPatch) else { return }
        
        
        //guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.data = data
            }
        }
        task.resume()
    }
}
