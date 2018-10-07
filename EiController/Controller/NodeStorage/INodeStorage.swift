//
//  INodeStorage.swift
//  EiController
//
//  Created by Henrikh Koreniuzhenko on 04.09.2018.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

@objc protocol INodeStorage: StorageInterface
{
    func build(storageCleaner: StorageCleanerInterface) -> INodeStorage
    func load()
    
    func addObserver(_ observerInterface: INodeStorageListener)
    func removeObserver(_ observerInterface: INodeStorageListener)
    func removeAllObservers()

    func getCentralFingerprints() -> [String]
    func getDevicesByFingerprints(_ fingerprints: [String]) -> [Device]
    func getDeviceByFingerprint(_ fingerprint: String) -> Device?
    func getCentralDevices() -> [Device]
    func getLocalDevices() -> [Device]
    func getLiveDevices() -> [String : Device]
    func getNodes() -> [String : Device]
    func getControllers() -> [String : Device]
    func getNotSuported() -> [String : Device]

    func setCentralDevices(_ devices: [Device])
    func setLocalDevices(_ devices: [Device])
    func setLiveDevices(_ devices: [String : Device])
    func setSyncStatus(_ syncStatus: DeviceSyncStatus)
    
    func removeData(_ fingerprint: String)
}
