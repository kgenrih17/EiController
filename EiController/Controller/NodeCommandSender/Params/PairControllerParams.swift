//
//  PairControllerParams.swift
//  EiController
//
//  Created by Genrih Korenujenko on 02.08.2018.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit


struct PairControllerParams
{
    let serial: String
    let force: Bool
}

extension PairControllerParams : INodeParamsBuilder
{
    var buildJson: [String:Any]
    {
        get
        {   return [
            "params" : [
                "serial" : serial,
                "force" : force
            ]
            ]
        }
    }
}
