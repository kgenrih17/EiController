//
//  ResetCommand.swift
//  EiController
//
//  Created by Henrikh Koreniuzhenko on 18.09.2018.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

class ResetCommand : NSObject, INodeCommand
{
    var method : String
    {
        return ""
    }
    var params : [String : Any]?
    var desc : String { return "Reset Node" }
    
    static func build(_ parameters: Any?) -> INodeCommand
    {
        return ResetCommand()
    }
    
    func isCorrectResponse(_ response: JSONRPCResponse!) -> Bool
    {
//        return response.result as? NSNumber != nil
        return true
    }
    
    func isSuccessfulAnswer(_ response: JSONRPCResponse!) -> Bool
    {
//        return (response.result as! NSNumber).boolValue
        return true
    }
    
    func prepareResult(_ response: JSONRPCResponse!) -> Any?
    {
//        return response.result
        return nil
    }
}
