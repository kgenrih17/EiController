//
//  WatchdogViewModel.swift
//  EiController
//
//  Created by Genrih Korenujenko on 14.07.2018.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

struct WatchdogViewModel
{
    var isShowSelectGridMessage : Bool
    var message : String?
    var isEnablePort : Bool
    var isEnableWatchdog : Bool
    var timeout : Int
    var grid : EiGridNodeViewModel?
    var serial : String
}
