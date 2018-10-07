//
//  ModeConfigurationScreenInterface.swift
//  EiController
//
//  Created by Genrih Korenujenko on 15.05.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

enum EConfigurationScreenMode : Int
{
    case STANDALONE
    case AUXILIAURY
}

protocol ModeConfigurationScreenInterface: ScreenInterface
{
    func setViewModels(_ models: [EiGridNodeViewModel])
    func setMode(_ mode: EConfigurationScreenMode)
    func buildManualPairing(_ sn: String)
    func buildListPairing(_ model: EiGridNodeViewModel)
    func buildPaired(with model: EiGridNodeViewModel)
    func buildWatchdog(model: WatchdogViewModel)
    func clearWatchdog()
    func close()
}
