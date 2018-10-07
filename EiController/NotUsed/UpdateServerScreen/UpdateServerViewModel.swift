//
//  UpdateServerViewModel.swift
//  EiController
//
//  Created by Genrih Korenujenko on 05.05.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

class UpdateServerViewModel: NSObject
{
    var isEnable : Bool = false
    var address : String?
    var message : String?
    var messageColor : UIColor?
    
    init(isEnable : Bool, address : String?)
    {
        self.isEnable = isEnable
        self.address = address
        super.init()
    }
}

