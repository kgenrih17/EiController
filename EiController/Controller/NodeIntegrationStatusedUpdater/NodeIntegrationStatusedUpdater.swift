//
//  NodeIntegrationStatusedUpdater.swift
//  EiController
//
//  Created by Henrikh Koreniuzhenko on 04.10.2018.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

class NodeIntegrationStatusedUpdater: INodeIntegrationStatusedUpdater
{
    var commandSender : INodeCommandSender
    var timeInterval : TimeInterval = 20
    var isStarted = false
    var node : Device
    var timer : Timer?
    var completed : ((EConnectionStatusServer, EIntegrationServerType) -> Void)?
    
    init(node: Device)
    {
        self.node = node
        self.commandSender = NodeCommandSender.build(DeviceOperationLogsTable())
    }
    
    func start(changedTo: ((EConnectionStatusServer, EIntegrationServerType) -> Void)?)
    {
        isStarted = true
        completed = changedTo
        send()
    }
    
    func stop()
    {
        timer?.invalidate()
        commandSender.cancel()
        completed = nil
        isStarted = false
    }
}

private extension NodeIntegrationStatusedUpdater
{
    func startResendTimer()
    {
        if isStarted
        {
            timer?.invalidate()
            timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(self.send), userInfo: nil, repeats: false)
        }
    }
    
    @objc func send()
    {
        commandSender.send(commands: getCommands(), node: node, endedCommand: { (command, result) in
            self.parse(result: result, command: command)
        }) { _ in
            self.startResendTimer()
        }
    }
    
    func parse(result: CommandResult, command: ENodeCommand)
    {
        let connectionStatus : EConnectionStatusServer = (result.error == nil) ? .CONNECTED_STATUS : .DISCONNECTED_STATUS
        switch command
        {
        case .GET_MANAGEMENT_SERVER:
            if connectionStatus == .CONNECTED_STATUS
            {
                node.esIntegrInfo = result.params as! DeviceIntegrationInfo
            }
        case .CHECK_CONNECTION_MANAGEMENT_SERVER:
            self.completed?(connectionStatus, .MANAGEMENT)
        case .GET_RM_SERVER:
            if result.error == nil, let params = result.params as? [String:Any]
            {
                node.isUseTunnel = params.bool("tunnel_enabled")
                node.tunnelAddress = params.string("tunnel_address")
            }
        case .CHECK_CONNECTION_RM_SERVER:
            self.completed?(connectionStatus, .REVERSE_MONITORING)
        case .GET_UPDATE_SERVER:
            if result.error == nil, let params = result.params as? [String:Any]
            {
                node.isEnableUpdateServer = params.bool("status")
                node.updateServerAddress = params.string("host")
            }
        case .CHECK_CONNECTION_UPDATE_SERVER:
            self.completed?(connectionStatus, .UPDATE)
        default:
            break
        }
    }
    
    func getCommands() -> [ENodeCommand:Any?]
    {
        var commands = [ENodeCommand:Any?]()
        if node.esIntegrInfo == nil
        {
            commands[.GET_MANAGEMENT_SERVER] = NSNull()
        }
        commands[.CHECK_CONNECTION_MANAGEMENT_SERVER] = getManagementParams()
        if node.tunnelAddress == nil || node.tunnelAddress.isEmpty
        {
            commands[.GET_RM_SERVER] = NSNull()
        }
        commands[.CHECK_CONNECTION_RM_SERVER] = getReverseMonitoringParams()
        if node.updateServerAddress == nil || node.updateServerAddress.isEmpty
        {
            commands[.GET_UPDATE_SERVER] = NSNull()
        }
        commands[.CHECK_CONNECTION_UPDATE_SERVER] = getUpdateParams()
        return commands
    }
    
    func getManagementParams() -> String?
    {
        return ConnectionData.create(withAddress: node.esIntegrInfo?.host ?? "", port: 80)?.host ?? ""
    }
    
    func getReverseMonitoringParams() -> String?
    {
        return ConnectionData.create(withAddress: node.tunnelAddress ?? "", port: 80)?.host ?? ""
    }
    
    func getUpdateParams() -> String?
    {
        return ConnectionData.create(withAddress: node.updateServerAddress ?? "", port: 80)?.host ?? ""
    }
}
