//Created for churchApp  (19.10.2020 )

import UIKit
import AgoraRtcKit
import AgoraRtmKit


protocol SettingsVCDataSource: NSObjectProtocol {
    func settingsVCNeedSettings() -> Settings
}

//protocol SettingsVCDelegate: NSObjectProtocol {
//    func settingsVC(_ vc: ProfileViewController, didSelect dimension: CGSize)
//    func settingsVC(_ vc: ProfileViewController, didSelect frameRate: AgoraVideoFrameRate)
//}


let agoraManager = AgoraManager.shared


class AgoraManager: NSObject {
    public static let shared = AgoraManager()
    private override init() {}
    
    private let webService = WebServiceAPI.shared 
    
    private var settings = Settings()
    
    private lazy var agoraKit: AgoraRtcEngineKit = {
        let engine = AgoraRtcEngineKit.sharedEngine(withAppId: KeyCenter.AppId, delegate: nil)
        engine.setLogFilter(AgoraLogFilter.info.rawValue)
        engine.setLogFile(FileCenter.logFilePath())
        //engine.setDefaultAudioRouteToSpeakerphone(true)v
        //engine.setAudioProfile(.default, scenario: .chatRoomEntertainment)
        engine.adjustPlaybackSignalVolume(10)
        return engine
    }()
     
    
    
    
    func setRoom(_ room: String) {
        self.settings.roomName = room
    }
    
    
    func login(result: @escaping (_ status: Bool, _ msg: String?) -> Void) { //result: @escaping Result<Bool,Error>
         
        
        guard let accoutID = DatabaseController.shared.MyProfile() else {
             
            result(false, "Can't login to RTM, ID is missing")
            return
        }
        
        let account = "\(accoutID.id)"
         
        
        AgoraRtm.updateKit(delegate: self)
        AgoraRtm.current = account
        AgoraRtm.oneToOneMessageType = false ? .offline : .normal

        AgoraRtm.kit?.login(byToken: nil, user: account) { (errorCode) in
            guard errorCode == .ok else {
                result(false, "login error: \(errorCode.rawValue)")
                return
            }
            AgoraRtm.status = .online
            result(true, nil)
        }
    }
}
 
extension AgoraManager: AgoraRtmDelegate {
    // Receive one to one offline messages
    func rtmKit(_ kit: AgoraRtmKit, messageReceived message: AgoraRtmMessage, fromPeer peerId: String) {
        AgoraRtm.add(offlineMessage: message, from: peerId)
    }
}





extension AgoraManager: LiveVCDataSource {
    func liveVCNeedSettings() -> Settings {
        return settings
    }
    
    func liveVCNeedAgoraKit() -> AgoraRtcEngineKit {
        return agoraKit
    }
}

//extension AgoraManager: SettingsVCDelegate {
//     
//    func settingsVC(_ vc: ProfileViewController, didSelect dimension: CGSize) {
//        settings.dimension = dimension
//    }
//    
//    func settingsVC(_ vc: ProfileViewController, didSelect frameRate: AgoraVideoFrameRate) {
//        settings.frameRate = frameRate
//    }
//}

extension AgoraManager: SettingsVCDataSource {
    func settingsVCNeedSettings() -> Settings {
        return settings
    }
}

extension AgoraManager: RoleVCDelegate {
    func roleVC(_ vc: WelcomeLiveViewController, didSelect role: AgoraClientRole) {
        settings.role = role
    }
}
