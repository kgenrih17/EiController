//
//  ISysInfo.swift
//  EiController
//
//  Created by Henrikh Koreniuzhenko on 02.10.2018.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

protocol ISysInfo: NSObjectProtocol
{
    var cpuUsage: Float { get }
    var uptime: Int { get }
    var currentTimestamp: Int { get }
    
    var udid: String { get }
    var platform: String { get }
    var systemOS: String { get }
    var appVersion: String { get }
    var shortVersion: String { get }
    var deviceModel: String { get }

    var timeZone: String { get }
    var macAddress: String { get }
    var ip: String { get }
//    var  connectionType: EConnectionType
//    var  memoryInfo: MemoryInfo
    
    func getFormattedDate(format: String) -> String
}
