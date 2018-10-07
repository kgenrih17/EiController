//
//  String+SwiftAdditions.swift
//  EiController
//
//  Created by Henrikh Koreniuzhenko on 29.08.2018.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

extension String
{
    static func from(_ date: Date, _ dateFormate: String, _ local: String) -> String
    {
        return NSString.fromDate(date, dateFormate: dateFormate, forLocal: local)
    }
    
    static func valueOrNA(_ string: String?) -> String
    {
        if string != nil
        {
            return NSString.valueOrNA(string!)
        }
        else
        {
            return "N/A"
        }
    }
    
    func versionToInt() -> [Int]
    {
        return components(separatedBy: ".").map { Int.init($0) ?? 0 }
    }
}
