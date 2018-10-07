//
//  INodesListView.swift
//  EiController
//
//  Created by Henrikh Koreniuzhenko on 31.08.2018.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

protocol INodesListView: ScreenInterface
{
    func fill(_ model: NodesListViewModel)
    func refreshPageControl()
    func changeStateActiveElements(_ model: NodesListViewModel)
    func updateCell(by indexPath: IndexPath)
    func refreshSyncProgress(_ syncModel: CentralSyncProgressViewModel)
    func closeCentralSyncProgressView()
    func enableGroupOperations()
    func disableGroupOperations()
}
