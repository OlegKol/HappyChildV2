//
//  OnlinePlayer.swift
//  Cleverl
//
//  Created by Евгений on 5/9/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration
import MediaPlayer


public class OnlinePlayer: UIView, BasePlayerProtocol, VLCMediaPlayerDelegate {
    
    //MARK: - BasePlayerProtocol
    private var player: VLCMediaPlayer = {
        var player = VLCMediaPlayer()
        return player
    }()
    public var delegateScreen: ScreenPlayerProtocol?
    
    public var orientation: Orientation = .portrait
    dynamic public var state: StateScreenPlayer = .short {
        didSet{
            self.checkFullScreenState()
        }
    }
    
    private var isPlay:Bool = false {
        didSet {
            self.updatePlayButtonState()
        }
    }
    
    public func play() {
        self.player.play()
        self.isPlay = true
    }
    
    public func stop() {
        self.player.stop()
        self.isPlay = false
        self.hideWaitingView()
    }
    
    public func pause() {
        self.player.pause()
        self.isPlay = false
        self.hideWaitingView()
    }
    
    public func changeStateScreenPlayer(_ state: StateScreenPlayer) {
        self.state = state
    }
    
    public func setUrl(url: URL) {
        let media = VLCMedia(url: url)
        media.addOptions(["network-caching": 300])
        self.player.media = media
    }
    
    
    //MARK: - Views
    private var playerView: UIView = UIView()
    private var panelTools: UIView =  {
        var view = UIView()
        view.backgroundColor = UIColor.init(white: 0, alpha: 0.3)
        return view
    }()
      
    private var playLayer: CAShapeLayer = CAShapeLayer()
    private var playButton: UIView = {
      var button = UIView()
      return button
    }()

    private var screenLayer: CAShapeLayer = CAShapeLayer()
    private var screenButton: UIView = {
      var button = UIView()
      return button
    }()

    private var stopLayer: CAShapeLayer = CAShapeLayer()
    private var stopButton: UIView = {
      var button = UIView()
      return button
    }()
    
    private var waitingView: UIActivityIndicatorView = {
        var view = UIActivityIndicatorView()
        view.style = UIActivityIndicatorView.Style.large
        view.backgroundColor = UIColor.init(white: 0, alpha: 0.3)
        view.color = .white
        return view
    }()
    
    var volumeImage: UIImageView = {
        var view = UIImageView(image: UIImage(named: "volume_off"))
        view.isUserInteractionEnabled = true
        return view
    }()
    var isAudioOn: Bool = false
       
    //MARK: - SIZE_PLAYER_ELEMENT
    private let SIZE_PANEL: CGFloat = 55
    private let SIZE_PLAY_BUTTON: CGFloat = 30
    private let SIZE_STOP_BUTTON: CGFloat = 30
    private let SIZE_SCREEN_BUTTON: CGFloat = 30
    
    private let SIZE_VOLUME_ICON: CGFloat = 30
    private let SIZE_VOLUME_SLIDER_WIDTH: CGFloat = 70
    private let SIZE_VOLUME_SLIDER_HEIGHT: CGFloat = 30
    
    private var TimerListenConnection: Timer?
    private var lastStatePlayer: VLCMediaPlayerState?
    
    
    //MARK: - Configuare functions
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configuarePlayer()
        self.configuareWaitingView()
        
        self.configuareToolsPanel()
        self.configuareScreenButton()
        self.configuarePlayButton()
        self.configaureStopButton()
        
        self.configuareVolumeSlider()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configuarePlayer(){
        self.addSubview(self.playerView)
        self.player.delegate = self
        self.player.drawable = self.playerView
    }
    
    func configuareToolsPanel(){
        self.addSubview(self.panelTools)
        self.panelTools.layer.masksToBounds = true
    }
    
