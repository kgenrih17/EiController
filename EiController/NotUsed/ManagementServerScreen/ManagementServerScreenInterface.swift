//
//  ManagementServerScreenInterface.swift
//  EiController
//
//  Created by Genrih Korenujenko on 17.05.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

protocol ManagementServerScreenInterface: ScreenInterface
{
    func refresh(integration: DeviceIntegrationInfo)
    func showMessage(_ message: String, color: UIColor)
}
