//
//  NSDictionary+Additions.swift
//  EiController
//
//  Created by Genrih Korenujenko on 30.05.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

extension Dictionary
{
    public func containsKeys(_ keys: [String]) -> Bool
    {
        if let dic = self as? [String:Any]
        {
            
            for key in keys
            {
                if !dic.keys.contains(key)
                {
                    return false
                    
                }
            }
            return true
        }
        return false
    }
    
    func bool(_ key: Key) -> Bool
    {
        if let result = self[key] as? Bool { return result }
        else if let result = self[key] as? String
        {
            if result.lowercased() == "true" || result == "1" || result.lowercased() == "yes" || result.lowercased() == "on" { return true }
            else if result.lowercased() == "false" || result == "0" || result.lowercased() == "no" || result.lowercased() == "off" { return false }
            else { return false }
        }
        else if let result = self[key] as? NSNumber { return result.boolValue }
        else if let result = self[key] as? Int { return result == 1 }
        else { return false }
    }
    
    func int(_ key: Key) -> Int
    {
        if let result = self[key] as? Int { return result }
        else if let result = Int(string(key)) { return result }
        else { return 0 }
    }
    
    func float(_ key: Key) -> Float
    {
        if let result = self[key] as? Float { return result }
        else if let result = self[key] as? Double { return Float(result) }
        else if let result = Float(string(key)) { return result }
        else { return 0.0 }
    }
    
    func string(_ key: Key) -> String
    {
        if let result = self[key] as? String { return result }
        else { return "" }
    }
    
    func number(_ key: Key) -> NSNumber
    {
        if let result = self[key] as? NSNumber { return result }
        else { return NSNumber(value: 0) }
    }
    
    func null(_ key: Key) -> NSNull
    {
        if let result = self[key] as? NSNull { return result }
        else { return NSNull() }
    }
    
    func array(_ key: Key) -> [Any]
    {
        if let result = self[key] as? [Any] { return result }
        else { return [] }
    }
    
    func dictionary(_ key: Key) -> [String:Any]
    {
        if let result = self[key] as? [String:Any] { return result }
        else { return [String:Any]() }
    }
}
