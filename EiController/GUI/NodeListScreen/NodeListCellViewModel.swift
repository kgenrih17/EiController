//
//  NodeScreenCellViewModel.swift
//  EiController
//
//  Created by Henrikh Koreniuzhenko on 31.08.2018.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

private let IOS_ICON_NAME = "icon_model_ios_big.png"
private let ANDROID_ICON_NAME = "icon_model_android_big.png"

class NodeListCellViewModel: NSObject
{
    private var iconName : String?
    var fingerprint = ""
    var title = ""
    var systemId = ""
    var serialNumber = ""
    var productId = ""
    var version = ""
    var edition = ""
    var model = ""
    var companyUnique = ""
    var timezone = ""
    var syncMessage = ""
    var syncProgress: Int = 0
    var syncIconName = ""
    var isSyncError = false
    
    var isExtenderMode = true
    var isSelected = false
    var isEnableOperations = false
    var isShowSyncMessage = false
    var isReadyToBeUpdated = false
    var isEnableCommands = false
    var isUserInteractionEnabled = false
    var isShowedActions = false
    var status = EDeviceStatus.LOCAL_STATUS
    var swipeCommands: [EDeviceCommanTag] = []
    
    /// EDeviceCommanTag
    func getUpdateIcon() -> UIImage?
    {
        return UIImage(named: "device_cell_sync_icon")
    }
    
    func getIcon() -> UIImage
    {
        return UIImage.nodeIconBy(model: model)
    }
    
    func findModel(_ models: [String], _ imageName: String) -> String?
    {
        var fileName: String? = nil
        for name in models
        {
            if self.model.contains(name)
            {
                fileName = imageName
            }
        }
        return fileName
    }

    func isEqual(_ object: Any) -> Bool
    {
        if let item = object as? NodeListCellViewModel
        {
            if item.fingerprint != self.fingerprint
            {
                return false
            }
            return true
        }
        else
        {
            return false
        }
    }
    
    func getSyncColor() -> UIColor
    {
        if isSyncError
        {
            return UIColor.init(red: 0.867, green: 0, blue: 0, alpha: 1)
        }
        else
        {
            return UIColor.init(red: 0.608, green: 0.631, blue: 0.678, alpha: 1)
        }
    }
    
    func getSyncIcon() -> UIImage?
    {
        return UIImage(named: syncIconName)
    }
    
    func getBackgroundColor() -> UIColor
    {
        if isExtenderMode
        {
            return UIColor.white
        }
        else
        {
            return UIColor.init(red: 0.329, green: 0.318, blue: 0.404, alpha: 1)
        }
    }
    
    func getTitleColor() -> UIColor
    {
        if isExtenderMode
        {
            return UIColor.init(red: 0.212, green: 0.22, blue: 0.235, alpha: 1)
        }
        else
        {
            return UIColor.white
        }
    }
    
    func getVersionBackgroundColor() -> UIColor
    {
        if isExtenderMode
        {
            return UIColor.init(red: 0.561, green: 0.553, blue: 0.6, alpha: 1)
        }
        else
        {
            if isSelected
            {
                return UIColor.init(red: 0.275, green: 0.263, blue: 0.345, alpha: 0.5)
            }
            else
            {
                return UIColor.init(red: 0.278, green: 0.267, blue: 0.353, alpha: 1)
            }
        }
    }
    
    func getVersionColor() -> UIColor
    {
        if isExtenderMode
        {
            return UIColor.white
        }
        else
        {
            return UIColor.hex("9ca1ad")
        }
    }
}
