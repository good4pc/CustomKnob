//
//  ButtonRenderer.swift
//  PlayLog
//
//  Created by Prasanth pc on 2019-03-31.
//  Copyright © 2019 Prasanth pc. All rights reserved.
//

import Foundation
import UIKit

class RotatingButtonRenderer {
    let trackLayer = CAShapeLayer()
    let pointerLayer = CAShapeLayer()
    
    init() {
        trackLayer.fillColor = UIColor.clear.cgColor
        pointerLayer.fillColor = buttonFillColor.cgColor
    }
    
    var buttonFillColor: UIColor = .white
    var color: UIColor = .orange {
        didSet {
            trackLayer.strokeColor = color.cgColor
            pointerLayer.strokeColor = color.cgColor
        }
    }
    
    var lineWidth: CGFloat = 10.0 {
        didSet {
            trackLayer.lineWidth = lineWidth
            pointerLayer.lineWidth = lineWidth
            updateTrackLayerPath()
            updatePointerLayerPath()
        }
    }

    var startAngle: CGFloat = CGFloat(Double.pi) {
        didSet {
            updateTrackLayerPath()
        }
    }
   
    var endAngle: CGFloat = CGFloat(Double.pi) * 4 {
        didSet {
            updateTrackLayerPath()
        }
    }
    
    var pointerLength: CGFloat = 6 {
        didSet {
            updateTrackLayerPath()
            updatePointerLayerPath()
        }
    }
    
    private (set) var pointerAngle: CGFloat = CGFloat(-Double.pi) * 11/8
    
    func setPointerAngle(_ newPointerAngle: CGFloat, animated: Bool = false) {
        
        if animated {
            let midAngleValue = (max(newPointerAngle, pointerAngle) - min(newPointerAngle, pointerAngle)) / 2
                + min(newPointerAngle, pointerAngle)
            let animation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
            animation.values = [pointerAngle, midAngleValue, newPointerAngle]
            animation.keyTimes = [0.0, 0.5, 1.0]
            animation.timingFunctions = [CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)]
            pointerLayer.add(animation, forKey: nil)
        }
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        pointerLayer.transform = CATransform3DMakeRotation(newPointerAngle, 0, 0, 1)
        CATransaction.commit()
        pointerAngle = newPointerAngle
    }
    
    private func updateTrackLayerPath() {
        let bounds = trackLayer.bounds
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let offset = max(pointerLength, lineWidth/2)
        let radius = min(bounds.width, bounds.height)/2 - offset
        let ring = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        trackLayer.path = ring.cgPath
    }
    
    private func updatePointerLayerPath() {
        let bounds = trackLayer.bounds
        let center = CGPoint(x: bounds.width - CGFloat(pointerLength) - CGFloat(lineWidth)/2, y: bounds.midY)
        let roundedButtonPath = UIBezierPath(arcCenter: center, radius: 20.0, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        pointerLayer.path = roundedButtonPath.cgPath
    }
    
    func changeButtonText(value: String) {
        guard let layer = pointerLayer.sublayers?.filter({return $0.name == "texLayer"}) else {
            return
        }
        if layer.count > 0 {
            (layer[0] as! CATextLayer).string = value
        }
    }
    
    func rotateTextLayer(value: CGFloat) {
        guard let layer = pointerLayer.sublayers?.filter({return $0.name == "texLayer"}) else {
            return
        }
        if layer.count > 0 {
            CATransaction.begin()
           // CATransaction.setDisableActions(true)
            CATransaction.setAnimationDuration(0.1)
            layer[0].transform = CATransform3DMakeRotation(value, 0, 0, 1)
             CATransaction.commit()
        }
    }
    
    func addTextLayer() {
        let bounds = trackLayer.bounds
        let label = CATextLayer()
        label.name = "texLayer"
        let center = CGPoint(x: bounds.width - CGFloat(pointerLength) - CGFloat(lineWidth)/2, y: bounds.midY)
        label.position = center
        label.bounds = CGRect(x: 0, y: 0, width: 30, height: 20)
       //label.string = "PC"
        label.isWrapped = true
        label.font = CTFontDescriptorCreateWithNameAndSize("helvetica" as CFString, 15)
        label.alignmentMode = .center
        label.backgroundColor = UIColor.clear.cgColor
        pointerLayer.addSublayer(label)
        label.foregroundColor = UIColor.black.cgColor
    }
    
    func updateBounds(_ bounds: CGRect) {
        trackLayer.bounds = bounds
        trackLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        updateTrackLayerPath()
         pointerLayer.bounds = trackLayer.bounds
        pointerLayer.position = trackLayer.position
        updatePointerLayerPath()
    }
}

