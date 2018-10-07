//
//  RebootAndShutdownCommand.swift
//  EiController
//
//  Created by Genrih Korenujenko on 04.05.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

class RebootAndShutdownCommand : NSObject, INodeCommand
{
    var method : String
    {
        return "Integration.RPN.settings.SystemService::setReboot"
    }
    var params : [String : Any]?
    var desc : String { return type.capitalized }
    var type : String = ""
    
    static func build(_ parameters: Any?) -> INodeCommand
    {
        let result = RebootAndShutdownCommand()
        if let values = parameters as? [String : Any]
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
