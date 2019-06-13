//
//  RotatingButton.swift
//  PlayLog
//
//  Created by Prasanth pc on 2019-03-30.
//  Copyright © 2019 Prasanth pc. All rights reserved.
//

import UIKit.UIGestureRecognizerSubclass

protocol RotatingButtonDelegate: NSObject {
    func buttonSelectedAtIndex(value : Int)
}

class RotatingButton: UIControl {
    var minimumValue: Float = 0
    var maximumValue: Float = 1.0
    
    private (set) var value: Float = 0
    private let renderer = RotatingButtonRenderer()
    weak var delegate: RotatingButtonDelegate?
    var imageCount: Int = 0
    
    private func commonInit() {
        renderer.updateBounds(bounds)
        renderer.color = .orange
        renderer.lineWidth = 5.0
        renderer.setPointerAngle(renderer.startAngle, animated: false)
        
        layer.addSublayer(renderer.trackLayer)
        layer.addSublayer(renderer.pointerLayer)
        
        renderer.addTextLayer()
        
        let gestureRecognizer = RotationGestureRecognizer(target: self, action: #selector(RotatingButton.handleGesture(_:)))
        addGestureRecognizer(gestureRecognizer)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(userTappedOnButton(_:)))
        addGestureRecognizer(tapGesture)
    }
    
    func selectedImage(count: Int) {
        imageCount = count
    }
    
    @objc private func userTappedOnButton(_ gesture: UITapGestureRecognizer) {
        let randomNumber = drand48()
        setValue(Float(randomNumber), animated: true)
    }
    
    @objc private func handleGesture(_ gesture: RotationGestureRecognizer) {
       
        let midPointAngle = (2 * CGFloat(Double.pi) + startAngle - endAngle) / 2 + endAngle
        var boundedAngle = gesture.touchAngle
        let angleRange = endAngle - startAngle
        let valueRange = maximumValue - minimumValue
        let angleValue = Float(boundedAngle - startAngle) / Float(angleRange) * valueRange + minimumValue
        
        if boundedAngle < (midPointAngle - 2 * CGFloat(Double.pi)) {
            boundedAngle = 2 * CGFloat(Double.pi)
            let difference = CGFloat(0.25) + CGFloat(angleValue)
            let newValue = CGFloat(0.75) + difference
            setValue(Float(newValue))
        } else {
            setValue(angleValue)
        }
        
    }
    
    func setValue(_ newValue: Float, animated: Bool = false) {
        value = min(maximumValue, max(minimumValue, newValue))
        let angleRange = endAngle - startAngle
        let valueRange = maximumValue - minimumValue
        let angleValue = CGFloat(value - minimumValue) / CGFloat(valueRange) * angleRange + startAngle
        renderer.setPointerAngle(angleValue, animated: animated)
        let buttonValueInDegrees = String(format:"\(Int(newValue*360))")
        renderer.changeButtonText(value: buttonValueInDegrees)
        renderer.rotateTextLayer(value: -angleValue)
        
        if newValue > 0.0 && imageCount > 0 {
           let arrayIndex = Int(newValue * 100) / Int((1.0/Float(imageCount)) * 100)
           delegate?.buttonSelectedAtIndex(value: Int(arrayIndex))
        }
       
    }
    var isContinuous = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeButton()
        
    }
    
    private func initializeButton() {
        backgroundColor = .clear
        commonInit()
    }
    
    var lineWidth: CGFloat {
        get { return renderer.lineWidth }
        set { renderer.lineWidth = newValue }
    }
    
    var startAngle: CGFloat {
        get { return renderer.startAngle }
        set { renderer.startAngle = newValue }
    }
    
    var endAngle: CGFloat {
        get { return renderer.endAngle }
        set { renderer.endAngle = newValue }
    }
    
    var pointerLength: CGFloat {
        get { return renderer.pointerLength }
        set { renderer.pointerLength = newValue }
    }

    
}

