//
//  INodeCommandSender.swift
//  EiController
//
//  Created by Genrih Korenujenko on 12.06.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

enum ENodeCommand: Int
{
    case GET_INFO
    case GET_MANAGEMENT_SERVER
    case GET_MODE_CONFIGURATION
    case GET_NET_SETTINGS
    case GET_RM_SERVER
    case GET_UPDATE_SERVER
    case CHECK_CONNECTION_MANAGEMENT_SERVER
    case CHECK_CONNECTION_RM_SERVER
    case CHECK_CONNECTION_UPDATE_SERVER
    case REBOOT_AND_SHUTDOWN
    case RESET
    case UPDATE
    case FILE_SYSTEM_CHECK
    case STORAGE_CLEANUP
    case SET_NAME
    case SET_MANAGEMENT_SERVER
    case SET_SCHEDULE_REBOOT_AND_SHUTDOWN
    case SET_RM_SERVER
    case SET_UPDATE_SERVER
    case SET_NET_SETTINGS
    case SET_PAIR_CONTROLLER
    case SET_DISCONNECT_CONTROLLER
    case SET_PAIR_NODE
    case SET_DISCONNECT_NODE
    case SET_REMOTE_NODE_SWITCH_SETTINGS
}

protocol INodeCommandSender: NSObjectProtocol
{
    static func build(_ storage: IDeviceOperationLogStorage) -> INodeCommandSender
    func send(command nodeCommand: ENodeCommand, node: Device, parameters: Any?, completion: ((CommandResult) -> Void)?)
    func send(command nodeCommand: ENodeCommand, nodes: [Device], parameters: Any?, completion: ((CommandResult) -> Void)?)
    func send(commands: [AnyHashable : Any?], node: Device, endedCommand: ((ENodeCommand,CommandResult) -> Void)?, completion: ((CommandResult) -> Void)?)
    func cancel()
}
