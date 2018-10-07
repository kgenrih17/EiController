//
//  SetDeviceNameCommand.h
//  EiController
//
//  Created by admin on 8/17/16.
//  Copyright © 2016 RadicalComputing. All rights reserved.
//

import UIKit

class SetDeviceNameCommand : NSObject, INodeCommand
{
    var method : String
    {
        return "Integration.RPN.settings.ProfilerService::setNodeTitle"
    }
    var params : [String : Any]?
    
    var desc : String { return "Set Node Name" }
    
    static func build(_ parameters: Any?) -> INodeCommand
    {
        let result = SetDeviceNameCommand()
        if parameters != nil, let title = parameters as? String
        {
            result.params = ["title" : title]
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
        return NSNumber.init(value: true)
    }
}
