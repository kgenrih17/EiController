//
//  GetUpdateServerCommand.swift
//  EiController
//
//  Created by Genrih Korenujenko on 10.05.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

class GetUpdateServerCommand : NSObject, INodeCommand
{
    var method : String
    {
        return "Integration.RPN.settings.ManagementServer::getUpdateServer"
    }
    var params : [String : Any]?
    
    var desc : String { return "Get Update Server" }
    
    static func build(_ parameters: Any?) -> INodeCommand
    {
        return GetUpdateServerCommand()
    }
    
    func isCorrectResponse(_ response: JSONRPCResponse!) -> Bool
    {
        var isCorrect = false
        if let result = response.result as? [String:Any]
        {
            isCorrect = result.containsKeys(["status"])
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
