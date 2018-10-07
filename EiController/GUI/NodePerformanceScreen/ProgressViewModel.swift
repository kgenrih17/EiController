//
//  ProgressViewModel.swift
//  EiController
//
//  Created by Genrih Korenujenko on 10.05.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

class ProgressViewModel: NSObject
{
    var isExtenderMode = true
    var title = ""
    var temperatureTitle = ""
    var temperatureProgress: CGFloat?
    var temperatureColors = [UIColor]()
    var loadTitle = ""
    var loadProgress: CGFloat?
    var loadColors = [UIColor]()
    
    func getContainerColor() -> UIColor
    {
        if isExtenderMode
        {
            return UIColor.white
        }
        else
        {
            return UIColor.init(red: 0.329, green: 0.318, blue: 0.404, alpha: 1)
        }
    }
    
    func getProgressTitleColor() -> UIColor
    {
        if isExtenderMode
        {
            return UIColor.init(red: 0.212, green: 0.22, blue: 0.235, alpha: 1)
        }
        else
        {
            return UIColor.white
        }
    }
    
    func getTrackProgressColor() -> UIColor
    {
        if isExtenderMode
        {
            return UIColor.init(red: 0.922, green: 0.922, blue: 0.922, alpha: 1)
        }
        else
        {
            return UIColor.init(red: 0.302, green: 0.29, blue: 0.369, alpha: 1)
        }
    }
    
    func getTrackProgressBorderColor() -> UIColor
    {
        if isExtenderMode
        {
            return UIColor.init(red: 0.969, green: 0.969, blue: 0.969, alpha: 1)
        }
        else
        {
            return UIColor.init(red: 0.318, green: 0.306, blue: 0.392, alpha: 1)
        }
    }
    
    func fillColors()
    {
        temperatureColors = prepareProgressColors(temperatureProgress)
        loadColors = prepareProgressColors(loadProgress)
    }
    
    private func prepareProgressColors(_ progress: CGFloat?) -> [UIColor]
    {
        var colors = [UIColor]()
        if let lProgress = progress
        {
            if lProgress > 70
            {
                colors.append(UIColor.init(red: 0.98, green: 1, blue: 0, alpha: 1))
                colors.append(UIColor.init(red: 1, green: 0, blue: 0, alpha: 1))
            }
            if lProgress > 25
            {
                colors.append(UIColor.init(red: 0, green: 1, blue: 0.0157, alpha: 1))
                colors.append(UIColor.init(red: 0.98, green: 1, blue: 0, alpha: 1))
            }
            else
            {
                colors.append(UIColor.init(red: 0, green: 1, blue: 0.0157, alpha: 1))
                colors.append(UIColor.init(red: 0, green: 1, blue: 0.0157, alpha: 1))
            }
        }
        else
        {
            colors.append(UIColor.clear)
            colors.append(UIColor.clear)
        }
        return colors
    }
}
