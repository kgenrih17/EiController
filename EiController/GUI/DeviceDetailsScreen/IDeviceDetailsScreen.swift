//
//  IDeviceDetailsScreen.swift
//  EiController
//
//  Created by Henrikh Koreniuzhenko on 27.08.2018.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

protocol IDeviceDetailsScreen: ScreenInterface
{
    func fill(_ model: DeviceDetailsViewModel?)
    func showProfile(_ fingerprint: String)
    func showPerformance(_ fingerprint: String)
    func showNetworkSettings(_ fingerprint: String)
    func showIntegration(_ fingerprint: String)
    func showRestartScheduler(_ fingerprint: String)
    func showMode(_ fingerprint: String)
    func showLog(_ fingerprint: String)
    func updateImageBy(serverType: EIntegrationServerType)
}
