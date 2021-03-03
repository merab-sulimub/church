//Created for churchApp  (18.10.2020 )

import UIKit
import SwiftUI

import AgoraRtcKit
import AgoraRtmKit

import AVKit
import AVFoundation
 
import XCDYouTubeKit

protocol RoleVCDelegate: NSObjectProtocol {
    func roleVC(_ vc: WelcomeLiveViewController, didSelect role: AgoraClientRole)
}

class WelcomeLiveViewController: UIViewController, playerProtocol {
    func play() {
        print("CALL PLAY")
        player?.play()
    }
    
 
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var userCountLabel: UILabel!
    
    @IBOutlet weak var joinWithVideoButton: UIButton!
    
    
    @IBOutlet weak var chatContainer:UIView!
    
    @IBOutlet weak var groupLiveContainer:UIView!
    @IBOutlet weak var groupLiveHeightConstraint: NSLayoutConstraint!
    
    weak var delegate: RoleVCDelegate?
     
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    
    private var allowsToPlay: Bool = false
    static let vimeoURL: URL = URL(string: "https://vimeo.com/237301129")!
    static let youTubeVideoID: String = "dQtijd3LkTE"
    
    
    private lazy var chatV: UIView = {
        let chat = UIView()
        
        return chat
    }()
    
    
    
    var dismissCallback: (() -> Void)?
    
     
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
        setup()
        //setupPlayer(with: WelcomeLiveViewController.vimeoURL)
        setupPlayer(with: WelcomeLiveViewController.youTubeVideoID)
        
        self.player?.addObserver(self, forKeyPath: "rate", options: [], context: nil)
        
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
            if (keyPath == "rate") {
                if ((player?.rate) == 1) {
                    print("Plyaing")

                } else {
                    print("Pause")
                }
            }
        }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         
        chatContainer.isHidden = true
        groupLiveContainer.isHidden = true
        
        allowsToPlay = true
        
        navigationController?.navigationBar.isHidden = true
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        player?.play()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.isHidden = false
        
        //stopPlayer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        //stopPlayer()
    }
    
    
    
    private func appendGroupLiveAndChat(role: AgoraClientRole) {
        
        appendChat("app.watch.church.live.chat")
        delegate?.roleVC(self, didSelect: .broadcaster)
         
        ViewEmbedder.embed(
            withIdentifier: "GroupLiveViewController",
            parent: self,
            container: self.groupLiveContainer,
            removePrevious: false
        
        ) { (vc) in
            print("embed done ✅")
              
            if let liveVC = vc as? GroupLiveViewController  {
                liveVC.playerDelegate = self
                liveVC.dataSource = agoraManager
                
                self.presentGroupLive()
            } else {
                /// something goes wrong
            }
        }
    }
    
    private func appendChat(_ roomName: String) {
        ViewEmbedder.embed(
            withIdentifier: "ChatViewController",
            parent: self,
            container: self.chatContainer) { (vc) in
            print("embed done ✅")
              
            if let chatVC = vc as? ChatViewController  {
                
                chatVC.type = .group(roomName)
                chatVC.displayOnlyLeft = true
                chatVC.memberCountDelegate = self
                self.presentChat()
            } else {
                /// something goes wrong
            }
        }
    }
    
    private func presentChat() {
        self.chatContainer.alpha = 0
        self.chatContainer.isHidden = false
        
        
        UIView.animate(withDuration: 0.5) {
            self.chatContainer.alpha = 1
        }
    }
    
    private func presentGroupLive() {
        groupLiveHeightConstraint.constant = 125+15+16+16
        
        self.groupLiveContainer.alpha = 0
        self.groupLiveContainer.isHidden = false
         
        UIView.animate(withDuration: 0.5) {
            self.groupLiveContainer.alpha = 1
        }
    }
     
    private func setup() {
        /// add blur effect thumbnailI
        let darkBlur = UIBlurEffect(style: .extraLight)
        
        let blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame = thumbnailImage.bounds
        thumbnailImage.addSubview(blurView)
        
        /// setup gradient
        let startColor = UIColor(red: 226/255, green: 47/255, blue: 255/255, alpha: 1)
        let endColor = UIColor(red: 153/255, green: 30/255, blue: 211/255, alpha: 1)
        
        joinWithVideoButton.applyGradient(with: [startColor, endColor], gradient: .horizontal)
        joinWithVideoButton.cornerRadius = joinWithVideoButton.frame.height/2 
    }
    
    func stopPlayer() {
        allowsToPlay = false
        
        if let play = player {
            print("stopped")
            play.pause()
            player = nil
            print("player deallocated")
            
            playerLayer = nil
        } else {
            print("player was already deallocated")
        }
    }
    
    private func setupPlayer(with vimeoURL: URL) {
        
        HCVimeoVideoExtractor.fetchVideoURLFrom(url: vimeoURL) {[weak self] (video, error) in
            
            guard let strongSelf = self else {return}
            
            if let err = error {
                strongSelf.showError(message: err.localizedDescription)
               return
            }
            
            
            guard let vid = video else {
                strongSelf.showError(message: "Invalid video object"); return
                }
            
            print("Vimeo: ✅ Title = \(vid.title), url = \(vid.videoURL), thumbnail = \(vid.thumbnailURL)")
            
            if let videoURL = vid.videoURL[.quality360p] {
                
                DispatchQueue.main.async {
                    strongSelf.addPlayer(AVPlayer(url: videoURL))
                }
            }
        }
    }
    
    private func setupPlayer(with youtubeVideoIdentifier: String) {
                XCDYouTubeClient.default().getVideoWithIdentifier(youtubeVideoIdentifier) { [weak self]
                     (video: XCDYouTubeVideo?, error: Error?) in
                    guard let self = self else {return}
                    
                    if let err = error {
                        print("❌ XCDYouTube Error:", err)
                    }
                    
                    
                    if let streamURLs = video?.streamURLs, let streamURL = (
                        streamURLs[XCDYouTubeVideoQualityHTTPLiveStreaming] ??
                        streamURLs[YouTubeVideoQuality.hd720] ??
                        streamURLs[YouTubeVideoQuality.medium360] ??
                        streamURLs[YouTubeVideoQuality.small240]
                    ) {
                        
                        if self.allowsToPlay {
                            self.addPlayer(AVPlayer(url: streamURL))
                        } else {
                            print("❌ Not allowed to add Player")
                        }
                        
                    } else {
                        print("❌ Can't start player by youTube URL, try again....")
                        
                        self.setupPlayer(with: youtubeVideoIdentifier)
                    }
                }
    }
     
    private func addPlayer(_ player: AVPlayer) {
        stopPlayer()
        
        self.player = player
        self.playerLayer = AVPlayerLayer(player: player)
        
        self.view.layoutIfNeeded()
        
        if self.playerLayer != nil {
            self.playerLayer!.frame = playerView.bounds
            self.playerView.layer.addSublayer(playerLayer!)
        }
         
        player.play()
        /// - >>  6 min
        let startPoint = CMTime(seconds: 360, preferredTimescale: 1)
        player.seek(to: startPoint)
    }
    
    func selectedRoleToLive(role: AgoraClientRole) {
        delegate?.roleVC(self, didSelect: role)
    }
    
    @IBAction func closeTapped(sender: Any) {
        
        dismissCallback!()
        logout()
        stopPlayer()
         
        self.dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
    }
     
    func logout() {
        guard AgoraRtm.status == .online else {
            return
        }
        
        AgoraRtm.kit?.logout(completion: { (error) in
            guard error == .ok else {
                return
            }
            
            AgoraRtm.status = .offline
        })
    }
     
}

