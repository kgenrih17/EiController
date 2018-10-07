//
//  SetPairNodeCommand.swift
//  EiController
//
//  Created by Genrih Korenujenko on 19.07.2018.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

class SetPairNodeCommand : NSObject, INodeCommand
{
    var method : String
    {
        return "Integration.RPN.settings.ContextualDeviceService::pairEiNode"
    }
    var params : [String : Any]?
    
    var desc : String { return "Pair [Ei] Node" }
    
    static func build(_ parameters: Any?) -> INodeCommand
    {
        let result = SetPairNodeCommand()
        if parameters != nil, let item = parameters as? PairNodeParams
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
