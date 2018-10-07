//
//  Switch+Gradient.swift
//  EiController
//
//  Created by Henrikh Koreniuzhenko on 23.09.2018.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

@objc protocol ISwitchGradient: NSObjectProtocol
{
    func fillDefaultGradients()
    func refreshState()
}

extension Switch: ISwitchGradient
{
    func fillDefaultGradients()
    {
        backgroundColor = .clear
        thumbView.backgroundColor = .clear
        thumbView.setColors([UIColor.white])
        fillHorizontalGradient()
        radius = frame.height / CGFloat(2)
        thumbView.radius = thumbView.frame.height / CGFloat(2)
    }
    
    func refreshState()
    {
        clear()
        thumbView.clear()
        if isEnable
        {
            thumbView.setColors([UIColor.white, UIColor.white])
            if isOn
            {
                fillHorizontalGradient()
                leftLabel.textColor = .white
            }
            else
            {
                rightLabel.textColor = UIColor.init(red: 0.608, green: 0.627, blue: 0.682, alpha: 1)
                fillVertivaleBorderGradient()
                let color : UIColor!
                if AppStatus.isExtendedMode()
                {
                    color = UIColor.init(red: 0.933, green: 0.933, blue: 0.933, alpha: 1)
                }
                else
                {
                    color = UIColor.init(red: 0.31, green: 0.306, blue: 0.38, alpha: 1)
                }
                setColors([color, color])
            }
        }
        else
        {
            fillVertivaleBorderGradient()
            let color : UIColor!
            if AppStatus.isExtendedMode()
            {
                color = UIColor.init(red: 0.898, green: 0.906, blue: 0.918, alpha: 1)
            }
            else
            {
                color = UIColor.init(red: 0.404, green: 0.4, blue: 0.475, alpha: 1)
            }
            borderDisableColor = color
            leftLabel.textColor = color
            rightLabel.textColor = color
            thumbView.fillVertivaleBorderGradient()
            thumbView.borderStartColor = color
            thumbView.borderEndColor = color
        }
    }
}
