//
//  StreamPlayer.swift
//  Cleverl
//
//  Created by Евгений on 5/13/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import MediaPlayer

public class StreamPlayer: UIView, LocalPlayerProtocol {
    
    
    //MARK: - LocalPlayerProtocol implementation
    public func changeStateScreenPlayer(_ state: StateScreenPlayer) {
        
    }
    
    public var currentTime: Date = Date()
    
    public var allTime: Date = Date()
    
    public var orientation: Orientation = .portrait
    public var state: StateScreenPlayer = .short {
        didSet {
            self.checkStateScreenPlayer()
        }
    }
    public var delegateScreen: ScreenPlayerProtocol?
    
    private var isPlaying: Bool = false {
        didSet{
            self.isPlaying ? self.pauseShape() : self.playShape()
        }
    }
    
    public func Next(seconds: Int) {
        
    }
    
    public func Prev(seconds: Int) {
        
    }
    
    public func play() {
        self.player?.play()
    }
    
    public func stop() {
        self.player?.pause()
    }
    
    public func pause() {
        self.player?.pause()
    }
    
    public func setUrl(url: URL) {
        if self.playLayer != nil && self.player != nil {
            self.playLayer?.removeFromSuperlayer()
            self.playLayer = nil
            self.player?.removeObserver(self, forKeyPath: "currentItem.loadedTimeRanges")
            self.player = nil
            self.isPlaying = false
            self.timeSlider.setValue(0, animated: false)
        }
        self.player = AVPlayer(url: url)
        self.playLayer = AVPlayerLayer(player: self.player)
        self.playerView.layer.addSublayer(self.playLayer!)
        self.playLayer!.frame = self.bounds
        self.player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
        self.OffAudioVolume()
    }
    
