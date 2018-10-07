//
//  ISettingsView.swift
//  EiController
//
//  Created by Henrikh Koreniuzhenko on 02.09.2018.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

protocol ISettingsView: ScreenInterface
{
    func fill(_ model: SettingsViewModel)
    func changeIntervalStateTo(enable: Bool)
    func retrieveChanges()
}
