//Created for churchApp  (11.11.2020 )

import SwiftUI


enum PodcastButtonType: String {
    case youtube = "youtube-icon"
    case podcast = "podcast-icon"
    case spotify = "spotify-icon"
}

struct PodcastButton: View {
    
    let type: PodcastButtonType
    
    let action: () -> Void
    
    var body: some View {
        Button(action: action, label: { Image(type.rawValue) })
            .frame(width: 32, height: 32, alignment: .center)
        .overlay(Circle().stroke(Color("borderColor 1"), lineWidth: 2))
         
    }
    
}
