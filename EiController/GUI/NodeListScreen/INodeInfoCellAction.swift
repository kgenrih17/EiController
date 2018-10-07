//
//  INodeInfoCellAction.swift
//  EiController
//
//  Created by Henrikh Koreniuzhenko on 02.09.2018.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

protocol INodeInfoCellAction: NSObjectProtocol
{
    func onNodeCellAction(_ action: EDeviceCommanTag, model: NodeListCellViewModel)
    func swipeShowCommands(_ model: NodeListCellViewModel)
}

extension INodeInfoCellAction
{
    func swipeHideCommands(_ model: NodeListCellViewModel)
    {
        
    }
}