    func configuarePlayButton(){
        self.panelTools.addSubview(self.playButton)
        self.playButton.isUserInteractionEnabled = true
        self.playButton.layer.addSublayer(self.playLayer)
        self.playButton.layer.masksToBounds = true
        let touch = UITapGestureRecognizer(target: self, action: #selector(self.handlePlayButton))
        self.playButton.addGestureRecognizer(touch)
    }
    
    func configuareScreenButton(){
        self.panelTools.addSubview(self.screenButton)
        self.screenButton.isUserInteractionEnabled = true
        self.screenButton.layer.addSublayer(self.screenLayer)
        self.screenButton.layer.masksToBounds = true
        let touch = UITapGestureRecognizer(target: self, action: #selector(self.handleScreenButton))
        self.screenButton.addGestureRecognizer(touch)
    }
    
    func configaureStopButton() {
        self.panelTools.addSubview(self.stopButton)
        self.stopButton.isUserInteractionEnabled = true
        self.stopButton.layer.addSublayer(self.stopLayer)
        self.stopButton.layer.masksToBounds = true
        let touch = UITapGestureRecognizer(target: self, action: #selector(self.handleStopButton))
        self.stopButton.addGestureRecognizer(touch)
    }
    
    func configuareWaitingView(){
        self.addSubview(self.waitingView)
        self.waitingView.translatesAutoresizingMaskIntoConstraints = false
        self.waitingView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.waitingView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.waitingView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.waitingView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    func configuareVolumeSlider(){
        self.panelTools.addSubview(self.volumeImage)
        let touch = UITapGestureRecognizer(target: self, action: #selector(changeVolumeState))
        self.volumeImage.addGestureRecognizer(touch)
    }
   
    @objc private func changeVolumeState(){
       self.isAudioOn ? self.OffAudioVolume() : self.OnAudioVolume()
    }

    private func OffAudioVolume(){
       self.player.currentAudioTrackIndex = -1
       self.isAudioOn = false
       DispatchQueue.main.async {
        self.volumeImage.image = UIImage(named: "volume_off")
       }
    }

    private func OnAudioVolume(){
        self.player.currentAudioTrackIndex = 1
       self.isAudioOn = true
       DispatchQueue.main.async {
            self.volumeImage.image = UIImage(named: "volume_on")
       }
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.checkFullScreenState()
        
        self.playerView.frame = self.bounds
        self.panelTools.frame = CGRect(x: 0, y: self.bounds.height - self.SIZE_PANEL, width: self.bounds.width, height: self.SIZE_PANEL)
        self.playButton.frame = CGRect(x: 10, y: self.panelTools.bounds.midY - self.SIZE_PLAY_BUTTON/2, width: self.SIZE_PLAY_BUTTON, height: self.SIZE_PLAY_BUTTON)
        self.screenButton.frame = CGRect(x: self.panelTools.bounds.width - 10 - self.SIZE_SCREEN_BUTTON, y: self.panelTools.bounds.midY - self.SIZE_SCREEN_BUTTON/2, width: self.SIZE_SCREEN_BUTTON, height: self.SIZE_SCREEN_BUTTON)
        self.stopButton.frame = CGRect(x: self.playButton.frame.width + 20, y: self.panelTools.bounds.midY - self.SIZE_STOP_BUTTON/2, width: self.SIZE_STOP_BUTTON, height: self.SIZE_STOP_BUTTON)
        
        self.playButtonShape()
        self.stopButtonShape()
        self.fullScreenButtonShape()
    }
    
   
    private func checkFullScreenState(){
        self.state == .short ? self.fullScreenButtonShape() : self.shortScreenShape()
        if self.state == .full {
           NotificationCenter.default.addObserver(self, selector: #selector(self.checkDeviceOrientation), name: UIDevice.orientationDidChangeNotification, object: nil)
            self.checkDeviceOrientation()
        }
        else {
            NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
            self.rotatePlayerElements(CGAffineTransform(rotationAngle: CGFloat(0)))
        }
    }
    
   
    @objc dynamic func handleScreenButton(){
        self.state = self.state == StateScreenPlayer.short ? StateScreenPlayer.full : StateScreenPlayer.short
        self.delegateScreen?.openPlayer(self, self.state)
    }
    
    @objc func handlePlayButton(){
        self.isPlay ? self.pause() : self.play()
        if self.isPlay {
        }
    }
    
    @objc func handleStopButton(){
        self.stop()
    }
    
    @objc func checkDeviceOrientation(){
        let deviceOrientation = UIDevice.current.orientation
        var angle: Double = 0
        
        switch deviceOrientation {
            case .portrait, .portraitUpsideDown, .landscapeLeft:
                angle = -Double.pi / 2
                break
            case .landscapeRight:
                angle = Double.pi / 2
                break
            default: break
        }
        let transform = CGAffineTransform(rotationAngle: CGFloat(-angle))
        self.rotatePlayerElements(transform)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.updateViews()
    }
    
    func rotatePlayerElements(_ transform: CGAffineTransform) {
        self.playerView.transform = transform
        self.playButton.transform = transform
        self.stopButton.transform = transform
        self.screenButton.transform = transform
        self.waitingView.transform = transform
        self.volumeImage.transform = transform
        self.layoutSubviews()
    }
    
    
    private func updateViews(){
        self.playerView.frame = self.bounds
        let deviceOrientation = UIDevice.current.orientation
        var panelFrame: CGRect
        
        if self.state == .full {
            switch deviceOrientation {
                case .portrait, .portraitUpsideDown, .landscapeLeft:
                    panelFrame = CGRect(x: 0, y: 0, width: self.SIZE_PANEL, height: self.bounds.height)
                    
                    self.panelTools.frame = panelFrame
                    
                    self.playButton.frame = CGRect(x: self.panelTools.bounds.midX - self.SIZE_PLAY_BUTTON/2, y: 10, width: self.SIZE_PLAY_BUTTON, height: self.SIZE_PLAY_BUTTON)
                    self.stopButton.frame = CGRect(x: self.panelTools.bounds.midX - self.SIZE_STOP_BUTTON/2, y: self.playButton.bounds.maxX + 20, width: self.SIZE_STOP_BUTTON, height: self.SIZE_STOP_BUTTON)
                    self.screenButton.frame = CGRect(x: self.panelTools.bounds.midX - self.SIZE_SCREEN_BUTTON/2, y: self.panelTools.bounds.maxY - self.SIZE_SCREEN_BUTTON - 10, width: self.SIZE_SCREEN_BUTTON, height: self.SIZE_SCREEN_BUTTON)
                    
                    self.volumeImage.frame = CGRect(x: self.panelTools.bounds.midX - self.SIZE_VOLUME_ICON/2, y: self.screenButton.frame.minY - 10 - self.SIZE_VOLUME_ICON, width: self.SIZE_VOLUME_ICON, height: self.SIZE_VOLUME_ICON)
                    break
                case .landscapeRight:
                    panelFrame = CGRect(x: self.bounds.width - self.SIZE_PANEL, y: 0, width: self.SIZE_PANEL, height: self.bounds.height)
                    self.panelTools.frame = panelFrame

                    self.playButton.frame = CGRect(x: self.panelTools.bounds.midX - self.SIZE_PLAY_BUTTON/2, y: self.panelTools.bounds.height - 10 - self.SIZE_PLAY_BUTTON, width: self.SIZE_PLAY_BUTTON, height: self.SIZE_PLAY_BUTTON)
                    self.stopButton.frame = CGRect(x: self.panelTools.bounds.midX - self.SIZE_STOP_BUTTON/2, y: self.playButton.frame.minY - 10 - self.SIZE_STOP_BUTTON, width: self.SIZE_STOP_BUTTON, height: self.SIZE_STOP_BUTTON)
                    self.screenButton.frame = CGRect(x: self.panelTools.bounds.midX - self.SIZE_SCREEN_BUTTON/2, y: 10, width: self.SIZE_SCREEN_BUTTON, height: self.SIZE_SCREEN_BUTTON)
                    
                    self.volumeImage.frame = CGRect(x: self.panelTools.bounds.midX - self.SIZE_VOLUME_ICON/2, y: self.screenButton.frame.maxY + 10, width: self.SIZE_VOLUME_ICON, height: self.SIZE_VOLUME_ICON)
                    break
                default: break
            }
        }
        else {
            self.panelTools.frame = CGRect(x: 0, y: self.bounds.height - self.SIZE_PANEL, width: self.bounds.width, height: self.SIZE_PANEL )
            self.playButton.frame = CGRect(x: 10, y: self.panelTools.bounds.midY - self.SIZE_PLAY_BUTTON/2, width: self.SIZE_PLAY_BUTTON, height: self.SIZE_PLAY_BUTTON)
            self.screenButton.frame = CGRect(x: self.panelTools.bounds.width - 10 - self.SIZE_SCREEN_BUTTON, y: self.panelTools.bounds.midY - self.SIZE_SCREEN_BUTTON/2, width: self.SIZE_SCREEN_BUTTON, height: self.SIZE_SCREEN_BUTTON)
            self.stopButton.frame = CGRect(x: self.playButton.frame.width + 20, y: self.panelTools.bounds.midY - self.SIZE_STOP_BUTTON/2, width: self.SIZE_STOP_BUTTON, height: self.SIZE_STOP_BUTTON)
            
            self.volumeImage.frame = CGRect(x: self.screenButton.frame.minX - 10 - self.SIZE_VOLUME_ICON, y: self.panelTools.bounds.midY - self.SIZE_VOLUME_ICON/2, width: self.SIZE_VOLUME_ICON, height: self.SIZE_VOLUME_ICON)
        }
    }
    
    
    public func mediaPlayerStateChanged(_ aNotification: Notification!) {
        if self.isPlay {
            let state = self.player.state
            if state == .error  || state == .esAdded || state == .ended  || state == .stopped {
                self.lastStatePlayer = state
                self.showWaitingView()
                if !ConnectionService.isConnectedToNetwork() {
                    self.createTimerInternetConnection()
                }
            }
            else {
                self.hideWaitingView()
                self.destroyTimer()
            }
            self.isAudioOn ? self.OnAudioVolume() : self.OffAudioVolume()
        }
    }
    
    private func updatePlayButtonState() {
        DispatchQueue.main.async {
            if self.isPlay {
                self.pauseButtonShape()
                self.hideWaitingView()
            } else {
                self.playButtonShape()
            }
        }
    }
    
    private func hideWaitingView(){
        DispatchQueue.main.async {
            self.waitingView.stopAnimating()
        }
    }
    
    private func showWaitingView(){
        DispatchQueue.main.async {
            self.waitingView.startAnimating()
        }
    }
    
    private func createTimerInternetConnection() {
        if self.TimerListenConnection == nil || (self.TimerListenConnection != nil && !self.TimerListenConnection!.isValid) {
             self.TimerListenConnection = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(checkInternetConnection), userInfo: nil, repeats: true)
        }
    }
    
    @objc private func checkInternetConnection(){
        ConnectionService.isInternetAvailable(webSiteToPing: nil) { (isInternetAvailable) in
            if self.isPlay &&
                isInternetAvailable &&
                (self.lastStatePlayer == .error  || self.lastStatePlayer == .esAdded || self.lastStatePlayer == .ended  || self.lastStatePlayer == .stopped) {
                self.stop()
                self.play()
                self.destroyTimer()
            }
        }
    }
    
    private func destroyTimer() {
        self.TimerListenConnection?.invalidate()
    }
}
 


//MARK: - SHAPES FOR OnlinePlayer
extension OnlinePlayer {
    
    private func fullScreenButtonShape(){
           let path = UIBezierPath()
           self.screenLayer.frame = self.screenButton.bounds
           
           let width = self.screenButton.bounds.width
           let height = self.screenButton.bounds.height
           let lineWidth: CGFloat = 3
           
           path.move(to: CGPoint(x: 0, y: 0))
           path.addLine(to: CGPoint(x: width , y: 0))
           path.addLine(to: CGPoint(x: width, y: height))
           path.addLine(to: CGPoint(x: 0, y: height))
           path.addLine(to: CGPoint(x: 0, y: 0))
           
           self.screenLayer.strokeColor = UIColor.white.cgColor
           self.screenLayer.fillColor = UIColor.clear.cgColor
           self.screenLayer.path = path.cgPath
           self.screenLayer.lineWidth = lineWidth
    }
    
    private func shortScreenShape(){
           let path = UIBezierPath()
           self.screenLayer.frame = self.screenButton.bounds
                  
           let width = self.screenButton.bounds.width
           let height = self.screenButton.bounds.height
           let lineWidth: CGFloat = 3
           let padding: CGFloat = 9
                  
           path.move(to: CGPoint(x: 0, y: padding))
           path.addLine(to: CGPoint(x: padding, y: padding))
           path.addLine(to: CGPoint(x: padding, y: 0))
           
           path.move(to: CGPoint(x: width - padding, y: 0))
           path.addLine(to: CGPoint(x: width - padding, y: padding))
           path.addLine(to: CGPoint(x: width, y: padding))
           
           path.move(to: CGPoint(x: width, y: height - padding))
           path.addLine(to: CGPoint(x: width - padding, y: height - padding))
           path.addLine(to: CGPoint(x: width - padding, y: height))
           
           path.move(to: CGPoint(x: 0, y: height - padding))
           path.addLine(to: CGPoint(x: padding, y: height - padding))
           path.addLine(to: CGPoint(x: padding, y: height))
                  
           self.screenLayer.strokeColor = UIColor.white.cgColor
           self.screenLayer.fillColor = UIColor.clear.cgColor
           self.screenLayer.path = path.cgPath
           self.screenLayer.lineWidth = lineWidth
    }
       
    private func stopButtonShape(){
           let path = UIBezierPath()
           self.stopLayer.frame = self.stopButton.bounds
                  
           let width = self.stopButton.bounds.width
           let height = self.stopButton.bounds.height
           let lineWidth: CGFloat = 3
                  
           path.move(to: CGPoint(x: 0, y: 0))
           path.addLine(to: CGPoint(x: width, y: 0))
           path.addLine(to: CGPoint(x: width, y: height))
           path.addLine(to: CGPoint(x: 0, y: height))
           path.addLine(to: CGPoint(x: 0, y: 0))
                  
           self.stopLayer.strokeColor = UIColor.white.cgColor
           self.stopLayer.fillColor = UIColor.white.cgColor
           self.stopLayer.path = path.cgPath
           self.stopLayer.lineWidth = lineWidth
    }
    
    private func playButtonShape(){
           let path = UIBezierPath()
           self.playLayer.frame = self.playButton.bounds
           self.playLayer.lineJoin = .round
           let width = self.playButton.bounds.width
           let height = self.playButton.bounds.height
           
           path.move(to: CGPoint(x: 0, y: 0))
           path.addLine(to: CGPoint(x: width, y: height/2))
           path.addLine(to: CGPoint(x: 0, y: height))
           path.addLine(to: CGPoint(x: 0, y: 0))
           
           self.playLayer.strokeColor = UIColor.white.cgColor
           self.playLayer.fillColor = UIColor.white.cgColor
           self.playLayer.path = path.cgPath
    }
       
    private func pauseButtonShape(){
           let path = UIBezierPath()
           self.playLayer.frame = self.playButton.bounds
           let width = self.playButton.bounds.width
           let height = self.playButton.bounds.height
           
           let padding:CGFloat = 5
           let widthLine:CGFloat = 10
           let heightLine:CGFloat = 30
           
           path.move(to: CGPoint(x: width/2 - padding/2 - widthLine, y: height/2 - heightLine/2))
           path.addLine(to: CGPoint(x: width/2 - padding/2, y: height/2 - heightLine/2))
           path.addLine(to: CGPoint(x: width/2 - padding/2, y: height/2 + heightLine/2))
           path.addLine(to: CGPoint(x: width/2 - padding/2 - widthLine, y: height/2 + heightLine/2))
           path.addLine(to: CGPoint(x: width/2 - padding/2 - widthLine, y: height/2 - heightLine/2))
           
           path.move(to: CGPoint(x: width/2 + padding/2, y: height/2 - heightLine/2))
           path.addLine(to: CGPoint(x: width/2 + padding/2 + widthLine, y: height/2 - heightLine/2))
           path.addLine(to: CGPoint(x: width/2 + padding/2 + widthLine, y: height/2 + heightLine/2))
           path.addLine(to: CGPoint(x: width/2 + padding/2, y: height/2 + heightLine/2))
           path.addLine(to: CGPoint(x: width/2 + padding/2, y: height/2 - heightLine/2))
           
           self.playLayer.strokeColor = UIColor.white.cgColor
           self.playLayer.fillColor = UIColor.white.cgColor
           self.playLayer.path = path.cgPath
    }
}
