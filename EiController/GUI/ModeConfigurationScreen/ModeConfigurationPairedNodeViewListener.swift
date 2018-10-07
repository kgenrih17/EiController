//
//  ModeConfigurationPairedNodeViewListener.swift
//  EiController
//
//  Created by Genrih Korenujenko on 16.05.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

protocol ModeConfigurationPairedNodeViewListener: NSObjectProtocol
{
    func disconnectNode()
    func refreshNode()
}
