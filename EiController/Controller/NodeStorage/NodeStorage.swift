//
//  NodeStorage.swift
//  EiController
//
//  Created by Henrikh Koreniuzhenko on 04.09.2018.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

private let SUPPORTED_VERSION_4_0_2 = "4.0.2"
private let SUPPORTED_VERSION_4_0_0_P1 = "4.0.0.p1"
private let SUPPORTED_VERSION_4_0_0_P_1 = "4.0.0.p.1"
private let SUPPORTED_CONTROLLER_MODEL_EIC100 = "eic100"

@objc class NodeStorage: NSObject
{
    private var storageCleaner : StorageCleanerInterface?
    private var listeners = [INodeStorageListener]()
    private var userDevices = [String:Device]()
    private var centralDevices = [Device]()
    private var localDevices = [Device]()
    private var table = DevicesTable()
    private var syncStatusesTable = DeviceSyncStatusesTable()
    
    deinit
    {
        storageCleaner = nil
    }
}

private extension NodeStorage
{
    func notifDevicesUpdatedListeners()
    {
        for listener in listeners
        {
            listener.devicesUpdated()
        }
    }
    
    func notifDevicesNotUpdatedListeners()
    {
        for listener in listeners
        {
            listener.devicesNotUpdated()
        }
    }
    
    func prepareFingerprintsForRemove(_ newDevices: [Device]) -> [String]
    {
        let centralFingers = Set(centralDevices.map { $0.fingerprint })
        let newFingers = Set(newDevices.map { $0.fingerprint })
        return Array(centralFingers.subtracting(newFingers))
    }
    
    func updateSyncStatusIfNeed(_ devices: [Device])
    {
        let fingerprints = devices.map { $0.fingerprint! }
        let syncStatuses = syncStatusesTable.getByFingerprints(fingerprints).allValues
        var statusesForUpdate = [DeviceSyncStatus]()
        for syncStatus in syncStatuses as! [DeviceSyncStatus]
        {
            if syncStatus.processing == .WAITING_SYNC || syncStatus.processing == .SYNCHRONIZING
            {
                syncStatus.processing = .END_SYNC
                syncStatus.message = "Can't find device locally"
                statusesForUpdate.append(syncStatus)
            }
        }
        if !statusesForUpdate.isEmpty
        {
            syncStatusesTable.updateItems(statusesForUpdate)
        }
    }
    
    func isValidNode(version: String) -> Bool
    {
        return version >= SUPPORTED_VERSION_4_0_2 || version == SUPPORTED_VERSION_4_0_0_P1 || version == SUPPORTED_VERSION_4_0_0_P_1
    }
}

extension NodeStorage: INodeStorage
{
    func build(storageCleaner: StorageCleanerInterface) -> INodeStorage
    {
        let result = NodeStorage.init()
        result.storageCleaner = storageCleaner
        return result
    }

    func load()
    {
        centralDevices = table.getAll() as NSArray as! [Device]
        notifDevicesUpdatedListeners()
    }
    
    func addObserver(_ listener: INodeStorageListener)
    {
        listeners.append(listener)
    }
    
    func removeObserver(_ listener: INodeStorageListener)
    {
        listeners = listeners.filter { !$0.isEqual(listener) }
    }
    
    func removeAllObservers()
    {
        listeners.removeAll()
    }
    
    func getCentralFingerprints() -> [String]
    {
        return centralDevices.map { $0.fingerprint }
    }
    
    func getDevicesByFingerprints(_ fingerprints: [String]) -> [Device]
    {
        return userDevices.values.filter { fingerprints.contains($0.fingerprint) }
    }
    
    func getDeviceByFingerprint(_ fingerprint: String) -> Device?
    {
        return getDevicesByFingerprints([fingerprint]).first
    }
    
    func getCentralDevices() -> [Device]
    {
        return centralDevices
    }
    
    func getLocalDevices() -> [Device]
    {
        return localDevices
    }
    
    func getLiveDevices() -> [String : Device]
    {
        return userDevices
    }
    
    func getNodes() -> [String : Device]
    {
        return userDevices.filter { isValidNode(version: $0.value.version) && $0.value.model?.lowercased() != SUPPORTED_CONTROLLER_MODEL_EIC100 }
    }
    
    func getControllers() -> [String : Device]
    {
        return userDevices.filter { isValidNode(version: $0.value.version) && $0.value.model?.lowercased() == SUPPORTED_CONTROLLER_MODEL_EIC100 }
    }
    
    func getNotSuported() -> [String : Device]
    {
        return userDevices.filter { !isValidNode(version: $0.value.version) }
    }
    
    func setCentralDevices(_ devices: [Device])
    {
        let fingerprintsForDelete = prepareFingerprintsForRemove(devices)
        if !fingerprintsForDelete.isEmpty
        {
            storageCleaner?.clearUnnecessaryDeviceData(fingerprintsForDelete)
        }
        if devices != centralDevices
        {
            table.update(devices)
            centralDevices.removeAll()
            centralDevices += devices
            notifDevicesUpdatedListeners()
        }
        else
        {
            notifDevicesNotUpdatedListeners()
        }
    }
    
    func setLocalDevices(_ devices: [Device])
    {
        if devices != localDevices
        {
            localDevices = localDevices.filter { !devices.contains($0) }
            updateSyncStatusIfNeed(localDevices)
            localDevices.removeAll()
            localDevices += devices
            notifDevicesUpdatedListeners()
        }
        else
        {
            notifDevicesNotUpdatedListeners()
        }
    }
    
    func setLiveDevices(_ devices: [String : Device])
    {
        userDevices = devices
    }
    
    func setSyncStatus(_ syncStatus: DeviceSyncStatus)
    {
        let centralDevice = centralDevices.filter { $0.fingerprint == syncStatus.fingerprint }.first
        let localDevice = localDevices.filter { $0.fingerprint == syncStatus.fingerprint }.first
        centralDevice?.syncStatus = syncStatus
        localDevice?.syncStatus = syncStatus
    }
    
    func removeData(_ fingerprint: String)
    {
        table.remove(byFingerprints: [fingerprint])
    }
    
    func clear()
    {
        userDevices.removeAll()
        centralDevices.removeAll()
        localDevices.removeAll()
        table.clear()
    }
}
