//
//  SetPairControllerCommand.swift
//  EiController
//
//  Created by Genrih Korenujenko on 02.08.2018.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

class SetPairControllerCommand : NSObject, INodeCommand
{
    var method : String
    {
        return "Integration.RPN.settings.ContextualDeviceService::pairEiController"
    }
    var params : [String : Any]?
    
    var desc : String { return "Pair [Ei] Controller" }
    
    static func build(_ parameters: Any?) -> INodeCommand
    {
        let result = SetPairControllerCommand()
        if let item = parameters as? PairControllerParams
        {
            result.params = item.buildJson
        }
        return result
    }
    
    func isCorrectResponse(_ response: JSONRPCResponse!) -> Bool
    {
        return response.result as? [String:Any] != nil
    }
    
    func isSuccessfulAnswer(_ response: JSONRPCResponse!) -> Bool
    {
        let result = response.result as! [String:Any]
        return (result.keys.contains("status") && !result.string("status").isEmpty)
    }
    
    func prepareResult(_ response: JSONRPCResponse!) -> Any?
    {
        let result = response.result as! [String:Any]
        return result.string("status")
    }
}
