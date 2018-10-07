//
//  GetScheduleValidator.swift
//  EiController
//
//  Created by Genrih Korenujenko on 10.04.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

class GetScheduleValidator: NSObject
{
    let FILES_KEY = "files"
    let DATA_KEY = "data"
    
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
            if dic.keys.contains(FILES_KEY), dic.keys.contains(DATA_KEY)
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
    
}
