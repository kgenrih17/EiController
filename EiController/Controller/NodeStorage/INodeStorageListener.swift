//
//  INodeStorageListener.swift
//  EiController
//
//  Created by Henrikh Koreniuzhenko on 04.09.2018.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

@objc protocol INodeStorageListener: NSObjectProtocol
{
    func devicesUpdated()
    func devicesNotUpdated()
}
