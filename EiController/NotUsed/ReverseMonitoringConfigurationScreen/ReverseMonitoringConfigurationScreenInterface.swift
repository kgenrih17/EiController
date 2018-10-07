//
//  ReverseMonitoringConfigurationScreenInterface.swift
//  EiController
//
//  Created by Genrih Korenujenko on 05.05.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

protocol ReverseMonitoringConfigurationScreenInterface: ScreenInterface
{
    func refresh(model : ReverseMonitoringConfigurationViewModel)
    func setFieldColor(color : UIColor)
}