// MARK: - IBActions
extension WelcomeLiveViewController {
    @IBAction func joinWithVideoTapped(_ sender: Any) {
        
        //selectedRoleToLive(role: .broadcaster)
         
        if let dp = UserManager.shared.profile.dinnerParty {
            
            agoraManager.setRoom("group.live.\(dp.id)")
            
            appendGroupLiveAndChat(role: .broadcaster)
        } else {
            showError(message: "You are not a member of any group, click 'continue' or join the dinner party")
        }
    }
    
    @IBAction func takeSelfieTapped(_ sender: Any) {
        
        if let dp = UserManager.shared.profile.dinnerParty {
            
            agoraManager.setRoom("group.live.\(dp.id)")
            
            appendGroupLiveAndChat(role: .audience)
        } else {
            showError(message: "You are not a member of any group, click 'continue' or join the dinner party")
        }
    }
    
    @IBAction func continueTapped(_ sender: Any) {
        appendChat("app.watch.church.live.chat")
    }
}


extension WelcomeLiveViewController: memberCountProtocol {
    func count(_ channel: AgoraRtmChannel, memberCount count: Int32) {
        //print("NEW MEMBER COUNT: \(count)")
        userCountLabel.text = "\(count)"
    }
}



struct YouTubeVideoQuality {
    static let hd720 = NSNumber(value: XCDYouTubeVideoQuality.HD720.rawValue)
    static let medium360 = NSNumber(value: XCDYouTubeVideoQuality.medium360.rawValue)
    static let small240 = NSNumber(value: XCDYouTubeVideoQuality.small240.rawValue)
}
