//Created for churchApp  (20.10.2020 )

import UIKit
import SwiftUI


import AgoraRtmKit

protocol ShowAlertProtocol: UIViewController {
    func showAlert(_ message: String, handler: ((UIAlertAction) -> Void)?)
    func showAlert(_ message: String)
}

protocol memberCountProtocol {
    func count(_ channel: AgoraRtmChannel, memberCount count: Int32)
}
 
enum ChatType {
    case peer(String), group(String)
    
    var description: String {
        switch self {
        case .peer:  return "peer"
        case .group: return "channel"
        }
    }
}

struct Message {
    var userId: String
    var text: String
    var isInfo: Bool = false
}

class ChatViewController: CommonViewController {
     
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var inputViewBottom: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputContainView: UIView!
     
    @IBOutlet weak var reactionsContainView: UIView!
    
    
    lazy var list = [Message]()
    var type: ChatType = .group("no_identification")
        //.peer("unknow")
    var displayOnlyLeft: Bool?
    
    var rtmChannel: AgoraRtmChannel?
    
    var memberCountDelegate: memberCountProtocol?
    
    override func viewDidLoad() {
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        
        //addKeyboardObserver()
        updateViews()
        ifLoadOfflineMessages()
        AgoraRtm.updateKit(delegate: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        switch type {
        case .peer(let name):     self.title = name
        case .group(let channel): self.title = channel; createChannel(channel)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        leaveChannel()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: Send Message
private extension ChatViewController {
    func send(message: String, type: ChatType) {
        let sent = { [unowned self] (state: Int) in
            guard state == 0 else {
                
                self.showError(message: "send \(type.description) message error: \(state)") { (act) in
                    self.view.endEditing(true)
                }
                return
            }
            
            guard let current = AgoraRtm.current else {
                return
            }
            self.appendMessage(user: current, content: message)
        }
        
        let rtmMessage = AgoraRtmMessage(text: message)
        
        switch type {
        case .peer(let name):
            let option = AgoraRtmSendMessageOptions()
            option.enableOfflineMessaging = (AgoraRtm.oneToOneMessageType == .offline ? true : false)
            
            AgoraRtm.kit?.send(rtmMessage, toPeer: name, sendMessageOptions: option, completion: { (error) in
                sent(error.rawValue)
            })
        case .group(_):
            rtmChannel?.send(rtmMessage) { (error) in
                sent(error.rawValue)
            }
        }
    }
}

// MARK: Chanel
private extension ChatViewController {
    func createChannel(_ channel: String) {
        
        let errorHandle = { [weak self] (action: UIAlertAction) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.navigationController?.popViewController(animated: true)
        }
        
        guard let rtmChannel = AgoraRtm.kit?.createChannel(withId: channel, delegate: self) else {
             
            showError(message: "join channel fail", okClosure: errorHandle)
            return
        }
        
        rtmChannel.join { [weak self] (error) in
            if error != .channelErrorOk, let strongSelf = self {
                strongSelf.showError(message: "join channel error: \(error.rawValue)", okClosure: errorHandle)
            }
             
        }
        
        self.rtmChannel = rtmChannel
        
        
        setAttributes()
    }
    
    
    func setAttributes() {
        
        let usernameAttr = AgoraRtmAttribute()
        
        usernameAttr.key = "username"
        usernameAttr.value = UserManager.shared.profile.name
        
        
        let avatarAttr = AgoraRtmAttribute()
        
        avatarAttr.key = "avatar"
        avatarAttr.value = UserManager.shared.profile.avatar ?? ""
         
        
        
        AgoraRtm.kit?.setLocalUserAttributes([usernameAttr, avatarAttr], completion: { (errCode) in
            
            if errCode == .attributeOperationErrorOk {
                print("RTM: setLocalUserAttributes: ✅")
            }
             
        })
        
    }
    
    
    func leaveChannel() {
        rtmChannel?.leave { (error) in
            print("leave channel error: \(error.rawValue)")
        }
    }
}

// MARK: AgoraRtmDelegate
extension ChatViewController: AgoraRtmDelegate {
    func channel(_ channel: AgoraRtmChannel, memberCount count: Int32) {
        memberCountDelegate?.count(channel, memberCount: count)
    }
    
    func rtmKit(_ kit: AgoraRtmKit, connectionStateChanged state: AgoraRtmConnectionState, reason: AgoraRtmConnectionChangeReason) {
        // todo: 
          
//        showError(message: "connection state changed: \(state)") { [weak self] (_) in
//            if reason == .remoteLogin, let strongSelf = self {
//                strongSelf.navigationController?.popToRootViewController(animated: true)
//            }
//        }
    }
    
    func rtmKit(_ kit: AgoraRtmKit, messageReceived message: AgoraRtmMessage, fromPeer peerId: String) {
        appendMessage(user: peerId, content: message.text)
    }
}

// MARK: AgoraRtmChannelDelegate
extension ChatViewController: AgoraRtmChannelDelegate {
    func channel(_ channel: AgoraRtmChannel, memberJoined member: AgoraRtmMember) {
        DispatchQueue.main.async { [unowned self] in
            
            self.appendMessage(user: "\(member.userId)", content: "joined the chat", isInfo: true)
            //self.send(message: "$name joined the chat", type: type)
            
            //self.showError(message: "\(member.userId) join")
        }
    }
    
    func channel(_ channel: AgoraRtmChannel, memberLeft member: AgoraRtmMember) {
        DispatchQueue.main.async { [unowned self] in
             
            self.appendMessage(user: "\(member.userId)", content: "left the chat", isInfo: true)
            //self.showError(message: "\(member.userId) left")
        }
    }
    
    func channel(_ channel: AgoraRtmChannel, messageReceived message: AgoraRtmMessage, from member: AgoraRtmMember) {
        
        
        if let rawAction = message as? AgoraRtmRawMessage {
            print("raw message received")
            appendReaction()
            
        } else  {
            appendMessage(user: member.userId, content: message.text)
        }
    }
}

private extension ChatViewController {
    func updateViews() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 55
    }
    
    func ifLoadOfflineMessages() {
        switch type {
        case .peer(let name):
            guard let messages = AgoraRtm.getOfflineMessages(from: name) else {
                return
            }
            
            for item in messages {
                appendMessage(user: name, content: item.text)
            }
            
            AgoraRtm.removeOfflineMessages(from: name)
        case .group(let name):
            print("Agora RTM: \(name)")
            //guard let messages = Agor
        }
    }
    
    func pressedReturnToSendText(_ text: String?) -> Bool {
        guard let text = text, text.count > 0 else {
            return false
        }
        send(message: text, type: type)
        return true
    }
    
    func appendMessage(user: String, content: String, isInfo: Bool = false) {
        DispatchQueue.main.async { [unowned self] in
            let msg = Message(userId: user, text: content, isInfo: isInfo)
            self.list.append(msg)
            if self.list.count > 100 { self.list.removeFirst() }
            
            
            
            let end = IndexPath(row: self.list.count - 1, section: 0)
            
            self.tableView.reloadData()
            self.tableView.scrollToRow(at: end, at: .bottom, animated: true)
        }
    }
    
    
    func appendReaction() {
        let reactionImageView = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        reactionImageView.text = "🙌"
        reactionImageView.font = UIFont.systemFont(ofSize: 30)
        
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            reactionImageView.isHidden = true
        })
        
        
        let animation = CAKeyframeAnimation(keyPath: "position")
        
        animation.path = reactionPatch().cgPath
        animation.duration = 2 + drand48() * 3
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
         
        
        reactionImageView.layer.add(animation, forKey: nil)
        
        
        self.reactionsContainView.addSubview(reactionImageView)
        
        CATransaction.commit()
    }
    
    
    func reactionPatch() -> UIBezierPath {
        let patch = UIBezierPath()
        // 340hx120w
        let h = 340
        let w = 120
        
        
        patch.move(to: CGPoint(x: w/2, y: h))
        
        let endPoint = CGPoint(x: w/2, y: -40)
        
        
        let randomYShift = 200 + drand48() * 100
        
        let cp1 = CGPoint(x: 20.0, y: 50.0 - randomYShift)
        let cp2 = CGPoint(x: 100, y: h - 50 + Int(randomYShift))
            //CGPoint(x: 100, y: h - 50 + randomYShift)
        
        patch.addCurve(to: endPoint, controlPoint1: cp1, controlPoint2: cp2)
         
        return patch
    }
    
//    func addKeyboardObserver() {
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(keyboardFrameWillChange(notification:)),
//                                               name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
//    }
    
//    @objc func keyboardFrameWillChange(notification: Notification) {
//
//        let n = KeyboardNotification(notification)
//        let keyboardFrame = n.frameEndForView(view: self.view)
//
//        let viewFrame = self.view.frame
//        let newBottomOffset = (viewFrame.maxY - keyboardFrame.minY) + 20
//
//        self.view.layoutIfNeeded()
//
//        UIView.animate(
//            withDuration: n.animationDuration,
//            delay: 0.0,
//            options: n.animationOptions,
//            animations: { [weak self] in
//
//                guard let strongSelf = self else { return }
//                strongSelf.inputViewBottom.constant = newBottomOffset
//                strongSelf.view.layoutIfNeeded()
//
//        }, completion: nil)
//    }
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let msg = list[indexPath.row]
         
        var type: CellType = msg.userId == AgoraRtm.current ? .right : .left
        
        if displayOnlyLeft != nil {type = .left}
        
        
         
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
        
        
        cell.setDefaultAvatar()
        cell.update(type: type, message: msg)
        
        
        AgoraRtm.kit?.getUserAllAttributes(msg.userId, completion: { (attr, usrID, errCode) in
            print("RTM: Attr \(attr)")
            print("RTM: Str \(usrID)")
            print("RTM: errCode \(errCode)")
            
            /// setup username (First + Last )
            if let usernameAttr = attr?.first(where: {$0.key == "username"}) {
                
                let u1 = Message(userId: usernameAttr.value, text: msg.text)
                cell.update(type: type, message: u1)
            }
            /// setup Avatar
            if let avatarAttr = attr?.first(where: {$0.key == "avatar"}) {
                cell.setupAvatar(with: avatarAttr.value)
            }
        })
         
        return cell
    }
}



extension ChatViewController {
    @IBAction func reactionTapped(_ sender: UIButton) {
        
        
        let msg = AgoraRtmRawMessage(rawData: "server.action.reaction".data(using: .utf8)!, description: "RAW msg: action")
        
        rtmChannel?.send(msg, completion: { (err) in
            //print(err.rawValue)
            self.appendReaction()
        })
    }
}

extension ChatViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if pressedReturnToSendText(textField.text) {
            textField.text = nil
        } else {
            view.endEditing(true)
        } 
        return true
    }
}
