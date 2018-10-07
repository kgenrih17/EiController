//
//  Date+Additions.swift
//  EiController
//
//  Created by Henrikh Koreniuzhenko on 29.08.2018.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

extension Date
{
    static func today(_ hour: Int, _ min: Int) -> Date
    {
        return NSDate.today(hour, min: min)
    }
}
