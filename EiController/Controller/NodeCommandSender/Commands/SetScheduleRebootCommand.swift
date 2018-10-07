//
//  SetShutdownNodeScheduleCommand.swift
//  EiController
/// Type: Reboot Node, Restart Playback, Shutdown Node
//  Created by Genrih Korenujenko on 04.06.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

class SetScheduleRebootCommand : NSObject, INodeCommand
{
    var method : String
    {
        return "Integration.RPN.settings.ProfilerService::setScheduleReboot"
    }
    var params : [String : Any]?
    var desc : String { return "Set Schedule \(type.capitalized)" }
    var type : String = ""

    static func build(_ parameters: Any?) -> INodeCommand
    {
        let result = SetScheduleRebootCommand()
        if parameters != nil, let values = parameters as? [String : Any]
        {
            result.params = ["params" : values]
            result.type = (values["type"] as! String).replacingOccurrences(of: "_", with: " ")
        }
        return result
    }
    
    func isCorrectResponse(_ response: JSONRPCResponse!) -> Bool
    {
        return response.result as? NSNumber != nil
    }
    
    func isSuccessfulAnswer(_ response: JSONRPCResponse!) -> Bool
    {
        return (response.result as! NSNumber).boolValue
    }
    
    func prepareResult(_ response: JSONRPCResponse!) -> Any?
    {
        return response.result
    }
}
