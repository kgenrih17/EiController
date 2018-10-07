//
//  ModeConfiguration.swift
//  EiController
//
//  Created by Genrih Korenujenko on 13.07.2018.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

class ModeConfiguration: NSObject
{
    /// Used
    var snList : String!
    var snManual : String!
    var typeLink : String!
    var ip : String!
    var edition : String!
    var model : String!
    var systemID : String!
    var title : String!
    var version : String!
    var status : String!
    var mode : String!
    var pairSN : String?
    var isEnablePort : Bool = false
    var isEnableWatchdog : Bool = false
    var pairState : String = ""
    
    var watchdogFingerprint : String?
    var snWatchdog : String?
    var ipNodeWatchdog : String?
    var titleNodeWatchdog : String?
    var timeout : Int = 0
    var isOnline : Bool
    {
        get
        {
            return (pairSN != nil && !pairSN!.isEmpty)
        }
    }
    
    @objc(empty) class func empty() -> ModeConfiguration
    {
        return ModeConfiguration.init(snList: "", snManual: "", typeLink: "", ip: "", mode: "", edition: "", model: "", systemID: "", title: "", version: "", status: "")
    }
    
    init(snList: String, snManual: String, typeLink: String, ip: String, mode: String, edition: String, model: String, systemID: String, title: String, version: String, status: String)
    {
        self.snList = snList
        self.snManual = snManual
        self.typeLink = typeLink
        self.ip = ip
        self.mode = mode
        self.edition = edition
        self.model = model
        self.systemID = systemID
        self.title = title
        self.version = version
        self.status = status
        super.init()
    }
    
    func sn() -> String
    {
        return snList.isEmpty ? snManual : snList
    }
}
