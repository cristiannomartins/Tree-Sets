//
//  Checkmark.swift
//  Maison Sets
//
//  Created by Cristianno Vieira on 16/12/15.
//  Copyright © 2015 Cristianno Vieira. All rights reserved.
//

import UIKit

@IBDesignable
class Checkmark: UIView {
  
  @IBInspectable var isChecked: Bool = false {
    didSet {
      setNeedsDisplay()
    }
  }
  
  func drawUnchecked(frame: CGRect) {
    
    //// Oval Drawing
    let ovalPath = UIBezierPath(ovalIn: CGRect(x: 0.05*frame.width, y: 0.05*frame.height, width: frame.width - 0.1*frame.width, height: frame.height - 0.1*frame.height))
    UIColor.black.setStroke()
    ovalPath.lineWidth = frame.height / 13.0
    ovalPath.stroke()
  }
  
  func drawChecked(frame: CGRect) {
    //// Color Declarations
    let color = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
    
    //// Bezier Drawing
    let bezierPath = UIBezierPath()
    bezierPath.move(to: CGPoint(x: frame.minX + 0.68197 * frame.width, y: frame.minY + 0.24714 * frame.height))
    bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.43495 * frame.width, y: frame.minY + 0.57274 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.68005 * frame.width, y: frame.minY + 0.24967 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.52260 * frame.width, y: frame.minY + 0.45720 * frame.height))
    bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.31595 * frame.width, y: frame.minY + 0.48326 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.37918 * frame.width, y: frame.minY + 0.53080 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.31595 * frame.width, y: frame.minY + 0.48326 * frame.height))
    bezierPath.addLine(to: CGPoint(x: frame.minX + 0.25045 * frame.width, y: frame.minY + 0.57039 * frame.height))
    bezierPath.addLine(to: CGPoint(x: frame.minX + 0.45283 * frame.width, y: frame.minY + 0.72256 * frame.height))
    bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.51733 * frame.width, y: frame.minY + 0.63468 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.45283 * frame.width, y: frame.minY + 0.72256 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.51834 * frame.width, y: frame.minY + 0.63544 * frame.height))
    bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.76408 * frame.width, y: frame.minY + 0.30943 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.60557 * frame.width, y: frame.minY + 0.51837 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.76408 * frame.width, y: frame.minY + 0.30943 * frame.height))
    bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.68199 * frame.width, y: frame.minY + 0.24715 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.76408 * frame.width, y: frame.minY + 0.30943 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.68197 * frame.width, y: frame.minY + 0.24714 * frame.height))
    bezierPath.addLine(to: CGPoint(x: frame.minX + 0.68197 * frame.width, y: frame.minY + 0.24714 * frame.height))
    bezierPath.close()
    
    bezierPath.move(to: CGPoint(x: frame.minX + frame.width, y: frame.minY + 0.5 * frame.height))
    bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.5 * frame.width, y: frame.minY + frame.height), controlPoint1: CGPoint(x: frame.minX + frame.width, y: frame.minY + 0.77614 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.77614 * frame.width, y: frame.minY + frame.height))
    bezierPath.addCurve(to: CGPoint(x: frame.minX, y: frame.minY + 0.5 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.22386 * frame.width, y: frame.minY + frame.height), controlPoint2: CGPoint(x: frame.minX, y: frame.minY + 0.77614 * frame.height))
    bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.19793 * frame.width, y: frame.minY + 0.10153 * frame.height), controlPoint1: CGPoint(x: frame.minX, y: frame.minY + 0.33735 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.07766 * frame.width, y: frame.minY + 0.19284 * frame.height))
    bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.5 * frame.width, y: frame.minY), controlPoint1: CGPoint(x: frame.minX + 0.28184 * frame.width, y: frame.minY + 0.03781 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.38651 * frame.width, y: frame.minY))
    bezierPath.addCurve(to: CGPoint(x: frame.minX + frame.width, y: frame.minY + 0.5 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.77614 * frame.width, y: frame.minY), controlPoint2: CGPoint(x: frame.minX + frame.width, y: frame.minY + 0.22386 * frame.height))
    bezierPath.close()
    
    color.setFill()
    bezierPath.fill()
  }
  
  // Only override drawRect: if you perform custom drawing.
  // An empty implementation adversely affects performance during animation.
  override func draw(_ rect: CGRect) {
    //backgroundColor = UIColor.redColor()
    if isChecked {
      drawChecked(frame: rect)
    } else {
      drawUnchecked(frame: rect)
    }
  }
  
}
