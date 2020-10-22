//
//  LauncherVideoView.swift
//  HappyChild
//
//  Created by Евгений on 11/16/19.
//  Copyright © 2019 Oberon. All rights reserved.
//

import Foundation
import UIKit

public class LauncherVideoView:NSObject {
    
    
    func showVideoView(){
        
        if let keyWindow = UIApplication.shared.keyWindow {
            let videoView = VideoFullDecriptionView(frame: .zero)
            videoView.backgroundColor = .white
            keyWindow.addSubview(videoView)
            
            UIView.animate(withDuration: 0.5, animations: {
                videoView.frame = keyWindow.frame
            })
        }
    }
}
