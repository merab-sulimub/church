//Created for churchApp  (27.10.2020 )

import SwiftUI

struct AvatarView: View {
    //@ObservedObject var imageLoader:ImageLoader
      
    var dImage =  UIImage()  // = UIImage()

    //@State var localImage: String?
    //@State var patch: String? = nil
    //@State var downloadedImage: UIImage? = nil
    
    var size: CGFloat = 80
     
    init(
            image: String = "avatar",
            UIimage: UIImage? = nil,
            size: CGFloat = 80
    ) {
         
        if let img = UIimage {
            dImage = img
        } else {
            dImage = UIImage(named: image)!
        }
        //imageLoader = ImageLoader(urlString:url)
        //localImage = image
        self.size = size
        
        
        //        if url.isEmpty {
        //            imageLoader = ImageLoader(urlString: "")
        //
        //        } else {
        //
        //        }
    }
    
    
    var body: some View {
        Image(uiImage: dImage)
            .resizable().aspectRatio(contentMode: .fill)
            .frame(width: size, height: size)
            .clipped()
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.gray.opacity(0.2), lineWidth: 2))
             
    }
    
//    func downloadImage(_ patch: String?) {
//        guard let p = patch else {
//            print("❌ PATCH is missing")
//            return
//        }
//        
//        DownloadManager.shared.downloadImage(p)
//    }
}

struct AvatarView_Previews: PreviewProvider {
    static var previews: some View {
        //AvatarView(image: "welcome-preview-img", size: 80)
        
        UrlImageView(urlString: nil, size: 300)
    }
}
 

struct UrlImageView: View {
    @ObservedObject var urlImageModel: UrlImageModel
    
    var FrameSize: CGFloat 
    
    init(urlString: String?, size: CGFloat = 80) {
        urlImageModel = UrlImageModel(urlString: urlString)
        self.FrameSize = size
    }
    
    var body: some View {
        Image(uiImage: urlImageModel.image ?? UrlImageView.defaultImage!)
            .resizable().aspectRatio(contentMode: .fill)
            .frame(width: FrameSize, height: FrameSize)
            .clipped()
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.gray.opacity(0.2), lineWidth: 2))
        
        
    }
    
    static let largeConfig = UIImage.SymbolConfiguration(pointSize: 140, weight: .bold, scale: .large) 
    static var defaultImage = UIImage(systemName: "person.crop.circle.fill", withConfiguration: largeConfig)?.maskWithColor(color: UIColor.lightGray)
}

class UrlImageModel: ObservableObject {
    @Published var image: UIImage?
    var urlString: String?
    
    init(urlString: String?) {
        self.urlString = urlString
        loadImage()
    }
    
    func loadImage() {
        loadImageFromUrl()
    }
    
    func loadImageFromUrl() {
        guard let urlString = urlString else { return }
        
        // remove "/" - first char from patch (alredy included in host patch)
        //let imgPatch = String(urlString.dropFirst())
        guard let url = URL(string: WebservicesConfig().host+urlString) else { return }
        
         
        let task = URLSession.shared.dataTask(with: url, completionHandler: getImageFromResponse(data:response:error:))
        task.resume()
    }
    
    
    func getImageFromResponse(data: Data?, response: URLResponse?, error: Error?) {
        guard error == nil else {
            print("Error: \(error!)")
            return
        }
        guard let data = data else {
            print("No data found")
            return
        }
        
        DispatchQueue.main.async {
            guard let loadedImage = UIImage(data: data) else {
                return
            }
            self.image = loadedImage
        }
    }
}



