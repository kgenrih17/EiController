//
//  AppStatus.swift
//  EiController
//
//  Created by Genrih Korenujenko on 23.07.2018.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

private let APP_MODE_KEY = "app_mode"

class AppStatus: NSObject
{
    @objc var mode = EAppMode.EXTENDED_MODE
    private static let sharedPreferences = AppStatus.init()
    
    override init()
    {
        if let oldMode = EAppMode(rawValue: UserDefaults.standard.integer(forKey: APP_MODE_KEY))
        {
            mode = oldMode
        }
        super.init()
    }
    
    @objc(currect) static func currect() -> AppStatus
    {
        return sharedPreferences
    }
    
    @objc(isServiceMode) static func isServiceMode() -> Bool
    {
        return currect().mode == EAppMode.SERVICE_MODE
    }
    
    @objc(isExtendedMode) static func isExtendedMode() -> Bool
    {
        return currect().mode == EAppMode.EXTENDED_MODE
    }
    
    @objc(saveMode) static func saveMode()
    {
        UserDefaults.standard.set(currect().mode.rawValue, forKey: APP_MODE_KEY)
    }
    
    @objc(clearMode) static func clearMode()
    {
        UserDefaults.standard.set(0, forKey: APP_MODE_KEY)
    }
}
