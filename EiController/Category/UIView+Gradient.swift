//  UIView+Gradient.swift
//  EiController
//
//  Created by Henrikh Koreniuzhenko on 22.09.2018.
//  Copyright © 2018 Koreniuzhenko Henrikh. All rights reserved.
//

import UIKit
import Foundation
import CoreGraphics

private var gradientLayerKey = "gradientLayer"
private var backgroundColorsKey = "backgroundColors"
private var isEnableKey = "isEnable"
private var disableColorKey = "disableColor"
private var startColorKey = "startColor"
private var endColorKey = "endColor"
private var startLocationKey = "startLocation"
private var endLocationKey = "endLocation"
private var horizontalModeKey = "horizontalMode"
private var diagonalModeKey = "diagonalMode"

private var isShowDisableBorderKey = "isShowDisableBorder"
private var borderDisableColorKey = "borderDisableColor"
private var borderStartColorKey = "borderStartColor"
private var borderEndColorKey = "borderEndColor"
private var borderStartLocationKey = "borderStartLocation"
private var borderEndLocationKey = "borderEndLocation"
private var borderHorizontalModeKey = "borderHorizontalMode"
private var borderDiagonalModeKey = "borderDiagonalMode"
private var radiusKey = "radius"
private var lineWidthKey = "lineWidth"
private var borderBackgroundKey = "borderBackground"

