//
//  NodeRebootShutdownViewModel.swift
//  EiController
//
//  Created by Henrikh Koreniuzhenko on 20.09.2018.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

class NodeRebootShutdownViewModel: NSObject
{
    var isExtender = true
    var isRestartOn = false
    var restartDate = Date()
    var restartTitle = ""
    var isPlaybackOn = false
    var playbackDate = Date()
    var playbackTitle = ""
    var isShutdownOn = false
    var shutdownDate = Date()
    var shutdownTitle = ""
    
    func getBackgroundColor() -> UIColor
    {
        if isExtender
        {
            return UIColor.init(red: 0.922, green: 0.922, blue: 0.922, alpha: 1)
        }
        else
        {
            return UIColor.init(red: 0.129, green: 0.125, blue: 0.157, alpha: 1)
        }
    }
    
    func getContainerColor() -> UIColor
    {
        if isExtender
        {
            return UIColor.white
        }
        else
        {
            return UIColor.init(red: 0.329, green: 0.318, blue: 0.404, alpha: 1)
        }
    }
}
