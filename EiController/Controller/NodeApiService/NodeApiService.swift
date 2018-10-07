//
//  NodeApiService.swift
//  EiController
//
//  Created by Genrih Korenujenko on 12.06.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

import Moya
import RxSwift
import Result

class NodeApiService: NSObject, INodeApiService
{
    var baseURL : String!
    var fingerprint : String!
    
    private let provider = MoyaProvider<NodeTargetType>()
    
    required init(_ connectionData: ConnectionData, _ fingerprint: String)
    {
        super.init()
        self.baseURL = connectionData.urlString
        self.fingerprint = fingerprint
    }
    
    static func build(_ connectionData: ConnectionData, _ fingerprint: String) -> INodeApiService
    {
        return self.init(connectionData, fingerprint)
    }
    
    func cancel()
    {
        (provider as? Cancellable)?.cancel()
    }
    
    func request(_ request: JSONRPCRequest) -> Single<JSONRPCResponse>
    {
        let target = NodeTargetType(request.params, request.method, baseURL)
        target.params["fingerprint"] = fingerprint
        if request.id != nil
        {
            target.id = request.id!
        }
        return provider.rx.request(target).mapJSONRPC()
    }
}

class NodeTargetType: NSObject, TargetType
{
    var url : String!
    var params : [String : Any] = [:]
    let rpcMethod : String!
    var id : Any = NSNull()
    
    init(_ params: [String : Any]?, _ method: String, _ url: String)
    {
        self.rpcMethod = method
        self.url = url
        if params != nil
        {
            self.params.merge(params!, uniquingKeysWith: { (first, _) in first })
        }
    }
    
    var baseURL: URL { return URL.init(string: url)! }
    
    var path: String { return "/das-json.php" }
    
    var method: Moya.Method { return .post }
    
    var sampleData: Data { return Data() }
    
    var task: Task
    {
        do
        {
            let data = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            return .requestData(data)
        }
        catch
        {
            return .requestPlain
        }
    }
    
    var headers: [String : String]? { return nil }
    
    private var parameters: [String : Any]
    {
        return ["method" : rpcMethod,
                "jsonrpc" : "2.0",
                "id" : id,
                "params" : params]
    }
}

extension PrimitiveSequence where TraitType == SingleTrait, ElementType == Response
{
    func mapJSONRPC(failsOnEmptyData: Bool = true) -> Single<JSONRPCResponse>
    {
        return flatMap { response -> Single<JSONRPCResponse> in
            do
            {
                let json = try JSONSerialization.jsonObject(with: response.data, options: .mutableContainers)
                return Single.just(JSONRPCResponse.build(json))
            }
            catch
            {
                if response.data.count < 1 && !failsOnEmptyData
                {
                    return Single.just(JSONRPCResponse.build(nil))
                }
                throw MoyaError.objectMapping(error, response)
            }
        }
    }
}

extension ObservableType where E == Response
{
    func mapJSONRPC(failsOnEmptyData: Bool = true) -> Observable<JSONRPCResponse>
    {
        return flatMap { response -> Observable<JSONRPCResponse> in
            do
            {
                let json = try JSONSerialization.jsonObject(with: response.data, options: .mutableContainers)
                return Observable.just(JSONRPCResponse.build(json))
            }
            catch
            {
                if response.data.count < 1 && !failsOnEmptyData
                {
                    return Observable.just(JSONRPCResponse.build(nil))
                }
                throw MoyaError.objectMapping(error, response)
            }
        }
    }
}

private extension JSONRPCResponse
{
    class func build(_ response: Any?) -> JSONRPCResponse
    {
        let result = JSONRPCResponse.init()
        if result.isJsonRpc(response)
        {
            result.parse(response as! [String : Any])
        }
        else
        {
            result.generateError(response)
        }
        return result
    }
    
    private func isJsonRpc(_ response: Any?) -> Bool
    {
        var result = false
        if response != nil, let jsonRpc = response as? [String : Any], jsonRpc.keys.contains("jsonrpc")
        {
            result = true
        }
        return result
    }
    
    private func parse(_ jsonRpc: [String : Any]!)
    {
        result = jsonRpc["result"]
        id = jsonRpc["id"]
        if jsonRpc.containsKeys(["error"]), let errorDic = jsonRpc["error"] as? [String : Any]
        {
            error = JSONRPCError.build((errorDic["code"] as! NSNumber).intValue, errorDic["message"] as! String)
        }
    }
    
    private func generateError(_ response: Any?)
    {
        if response == nil { error = JSONRPCError.build(-32600, "Data is nil") }
        else { error = JSONRPCError.build(-32700, "Incorrect JSON RPC format") }
    }
}