@IBDesignable
extension UIView
{
    private var gradientLayer: CAGradientLayer
    {
        get
        {
            var gradient = objc_getAssociatedObject(self, &gradientLayerKey) as? CAGradientLayer
            if gradient == nil
            {
                gradient = CAGradientLayer()
                gradient?.frame = bounds.insetBy(dx: lineWidth, dy: lineWidth)
                layer.insertSublayer(gradient!, at: UInt32(0))
                objc_setAssociatedObject(self, &gradientLayerKey, gradient, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            return gradient!
        }
        set
        {
            objc_setAssociatedObject(self, &gradientLayerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var backgroundColors: [UIColor]
    {
        get
        {
            var result = objc_getAssociatedObject(self, &backgroundColorsKey) as? [UIColor]
            if result == nil
            {
                result = [UIColor]()
                objc_setAssociatedObject(self, &backgroundColorsKey, result, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            return result!
        }
        set
        {
            objc_setAssociatedObject(self, &backgroundColorsKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var isEnable : Bool
    {
        get
        {
            return objc_getAssociatedObject(self, &isEnableKey) as? Bool ?? true
        }
        set
        {
            objc_setAssociatedObject(self, &isEnableKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            isUserInteractionEnabled = newValue
            updateGradient()
            layoutSubviews()
        }
    }

    @IBInspectable var disableColor: UIColor
        {
        get
        {
            return objc_getAssociatedObject(self, &disableColorKey) as? UIColor ?? UIColor.clear
        }
        set
        {
            objc_setAssociatedObject(self, &disableColorKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            updateColors()
        }
    }
    
    @IBInspectable var startColor: UIColor
        {
        get
        {
            return objc_getAssociatedObject(self, &startColorKey) as? UIColor ?? UIColor.clear
        }
        set
        {
            objc_setAssociatedObject(self, &startColorKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if backgroundColors.count > 0
            {
                backgroundColors.removeFirst()
            }
            backgroundColors.insert(newValue, at: 0)
            updateColors()
        }
    }
    @IBInspectable var endColor: UIColor
        {
        get
        {
            return objc_getAssociatedObject(self, &endColorKey) as? UIColor ?? UIColor.clear
        }
        set
        {
            objc_setAssociatedObject(self, &endColorKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            if backgroundColors.count > 1
            {
                backgroundColors.removeLast()
            }
            backgroundColors.append(newValue)
            updateColors()
        }
    }
    @IBInspectable var startLocation: Double
        {
        get
        {
            return objc_getAssociatedObject(self, &startLocationKey) as? Double ?? Double(0)
        }
        set
        {
            objc_setAssociatedObject(self, &startLocationKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            updateLocations()
        }
    }
    @IBInspectable var endLocation: Double
        {
        get
        {
            return objc_getAssociatedObject(self, &endLocationKey) as? Double ?? Double(0)
        }
        set
        {
            objc_setAssociatedObject(self, &endLocationKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            updateLocations()
        }
    }
    @IBInspectable var horizontalMode: Bool
        {
        get
        {
            return objc_getAssociatedObject(self, &horizontalModeKey) as? Bool ?? false
        }
        set
        {
            objc_setAssociatedObject(self, &horizontalModeKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            updatePoints()
        }
    }
    @IBInspectable var diagonalMode: Bool
        {
        get
        {
            return objc_getAssociatedObject(self, &diagonalModeKey) as? Bool ?? false
        }
        set
        {
            objc_setAssociatedObject(self, &diagonalModeKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            updatePoints()
        }
    }
    
    func updatePoints()
    {
        if horizontalMode
        {
            gradientLayer.startPoint = diagonalMode ? CGPoint(x: 1, y: 0) : CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint   = diagonalMode ? CGPoint(x: 0, y: 1) : CGPoint(x: 1, y: 0.5)
        }
        else
        {
            gradientLayer.startPoint = diagonalMode ? CGPoint(x: 0, y: 0) : CGPoint(x: 0.5, y: 0)
            gradientLayer.endPoint   = diagonalMode ? CGPoint(x: 1, y: 1) : CGPoint(x: 0.5, y: 1)
        }
    }
    
    func updateLocations()
    {
        gradientLayer.locations = [startLocation as NSNumber, endLocation as NSNumber]
    }
    
    func updateColors()
    {
        if isEnable
        {
            let colors = backgroundColors.map { $0.cgColor }
            gradientLayer.colors = colors
        }
        else
        {
            gradientLayer.colors = [disableColor.cgColor, disableColor.cgColor]
        }
    }
    
    func setColors(_ newColors: [UIColor])
    {
        if !newColors.isEmpty
        {
            backgroundColors.removeAll()
            backgroundColors.append(contentsOf: newColors)
            updateColors()
        }
    }
    
    func clear()
    {
        backgroundColors.removeAll()
        disableColor = .clear
        startColor = .clear
        endColor = .clear
        startLocation = 0
        endLocation = 1
        horizontalMode = false
        diagonalMode = false
        
        borderDisableColor = .clear
        borderStartColor = .clear
        borderEndColor = .clear
        borderStartLocation = 0
        borderEndLocation = 1
        borderHorizontalMode = false
        borderDiagonalMode = false
        lineWidth = 0
    }
    
    func updateGradient()
    {
        gradientLayer.frame = bounds.insetBy(dx: lineWidth, dy: lineWidth)
        borderBackground.frame = bounds
        updatePoints()
        updateBorderPoints()
        updateLocations()
        updateBorderLocations()
        updateColors()
        updateBorderColors()
        updateRadius()
    }
}

extension UIView
{
    @IBInspectable var isShowDisableBorder: Bool
        {
        get
        {
            return objc_getAssociatedObject(self, &isShowDisableBorderKey) as? Bool ?? true
        }
        set
        {
            objc_setAssociatedObject(self, &isShowDisableBorderKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            updateBorderColors()
        }
    }
    
    @IBInspectable var borderDisableColor: UIColor
        {
        get
        {
            if UserDefaults.standard.integer(forKey: "app_mode") == 1 // Service
            {
                return UIColor.init(red: 0.404, green: 0.4, blue: 0.475, alpha: 1)
            }
            else
            {
                return UIColor.init(red: 0.898, green: 0.906, blue: 0.918, alpha: 1)
            }
//            return objc_getAssociatedObject(self, &borderDisableColorKey) as? UIColor ?? UIColor.clear
        }
        set
        {
            objc_setAssociatedObject(self, &borderDisableColorKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            updateBorderColors()
        }
    }

    @IBInspectable var borderStartColor: UIColor
        {
        get
        {
            return objc_getAssociatedObject(self, &borderStartColorKey) as? UIColor ?? UIColor.clear
        }
        set
        {
            objc_setAssociatedObject(self, &borderStartColorKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            updateBorderColors()
        }
    }
    
    @IBInspectable var borderEndColor: UIColor
        {
        get
        {
            return objc_getAssociatedObject(self, &borderEndColorKey) as? UIColor ?? UIColor.clear
        }
        set
        {
            objc_setAssociatedObject(self, &borderEndColorKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            updateBorderColors()
        }
    }
    
    @IBInspectable var borderStartLocation: Double
        {
        get
        {
            return objc_getAssociatedObject(self, &borderStartLocationKey) as? Double ?? Double(0)
        }
        set
        {
            objc_setAssociatedObject(self, &borderStartLocationKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            updateBorderLocations()
        }
    }
    
    @IBInspectable var borderEndLocation: Double
        {
        get
        {
            return objc_getAssociatedObject(self, &borderEndLocationKey) as? Double ?? Double(0)
        }
        set
        {
            objc_setAssociatedObject(self, &borderEndLocationKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            updateBorderLocations()
        }
    }
    
    @IBInspectable var borderHorizontalMode: Bool
        {
        get
        {
            return objc_getAssociatedObject(self, &borderHorizontalModeKey) as? Bool ?? false
        }
        set
        {
            objc_setAssociatedObject(self, &borderHorizontalModeKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            updateBorderPoints()
        }
    }
    
    @IBInspectable var borderDiagonalMode: Bool
        {
        get
        {
            return objc_getAssociatedObject(self, &borderDiagonalModeKey) as? Bool ?? false
        }
        set
        {
            objc_setAssociatedObject(self, &borderDiagonalModeKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            updateBorderPoints()
        }
    }
    @IBInspectable var radius: CGFloat
        {
        get
        {
            return objc_getAssociatedObject(self, &radiusKey) as? CGFloat ?? CGFloat(0)
        }
        set
        {
            objc_setAssociatedObject(self, &radiusKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            updateRadius()
        }
    }
    
    @IBInspectable var lineWidth: CGFloat
        {
        get
        {
            return objc_getAssociatedObject(self, &lineWidthKey) as? CGFloat ?? CGFloat(0)
        }
        set
        {
            objc_setAssociatedObject(self, &lineWidthKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            updateRadius()
        }
    }
    private var borderBackground: CAGradientLayer
    {
        get
        {
            var borderBG = objc_getAssociatedObject(self, &borderBackgroundKey) as? CAGradientLayer
            if borderBG == nil
            {
                borderBG = CAGradientLayer()
                borderBG!.frame = bounds
                borderBG!.contentsScale = layer.contentsScale
                layer.addSublayer(borderBG!)
                objc_setAssociatedObject(self, &borderBackgroundKey, borderBG, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            return borderBG!
        }
        set
        {
            objc_setAssociatedObject(self, &borderBackgroundKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func updateBorderPoints()
    {
        if borderHorizontalMode
        {
            borderBackground.startPoint = borderDiagonalMode ? CGPoint(x: 1, y: 0) : CGPoint(x: 0, y: 0.5)
            borderBackground.endPoint = borderDiagonalMode ? CGPoint(x: 0, y: 1) : CGPoint(x: 1, y: 0.5)
        }
        else
        {
            borderBackground.startPoint = borderDiagonalMode ? CGPoint(x: 0, y: 0) : CGPoint(x: 0.5, y: 0)
            borderBackground.endPoint = borderDiagonalMode ? CGPoint(x: 1, y: 1) : CGPoint(x: 0.5, y: 1)
        }
    }
    
    func updateBorderLocations()
    {
        borderBackground.locations = [borderStartLocation as NSNumber, borderEndLocation as NSNumber]
    }
    
    func updateBorderColors()
    {
        if isEnable
        {
            borderBackground.colors = [borderStartColor.cgColor, borderEndColor.cgColor]
        }
        else
        {
            if isShowDisableBorder
            {
                borderBackground.colors = [borderDisableColor.cgColor, borderDisableColor.cgColor]
            }
            else
            {
                borderBackground.colors = [UIColor.clear.cgColor, UIColor.clear.cgColor]
            }
        }
    }
    
    func updateRadius()
    {
        addShapeTo(layer: borderBackground, lineWidth: lineWidth, strokeColor: UIColor.black, fillColor: UIColor.clear)
        addShapeTo(layer: gradientLayer, lineWidth: lineWidth, strokeColor: UIColor.clear, fillColor: UIColor.black)
    }
    
    private func addShapeTo(layer: CALayer, lineWidth: CGFloat, strokeColor: UIColor, fillColor: UIColor)
    {
        let shape = CAShapeLayer()
        shape.path = UIBezierPath(roundedRect: layer.bounds.insetBy(dx: lineWidth, dy: lineWidth), cornerRadius: radius).cgPath
        shape.contentsScale = layer.contentsScale
        shape.strokeColor = strokeColor.cgColor
        shape.fillColor = fillColor.cgColor
        shape.lineWidth = lineWidth
        layer.mask = shape
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
}

extension UIView
{
    func fillHorizontalGradient()
    {
        backgroundColor = .clear
        disableColor = UIColor.clear
        startColor = UIColor.init(red: 1, green: 0.502, blue: 0.631, alpha: 1)
        endColor = UIColor.init(red: 0.678, green: 0.286, blue: 0.875, alpha: 1)
        startLocation = 0
        endLocation = 1
        horizontalMode = true
        diagonalMode = false
        lineWidth = 1
    }
    
    func fillVertivaleBorderGradient()
    {
        borderDisableColor = UIColor.clear
        borderStartColor = UIColor.init(red: 0.678, green: 0.286, blue: 0.875, alpha: 1)
        borderEndColor = UIColor.init(red: 1, green: 0.502, blue: 0.631, alpha: 1)
        borderStartLocation = 0
        borderEndLocation = 1
        borderHorizontalMode = false
        borderDiagonalMode = false
        lineWidth = 1
    }
}
