//
//  INodeApiService.swift
//  EiController
//
//  Created by Genrih Korenujenko on 12.06.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit
import Moya
import RxSwift

protocol INodeApiService: NSObjectProtocol
{
    var baseURL : String! {get set}
    var fingerprint : String! {get set}
    
    static func build(_ connectionData: ConnectionData, _ fingerprint: String) -> INodeApiService
    func cancel()
    func request(_ request: JSONRPCRequest) -> Single<JSONRPCResponse>
}
