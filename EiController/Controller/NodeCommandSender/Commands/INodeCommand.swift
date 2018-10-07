//
//  INodeCommand.swift
//  EiController
//
//  Created by Genrih Korenujenko on 12.06.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

protocol INodeCommand: NSObjectProtocol
{
    var method : String { get }
    var params : [String : Any]? { get set }
    var desc : String { get }
    
    static func build(_ parameters: Any?) -> INodeCommand
    func isCorrectResponse(_ response: JSONRPCResponse!) -> Bool
    func isSuccessfulAnswer(_ response: JSONRPCResponse!) -> Bool
    func prepareResult(_ response: JSONRPCResponse!) -> Any?
}