    //MARK: - Views
    private var playerView: UIView = UIView()
    private var panelTools: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(white: 0, alpha: 0.4)
        return view
    }()
    
    private var playShapeLayer: CAShapeLayer = CAShapeLayer()
    private var playButton: UIView = {
        var button = UIView()
        return button
    }()
    
    private var screenLayer: CAShapeLayer = CAShapeLayer()
    private var screenButton: UIView = {
        var button = UIView()
        return button
    }()
    
    var videoLenghtLabel: UILabel = {
        var label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: AppConstants.APP_ROBOTO_MEDIUM, size: 14)
        label.text = "00:00"
        return label
    }()
    
    var timeSlider: UISlider = {
        let slider = UISlider()
        slider.minimumTrackTintColor = AppConstants.APP_DEFAULT_TEXT_COLOR
        slider.maximumTrackTintColor = .white
        return slider
    }()
    
    var volumeImage: UIImageView = {
       var view = UIImageView(image: UIImage(named: ""))
        view.isUserInteractionEnabled = true
        return view
    }()
    
    var isAudioOn: Bool = false
    
    private var player: AVPlayer?
    private var playLayer: AVPlayerLayer?
    
    
    //MARK: - SIZE_PLAYER_ELEMENT
    private let SIZE_PANEL: CGFloat = 55
    private let SIZE_PLAY_BUTTON: CGFloat = 30
    private let SIZE_STOP_BUTTON: CGFloat = 30
    private let SIZE_SCREEN_BUTTON: CGFloat = 30
    private let SIZE_TIME_LABEL: CGFloat = 60
    
    private let SIZE_VOLUME_ICON: CGFloat = 30
    private let SIZE_VOLUME_SLIDER_WIDTH: CGFloat = 70
    private let SIZE_VOLUME_SLIDER_HEIGHT: CGFloat = 30
    
    //MARK: - Default init functions
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configuarePlayer()
        self.confgiaureControlsContainer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configuarePlayer(){
        self.addSubview(self.playerView)
    }
    
    func confgiaureControlsContainer(){
        self.addSubview(self.panelTools)
    
        self.configuarePlayButton()
        self.configuareScreenButton()
        
        self.configuareVideoLengthLabel()
        self.configuareTimeSlider()
        
        self.configuareVolumeSlider()
    }
    
    func configuarePlayButton(){
        self.panelTools.addSubview(self.playButton)
        self.playButton.isUserInteractionEnabled = true
        self.playButton.layer.addSublayer(self.playShapeLayer)
        let touch = UITapGestureRecognizer(target: self, action: #selector(self.handlePlayButton))
        self.playButton.addGestureRecognizer(touch)
        self.playButton.layer.masksToBounds = true
    }
    
    func configuareScreenButton(){
        self.panelTools.addSubview(self.screenButton)
        self.screenButton.isUserInteractionEnabled = true
        self.screenButton.layer.addSublayer(self.screenLayer)
        self.screenButton.layer.masksToBounds = true
        let touch = UITapGestureRecognizer(target: self, action: #selector(self.handleScreenState))
        self.screenButton.addGestureRecognizer(touch)
    }
    
    func configuareVideoLengthLabel(){
        self.panelTools.addSubview(self.videoLenghtLabel)
        self.videoLenghtLabel.textAlignment = .right
    }
    
    func configuareTimeSlider(){
        self.panelTools.addSubview(self.timeSlider)
        self.timeSlider.addTarget(self, action: #selector(handleSlider), for: .valueChanged)
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
        self.player?.isMuted = true
        self.isAudioOn = false
        DispatchQueue.main.async {
            self.volumeImage.image = UIImage(named: "volume_off")
        }
    }
    
    private func OnAudioVolume(){
        self.player?.isMuted = false
        self.isAudioOn = true
        DispatchQueue.main.async {
             self.volumeImage.image = UIImage(named: "volume_on")
        }
    }
    
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.playerView.frame = self.bounds
        self.playShape()
        self.fullScreenShape()
    }
    
    @objc func handlePlayButton(){
        self.isPlaying = !self.isPlaying
        self.isPlaying ? self.play() : self.pause()
    }
    
    @objc func handleScreenState(){
       self.state = self.state == StateScreenPlayer.short ? StateScreenPlayer.full : StateScreenPlayer.short
    }
   
    func checkStateScreenPlayer(){
       if self.delegateScreen != nil {
           self.delegateScreen?.openPlayer(self, self.state)
           self.handleScreenButton()
       }
    }
    
    @objc private func handleScreenButton(){
        self.state == .short ? self.fullScreenShape() : self.shortScreenShape()
        if self.state == .full {
           NotificationCenter.default.addObserver(self, selector: #selector(self.checkDeviceOrientation), name: UIDevice.orientationDidChangeNotification, object: nil)
            self.checkDeviceOrientation()
        }
        else {
            NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
            self.rotatePlayerElements(CGAffineTransform(rotationAngle: CGFloat(0)))
        }
    }
    
    func rotatePlayerElements(_ transform: CGAffineTransform) {
        self.playerView.transform = transform
        self.playButton.transform = transform
        self.screenButton.transform = transform
        self.videoLenghtLabel.transform = transform
        self.timeSlider.transform = transform
        self.volumeImage.transform = transform
        self.layoutSubviews()
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
    
    @objc func handleSlider(){
        if let duration = self.player?.currentItem?.duration {
            let totalSeconds = CMTimeGetSeconds(duration)
            let value = Float64(self.timeSlider.value) * totalSeconds
            let seekTime = CMTime(value: Int64(value), timescale: 1)
            self.player?.seek(to: seekTime, completionHandler: { (completion) in
                
            })
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.playerView.frame = self.bounds
        self.playLayer?.frame = self.playerView.bounds
        self.updateViews()
    }
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "currentItem.loadedTimeRanges" {
            if let duration = self.player?.currentItem?.duration {
                let seconds = CMTimeGetSeconds(duration)
                let secondsText = Int(seconds) % 60
                let minutesText = Int(seconds) / 60
                self.videoLenghtLabel.text = String(format: "%02i:%02i", minutesText, secondsText)
            }
        }
    }
    
    private func updateViews(){
        self.playerView.frame = self.bounds
        let deviceOrientation = UIDevice.current.orientation
        var panelFrame: CGRect
        
        if self.state == .full {
               switch deviceOrientation {
               case .portrait, .portraitUpsideDown,  .landscapeLeft:
                panelFrame = CGRect(x: 0, y: 0, width: self.SIZE_PANEL, height: self.bounds.height)
                self.panelTools.frame = panelFrame
                self.playButton.frame = CGRect(x: self.panelTools.bounds.midX - self.SIZE_PLAY_BUTTON/2, y: 10, width: self.SIZE_PLAY_BUTTON, height: self.SIZE_PLAY_BUTTON)
                self.screenButton.frame = CGRect(x: self.panelTools.bounds.midX - self.SIZE_SCREEN_BUTTON/2, y: self.panelTools.bounds.maxY - self.SIZE_SCREEN_BUTTON - 10, width: self.SIZE_SCREEN_BUTTON, height: self.SIZE_SCREEN_BUTTON)
                
                self.volumeImage.frame = CGRect(x: self.panelTools.bounds.midX - self.SIZE_VOLUME_ICON/2, y: self.screenButton.frame.minY - 10 - self.SIZE_VOLUME_ICON, width: self.SIZE_VOLUME_ICON, height: self.SIZE_VOLUME_ICON)
                
                self.videoLenghtLabel.frame = CGRect(x: self.panelTools.bounds.midX - self.SIZE_SCREEN_BUTTON/2, y: self.volumeImage.frame.minY - 10 - self.SIZE_TIME_LABEL, width: self.SIZE_SCREEN_BUTTON, height: self.SIZE_TIME_LABEL)
                self.timeSlider.frame = CGRect(x: self.panelTools.bounds.midX - self.SIZE_PLAY_BUTTON/2, y: self.playButton.frame.maxY + 10, width: self.SIZE_PLAY_BUTTON, height: self.videoLenghtLabel.frame.minY - (self.playButton.frame.maxY + 20))
                  break
               case .landscapeRight:
                    panelFrame = CGRect(x: self.bounds.width - self.SIZE_PANEL, y: 0, width:  self.SIZE_PANEL, height: self.bounds.height)
                    self.panelTools.frame = panelFrame
                    self.playButton.frame = CGRect(x: self.panelTools.bounds.midX - self.SIZE_PLAY_BUTTON/2, y: self.panelTools.bounds.height - 10 - self.SIZE_PLAY_BUTTON, width: self.SIZE_PLAY_BUTTON, height: self.SIZE_PLAY_BUTTON)
                    self.screenButton.frame = CGRect(x: self.panelTools.bounds.midX - self.SIZE_SCREEN_BUTTON/2, y: 10, width: self.SIZE_SCREEN_BUTTON, height: self.SIZE_SCREEN_BUTTON)
                    
                    self.volumeImage.frame = CGRect(x: self.panelTools.bounds.midX - self.SIZE_VOLUME_ICON/2, y: self.screenButton.frame.maxY + 10, width: self.SIZE_VOLUME_ICON, height: self.SIZE_VOLUME_ICON)
                    
                    self.videoLenghtLabel.frame = CGRect(x: self.panelTools.bounds.midX - self.SIZE_SCREEN_BUTTON/2, y: self.volumeImage.frame.maxY + 20, width: self.SIZE_SCREEN_BUTTON, height: self.SIZE_TIME_LABEL)
                    self.timeSlider.frame = CGRect(x: self.panelTools.bounds.midX - self.SIZE_PLAY_BUTTON/2, y: self.videoLenghtLabel.frame.maxY, width: self.SIZE_PLAY_BUTTON, height: self.playButton.frame.minY - self.videoLenghtLabel.frame.maxY)
                  break
               default: break
               }
        }
        else {
            panelFrame = CGRect(x: 0, y: self.bounds.height - self.SIZE_PANEL, width: self.bounds.width, height: self.SIZE_PANEL)
            self.panelTools.frame = panelFrame
            self.playButton.frame = CGRect(x: 10, y: self.panelTools.bounds.midY - self.SIZE_PLAY_BUTTON/2, width: self.SIZE_PLAY_BUTTON, height: self.SIZE_PLAY_BUTTON)
            self.screenButton.frame = CGRect(x: self.panelTools.bounds.width - 10 - self.SIZE_SCREEN_BUTTON, y: self.panelTools.bounds.midY - self.SIZE_SCREEN_BUTTON/2, width: self.SIZE_SCREEN_BUTTON, height: self.SIZE_SCREEN_BUTTON)
            
            self.volumeImage.frame = CGRect(x: self.screenButton.frame.minX - 10 - self.SIZE_VOLUME_ICON, y: self.panelTools.bounds.midY - self.SIZE_VOLUME_ICON/2, width: self.SIZE_VOLUME_ICON, height: self.SIZE_VOLUME_ICON)
            
            self.videoLenghtLabel.frame = CGRect(x: self.volumeImage.frame.minX - 10 - self.SIZE_TIME_LABEL, y: self.panelTools.bounds.midY - self.SIZE_SCREEN_BUTTON/2, width: self.SIZE_TIME_LABEL, height: self.SIZE_SCREEN_BUTTON)
            self.timeSlider.frame = CGRect(x:self.playButton.frame.maxX + 10, y: self.panelTools.bounds.midY - self.SIZE_SCREEN_BUTTON/2, width: self.videoLenghtLabel.frame.minX - (self.playButton.frame.maxX + 10), height: self.SIZE_SCREEN_BUTTON)
        }
    }
}



//MARK: - SHAPES FOR StreamPlayer
extension StreamPlayer {
    
    private func playShape(){
       let path = UIBezierPath()
       self.playShapeLayer.frame = self.playButton.bounds
       self.playShapeLayer.lineJoin = .round
       let width = self.playButton.bounds.width
       let height = self.playButton.bounds.height
       
       path.move(to: CGPoint(x: 0, y: 0))
       path.addLine(to: CGPoint(x: width, y: height/2))
       path.addLine(to: CGPoint(x: 0, y: height))
       path.addLine(to: CGPoint(x: 0, y: 0))
       
       self.playShapeLayer.strokeColor = UIColor.white.cgColor
       self.playShapeLayer.fillColor = UIColor.white.cgColor
       self.playShapeLayer.path = path.cgPath
    }
       
    private func pauseShape(){
       let path = UIBezierPath()
       self.playShapeLayer.frame = self.playButton.bounds
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
       
       self.playShapeLayer.strokeColor = UIColor.white.cgColor
       self.playShapeLayer.fillColor = UIColor.white.cgColor
       self.playShapeLayer.path = path.cgPath
    }
    
    
    private func fullScreenShape(){
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
}
