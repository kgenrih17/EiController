//
//  ControlSwitch.swift
//  EiController
//
//  Created by Henrikh Koreniuzhenko on 26.09.2018.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

class ControlSwitch: Switch
{
    override func layoutThumb()
    {
        let width_2 = bounds.width / CGFloat(2)
        let thumbIndent = CGFloat(3)
        if isOn
        {
            thumbView.frame = CGRect.init(x: bounds.width - width_2, y: 0, width: width_2, height: bounds.height).insetBy(dx: thumbIndent, dy: thumbIndent)
        }
        else
        {
            thumbView.frame = CGRect.init(x: 0, y: 0, width: width_2, height: bounds.height).insetBy(dx: thumbIndent, dy: thumbIndent)
        }
        leftLabel.frame = CGRect.init(x: 0, y: 0, width: width_2, height: bounds.height).insetBy(dx: thumbIndent, dy: thumbIndent)
        rightLabel.frame = CGRect.init(x: bounds.width - width_2, y: 0, width: width_2, height: bounds.height).insetBy(dx: thumbIndent, dy: thumbIndent)
    }
    
    override func refresh()
    {
        if isEnable
        {
            if isOn
            {
                rightLabel.text = titleOn;
                rightLabel.textColor = titleOnColor;
                leftLabel.text = titleOff;
                leftLabel.textColor = titleOffColor;
            }
            else
            {
                rightLabel.text = titleOn;
                rightLabel.textColor = titleOffColor;
                leftLabel.text = titleOff;
                leftLabel.textColor = titleOnColor;
            }
        }
    }
    
    override func fillDefaultGradients()
    {
        backgroundColor = .clear
        thumbView.backgroundColor = .clear
        thumbView.fillHorizontalGradient()
        radius = frame.height / CGFloat(2)
        thumbView.radius = thumbView.frame.height / CGFloat(2)
    }
    
    override func refreshState()
    {
        clear()
        thumbView.clear()
        if isEnable, !horizontalMode
        {
            let color : UIColor!
            if AppStatus.isExtendedMode()
            {
                color = UIColor.init(red: 0.933, green: 0.933, blue: 0.933, alpha: 1)
            }
            else
            {
                color = UIColor.init(red: 0.31, green: 0.306, blue: 0.38, alpha: 1)
            }
            fillVertivaleBorderGradient()
            fillHorizontalGradient()
            setColors([color, color])
            thumbView.fillHorizontalGradient()
        }
        else if !isEnable
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
