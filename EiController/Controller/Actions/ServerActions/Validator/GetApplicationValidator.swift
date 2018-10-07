//
//  GetApplicationValidator.swift
//  EiController
//
//  Created by Genrih Korenujenko on 10.04.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

class GetApplicationValidator: NSObject
{
    @objc let FILES_KEY = "files"
    @objc let FILE_STATUS_KEY = "status"
    @objc let FILE_STATUS_READY = "ready"
    @objc let FILE_STATUS_NOT_EXIST = "not_exist"
    @objc let FILE_STATUS_IN_PROGRESS = "progress"
    @objc let FILE_STATUS_ERROR = "error"
    @objc let FILE_STATUS_NOT_MODIFIED = "not_modified"
    
    @objc var error : String?
    @objc var isValid : Bool
    @objc var isPublisherHaveError : Bool
    
    @objc(initWithError: response:) init(error : String?, response : Any?)
    {
        isValid = false
        isPublisherHaveError = false
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
            if dic.keys.contains(FILES_KEY), dic[FILES_KEY] != nil, ((dic[FILES_KEY] as? Array<Any>) != nil)
            {
                result = true
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
    
    @objc(isReadyAppList:) public func isReadyAppList(list : Array<Dictionary<String, Any>>!) -> Bool
    {
        var result = !list.isEmpty
        if result
        {
            for (_, element) in list.enumerated()
            {
                let status : String = element[FILE_STATUS_KEY] as! String
                if status == FILE_STATUS_ERROR
                {
                    isPublisherHaveError = true
                    result = false
                    break
                }
                else if status == FILE_STATUS_READY || status == FILE_STATUS_NOT_MODIFIED
                {
                    continue
                }
                else
                {
                    result = false
                    break
                }
            }
        }
        return result
    }
        
}
