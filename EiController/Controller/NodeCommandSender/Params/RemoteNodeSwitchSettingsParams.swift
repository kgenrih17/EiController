//
//  RemoteNodeSwitchSettingsParams.swift
//  EiController
//
//  Created by Genrih Korenujenko on 03.08.2018.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

struct RemoteNodeSwitchSettingsParams
{
    var serial : String
    let enable : Int
    let watchdogNodeSN: String
    let watchdogTimeout: Int
}

extension RemoteNodeSwitchSettingsParams : INodeParamsBuilder
{
    var buildJson: [String:Any]
    {
        get
        {   return [
                "params" : [
                    "serial" : serial,
                    "eiswitch" : [
                        "enabled" : enable,
                        "watchdog_node_serial" : watchdogNodeSN,
                        "watchdog_timeout" : watchdogTimeout
                    ]
                ]
            ]
        }
    }
}
