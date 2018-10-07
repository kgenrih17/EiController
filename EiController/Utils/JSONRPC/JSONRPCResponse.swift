//
//  JSONRPCResponse.swift
//  EiController
//
//  Created by Genrih Korenujenko on 05.06.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

class JSONRPCResponse: NSObject
{
    var id : Any?
    var result : Any?
    var error : JSONRPCError?
    
    static func build(error: String) -> JSONRPCResponse
    {
        let result = JSONRPCResponse()
        result.error = JSONRPCError.build(0, error)
        return result
    }
}
