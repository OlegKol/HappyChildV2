//
//  AppViewWithBottomLine.swift
//  Celeverl
//
//  Created by Евгений on 2/12/20.
//  Copyright © 2020 oberon. All rights reserved.
//

import Foundation
import UIKit

public class ViewButtomLine: UIView {
    
    public var IsDrawLine: Bool = true
    public var heightLine: CGFloat = 4.0 {
        didSet{
            self.drawBottomLine()
        }
    }
    public var colorLine: UIColor = .black{
        didSet {
            self.drawBottomLine()
        }
    }
    public var lineLayer: CAShapeLayer = CAShapeLayer()
    
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.addSublayer(self.lineLayer)
        self.drawBottomLine()
    }
    
    private func drawBottomLine(){
        if self.IsDrawLine {
            self.lineLayer.strokeColor = self.colorLine.cgColor
            self.lineLayer.lineWidth = self.heightLine
            let path = self.getBezierPath()
            self.lineLayer.path = path.cgPath
            self.lineLayer.lineCap = .round
        }
    }
    
    
    private func getBezierPath() -> UIBezierPath {
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: self.bounds.height - self.heightLine/2))
        path.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height - self.heightLine/2))
        return path
    }
}
