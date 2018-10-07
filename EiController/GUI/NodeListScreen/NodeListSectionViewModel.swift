//
//  NodeListSectionViewModel.swift
//  EiController
//
//  Created by Henrikh Koreniuzhenko on 31.08.2018.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

class NodeListSectionViewModel: NSObject
{
    var text: String?
    var status: EDeviceStatus?
    
    class func build(_ status: EDeviceStatus, text: String?) -> NodeListSectionViewModel
    {
        let result = NodeListSectionViewModel()
        result.status = status
        result.text = text
        return result
    }
}
