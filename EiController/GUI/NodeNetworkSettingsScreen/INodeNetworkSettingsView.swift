//
//  INodeNetworkSettingsView.swift
//  EiController
//
//  Created by Henrikh Koreniuzhenko on 21.09.2018.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

protocol INodeNetworkSettingsView: ScreenInterface
{
    func fill(_ model : NodeNetworkSettingsViewModel)
    func retrieveChanges()
    func showEthernetTab()
    func showWiFiTab()
}
