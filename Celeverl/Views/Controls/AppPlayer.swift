//
//  AppPlayer.swift
//  HappyChild (mobile)
//
//  Created by Евгений on 1/2/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

//MARK: - AppPlayer
public class AppPlayer: UIView {
    
    private var controlsContainerView: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor.init(white: 0, alpha: 0.55)
        return view
    }()
    
    private var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .whiteLarge)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()
        return indicator
    }()
    
    private var pauseButton: UIButton = {
        var button = UIButton(type: UIButton.ButtonType.system)
        button.setImage(UIImage(named: "pause_picture"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.addTarget(self, action: #selector(handlePause), for: .touchUpInside)
        return button
    }()
    
    
    @objc func handlePause(){
        self.changeStateVideo()
    }
    
    private var playerItem: AVPlayerItem?
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    
    private var IsPlaying: Bool = false
    private var IsMute: Bool = true
    public var url: URL?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        self.initializeData()
    }
    
    func initializeData(){
        
        guard let url = self.url else {return}
        self.playerItem = AVPlayerItem(url: url)
        self.player = AVPlayer(playerItem: playerItem)
        
        self.playerLayer = AVPlayerLayer(player: player)
        self.playerLayer?.frame = self.bounds
        self.playerLayer?.videoGravity = .resizeAspect
        
        self.layer.addSublayer(self.playerLayer!)
        
        self.player?.play()
        self.player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: [.new], context: nil)
        
        self.controlsContainerView.frame = self.bounds
        addSubview(self.controlsContainerView)
        
        self.controlsContainerView.addSubview(self.activityIndicator)
        self.activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        self.controlsContainerView.addSubview(self.pauseButton)
        self.pauseButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.pauseButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.pauseButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        self.pauseButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
    }
     
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "currentItem.loadedTimeRanges" {
            self.activityIndicator.stopAnimating()
            self.controlsContainerView.backgroundColor = .clear
            self.pauseButton.isHidden = true
            self.IsPlaying = true
        }
    }
    
    public func changeStateVideo() {
        if self.IsPlaying {
            self.player?.pause()
            self.pauseButton.setImage(UIImage(named: "play_picture"), for: .normal)
        }
        else {
            self.player?.play()
            self.pauseButton.setImage(UIImage(named: "pause_picture"), for: .normal)
        }
        
        self.IsPlaying = !self.IsPlaying
    }
    
    public func changeAudioStateVideo(){
        self.IsMute = !self.IsMute
        self.player?.isMuted = self.IsMute
    }
    
    
}
