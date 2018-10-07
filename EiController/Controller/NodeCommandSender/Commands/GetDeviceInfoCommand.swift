//
//  GetDeviceInfoCommand.h
//  EiController
//
//  Created by admin on 2/17/16.
//  Copyright © 2016 RadicalComputing. All rights reserved.
//

import UIKit

class GetDeviceInfoCommand : NSObject, INodeCommand
{
    var method : String
    {
        return "Integration.RPN.settings.ProfilerService::getNodeDetails"
    }
    var params : [String : Any]?
    
    var desc : String { return "Get Node Info" }
    
    static func build(_ parameters: Any?) -> INodeCommand
    {
        return GetDeviceInfoCommand()
    }
    
    func isCorrectResponse(_ response: JSONRPCResponse!) -> Bool
    {
        var isCorrect = false
        if let result = response.result as? [String : Any], result.containsKeys(["hardware", "summary"])
        {
            if let hardware = result["hardware"] as? [String : Any], let summary = result["summary"] as? [String : Any]
            {
                let summaryValidKeys = ["model", "edition", "title", "version", "serial_number", "system_id", "ip", "system_time", "uptime", "timezone", "log_period", "protocol", "info", "company", "location", "schedule_reboot"];
                let hardwareValidKeys = ["mac_address", "cpu", "gpu_temperature", "ram", "hdd"];
                if (summary.containsKeys(summaryValidKeys) && hardware.containsKeys(hardwareValidKeys))
                {
                    var isValidSummary = false
                    if let info = summary["info"] as? [String:Any], let scheduleReboot = summary["schedule_reboot"] as? [String:Any], (summary["company"] as? [String:Any] != nil), (summary["location"] as? [String:Any] != nil)
                    {
                        let infoValidKey = "channels"
                        let scheduleRebootValidKeys = ["reboot_scheduler", "reboot_playback", "shutdown_appliance"]
                        if info.containsKeys([infoValidKey]), scheduleReboot.containsKeys(scheduleRebootValidKeys), ((info[infoValidKey] as? [String:Any]) != nil)
                        {
                            for key in scheduleRebootValidKeys
                            {
                                if scheduleReboot[key] as? [String:Any] != nil
                                {
                                    isValidSummary = true
                                }
                                else
                                {
                                    isValidSummary = false
                                    break;
                                }
                            }
                        }
                    }
                    if isValidSummary, let cpu = hardware["cpu"] as? [String:Any], (hardware["ram"] as? [String:Any] != nil), (hardware["hdd"] as? [String:Any] != nil)
                    {
                        let hardwareValidKeys = ["temperature", "load"]
                        isCorrect = cpu.containsKeys(hardwareValidKeys)
                    }
                    else
                    {
                        isCorrect = false
                    }
                }
            }
        }
        return isCorrect
    }
    
    func isSuccessfulAnswer(_ response: JSONRPCResponse!) -> Bool
    {
        return true
    }
    
    func prepareResult(_ response: JSONRPCResponse!) -> Any?
    {
        return response.result
    }
}
