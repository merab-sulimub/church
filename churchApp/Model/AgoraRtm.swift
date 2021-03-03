//Created for churchApp  (19.10.2020 )

import Foundation
import AgoraRtmKit

enum LoginStatus {
    case online, offline
}

enum OneToOneMessageType {
    case normal, offline
}

enum CellType {
    case left, right
}

class AgoraRtm: NSObject {
    static let kit = AgoraRtmKit(appId: KeyCenter.AppId, delegate: nil)
    static var current: String?
    static var status: LoginStatus = .offline
    static var oneToOneMessageType: OneToOneMessageType = .normal
    static var offlineMessages = [String: [AgoraRtmMessage]]()
    
    static func updateKit(delegate: AgoraRtmDelegate) {
        guard let kit = kit else {
            return
        }
        kit.agoraRtmDelegate = delegate
    }
    
    static func add(offlineMessage: AgoraRtmMessage, from user: String) {
        guard offlineMessage.isOfflineMessage else {
            return
        }
        var messageList: [AgoraRtmMessage]
        if let list = offlineMessages[user] {
            messageList = list
        } else {
            messageList = [AgoraRtmMessage]()
        }
        messageList.append(offlineMessage)
        offlineMessages[user] = messageList
    }
    
    static func getOfflineMessages(from user: String) -> [AgoraRtmMessage]? {
        return offlineMessages[user]
    }
    
    static func removeOfflineMessages(from user: String) {
        offlineMessages.removeValue(forKey: user)
    }
}

