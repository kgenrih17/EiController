//
//  EiGridNodeViewModel.swift
//  EiController
//
//  Created by Genrih Korenujenko on 15.05.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

class EiGridNodeViewModel: NSObject
{
    var isExtender = true
    
    var fingerprint : String = ""
    var title : String = ""
    var ip : String = ""
    var snList : String = ""
    var snManual : String = ""
    var typeLink : String = ""
    var model : String = ""
    var osVersion : String = ""
    var status : String
    {
        get
        {
            if isOnline
            {
                return "Online"
            }
            else
            {
                return "Offline"
            }
        }
    }
    var isOnline : Bool = false
    var isSelected : Bool = false
    var isPaired : Bool = false
    var image : UIImage
    {
        return UIImage.nodeIconBy(model: model)
    }
    var textColor : UIColor
    {
        get
        {
            if isExtender
            {
                return UIColor.init(red: 0.212, green: 0.22, blue: 0.235, alpha: 1)
            }
            else
            {
                return UIColor.white
            }
        }
    }
    
    var statusImage : UIImage?
    {
        get
        {
            if isOnline
            {
                return UIImage.init(named: "mode_icon_status_active.png")
            }
            else
            {
                return UIImage.init(named: "mode_icon_status_inactive.png")
            }
        }
    }
    override init()
    {
        super.init()
    }

    convenience init(fingerprint : String?, title : String?, ip : String?, snList : String?, snManual : String?, typeLink : String, model : String?, osVersion : String?, isOnline : Bool)
    {
        self.init()
        self.fingerprint = (fingerprint == nil) ? "" : fingerprint!
        self.title = (title == nil) ? "" : title!
        self.ip = (ip == nil) ? "" : ip!
        self.snList = (snList == nil) ? "" : snList!
        self.snManual = (snManual == nil) ? "" : snManual!
        self.typeLink = typeLink
        self.model = (model == nil) ? "" : model!
        self.osVersion = (osVersion == nil) ? "" : osVersion!
        self.isOnline = isOnline
    }
    
    func sn() -> String
    {
        return snList.isEmpty ? snManual : snList
    }
    
    func getContainerColor() -> UIColor
    {
        if isExtender
        {
            return UIColor.white
        }
        else
        {
            return UIColor.init(red: 0.329, green: 0.318, blue: 0.404, alpha: 1)
        }
    }
    
    func getBackgroundColor() -> UIColor
    {
        if isExtender
        {
            return UIColor.init(red: 0.91, green: 0.906, blue: 0.91, alpha: 1)
        }
        else
        {
            return UIColor.init(red: 0.129, green: 0.125, blue: 0.157, alpha: 1)
        }
    }
    
    func getNodeContainerColor() -> UIColor
    {
        if isExtender
        {
            return UIColor.white
        }
        else
        {
            return UIColor.hex("545167")
        }
    }
    
    func getNameColor() -> UIColor
    {
        if isExtender
        {
            return UIColor.init(red: 0.212, green: 0.204, blue: 0.267, alpha: 1)
        }
        else
        {
            return UIColor.white
        }
    }
    
    func getVersionBackgroundColor() -> UIColor
    {
        if isExtender
        {
            return UIColor.init(red: 0.561, green: 0.553, blue: 0.6, alpha: 1)
        }
        else
        {
            return UIColor.init(red: 0.231, green: 0.22, blue: 0.298, alpha: 1)
        }
    }
    
    func getVersionTextColor() -> UIColor
    {
        if isExtender
        {
            return UIColor.white
        }
        else
        {
            return UIColor.init(red: 0.608, green: 0.631, blue: 0.678, alpha: 1)
        }
    }
}
