//
//  INodeIntegrationStatusedUpdater.swift
//  EiController
//
//  Created by Henrikh Koreniuzhenko on 04.10.2018.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

protocol INodeIntegrationStatusedUpdater
{
    func start(changedTo: ((EConnectionStatusServer, EIntegrationServerType) -> Void)?)
    func stop()
}
