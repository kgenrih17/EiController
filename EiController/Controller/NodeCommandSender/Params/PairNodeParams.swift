//
//  PairNodeParams.swift
//  EiController
//
//  Created by Genrih Korenujenko on 05.08.2018.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

struct PairNodeParams
{
    let serialManual: String
    let serialList: String
    let typeLink: String
    let force: Bool
}

extension PairNodeParams : INodeParamsBuilder
{
    var buildJson: [String:Any]
    {
        get
        {
            return [
                "params" : [
                    "serial_manual" : serialManual,
                    "serial_list": serialList,
                    "type_link": typeLink,
                    "force": force
                ]
            ]
        }
    }
}
