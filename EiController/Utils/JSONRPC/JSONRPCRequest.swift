//
//  JSONRPCRequest.swift
//  EiController
//
//  Created by Genrih Korenujenko on 05.06.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

class JSONRPCRequest: NSObject
{
    var id : Any?
    var params : [String : Any]?
    var method : String = ""
    var jsonrpc : String = "2.0"
    
    static func build(_ method: String!, _ params: [String : Any]?) -> JSONRPCRequest
    {
        let result = JSONRPCRequest()
        result.method = method
        result.params = params
        return result
    }
}

