//
//  IMemoryInfo.swift
//  EiController
//
//  Created by Henrikh Koreniuzhenko on 02.10.2018.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

protocol IMemoryInfo
{
    var totalRAM: Float { get }
    var freeRAM: Float { get }
    var totalFlash: Float { get }
    var availableFlash: Float { get }
    var reservedFlash: Float { get }
}
