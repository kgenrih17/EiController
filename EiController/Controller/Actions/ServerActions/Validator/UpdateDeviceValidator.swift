//
//  UpdateDeviceValidator.swift
//  EiController
//
//  Created by Genrih Korenujenko on 07.04.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

class UpdateDeviceValidator: NSObject
{
    let NODES_KEY = "nodes"
    let PUBLISHER_KEY = "publisher"
    let HOST_KEY = "host"
    let PORT_KEY = "port"
    
    @objc var error : String?
    @objc var isValid : Bool
    
    @objc(initWithError: response:) init(error : String?, response : Any?)
    {
        self.isValid = false
        super.init()
        self.error = error
        if self.error == nil
        {
            isValid = isValidFormat(response: response)
        }
    }

    private func isValidFormat(response : Any?) -> Bool
    {
        var result = false
        if response != nil, let dic = response as? Dictionary<String, Any>
        {
            if dic.keys.contains(NODES_KEY), dic.keys.contains(PUBLISHER_KEY)
            {
                result = isValidPublisher(publisher: dic[PUBLISHER_KEY] as! Dictionary<String, Any>)
            }
            else
            {
                error = "incorrect format response"
            }
        }
        else
        {
            error = "Response is empty"
        }
        return result
    }
    
    private func isValidPublisher(publisher : Dictionary<String,Any>) -> Bool
    {
        var result = false
        if publisher.keys.contains(HOST_KEY), publisher.keys.contains(PORT_KEY)
        {
            result = true
        }
        else
        {
            error = "Incorrect publisher format"
        }
        return result
    }
}
