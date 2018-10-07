//
//  SetDisconnectControllerCommand.swift
//  EiController
//
//  Created by Genrih Korenujenko on 02.08.2018.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

class SetDisconnectControllerCommand : NSObject, INodeCommand
{
    var method : String
    {
        return "Integration.RPN.settings.ContextualDeviceService::unpairEiController"
    }
    var params : [String : Any]?
    
    var desc : String { return "Unpair [Ei] Controller" }
    
    static func build(_ parameters: Any?) -> INodeCommand
    {
        return SetDisconnectControllerCommand()
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
