//
//  INodeRebootShutdownView.swift
//  EiController
//
//  Created by Henrikh Koreniuzhenko on 20.09.2018.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

protocol INodeRebootShutdownView: ScreenInterface
{
    func fill(_ model : NodeRebootShutdownViewModel)
    func retrieveChanges()
}
