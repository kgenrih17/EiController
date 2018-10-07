//
//  JSONRPCError.swift
//  EiController
//
//  Created by Genrih Korenujenko on 13.06.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

class JSONRPCError: NSObject
{
    var code : Int!
    var message : String!
    
    static func build(_ code: Int!, _ message: String!) -> JSONRPCError
    {
        let result = JSONRPCError()
        result.code = code
        result.message = message
        return result
    }
    
//    override class func description() -> String
//    {
//        return "code=\(code), message=\(message)"
//    }
}
