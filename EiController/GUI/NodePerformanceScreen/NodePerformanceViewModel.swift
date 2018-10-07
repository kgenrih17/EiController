//
//  NodePerformanceViewModel.swift
//  EiController
//
//  Created by Henrikh Koreniuzhenko on 04.09.2018.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

struct NodePerformanceViewModel
{
    var isExtenderMode = true

    var fingerprint : String = ""
    
    var ramTotal = ""
    var ramFree = ""
    var ramProgress = CGFloat(0)

    var storageTotal = ""
    var storageFree = ""
    var storageProgress = CGFloat(0)

    var models = [ProgressViewModel]()
    
    func getBackgroundColor() -> UIColor
    {
        if isExtenderMode
        {
            return UIColor.init(red: 0.957, green: 0.957, blue: 0.957, alpha: 1)
        }
        else
        {
            return UIColor.init(red: 0.137, green: 0.133, blue: 0.165, alpha: 1)
        }
    }
    
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
    
    func getTitleColor() -> UIColor
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
}
