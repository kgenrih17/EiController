//
//  NodesListViewModel.swift
//  EiController
//
//  Created by Henrikh Koreniuzhenko on 02.09.2018.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

private let DEFAULT_DEVICE_LIST_HEADER_HEIGHT : CGFloat = 30.0
private let ADDITIONAL_DEVICE_LIST_HEADER_HEIGHT : CGFloat = 8.0

class NodesListViewModel
{
    var isExtenderMode = true
    var isShowSections = true
    var isShowGroupOperations = true
    var isShowSyncWithCentralButton = false
    var isStartedSync = false
    var numberOfPages : Int
    {
        get
        {
            return cellViewModels.count
        }
    }
    var page = ENodeListPage.NODE_PAGE
    var defaultStatus : EDeviceStatus = .LOCAL_STATUS
    var cellViewModels = [ENodeListPage:[NodeListCellViewModel]]()
    var nodes : [NodeListCellViewModel]
    {
        get
        {
            if let models = cellViewModels[page]
            {
                return models
            }
            else
            {
                return [NodeListCellViewModel]()
            }
        }
        set { }
    }
    var sections = [NodeListSectionViewModel]()
    
    func getTitle() -> String
    {
        var result : String!
        switch page
        {
        case .NODE_PAGE:
            result = "Nodes: "
        case .CONTROLLER_PAGE:
            result = "Controllers: "
        case .NOT_SUPPORTED_PAGE:
            result = "Not Supported: "
        }
        if cellViewModels.keys.count == 0
        {
            result.append("0")
        }
        else
        {
            result.append("\(nodes.count)")
        }
        return result
    }
    
    func getNumberOfSections() -> Int
    {
        var numberOfSections = 0
        if isShowSections
        {
            numberOfSections = sections.count
        }
        else if !nodes.isEmpty
        {
            numberOfSections = 1
        }
        return numberOfSections
    }
    
    func getNumberOfCells(_ section: Int) -> Int
    {
        let status: EDeviceStatus!
        if isShowSections, sections.count > section
        {
            status = sections[section].status!
        }
        else
        {
            status = defaultStatus
        }
        let cellsInSections = nodes.filter { (node) -> Bool in
            return node.status == status
        }
        return cellsInSections.count
    }

    func getSectionHeight(_ section: Int) -> CGFloat
    {
        var height: CGFloat = 0
        if isShowSections
        {
            if section == 0
            {
                height = DEFAULT_DEVICE_LIST_HEADER_HEIGHT
            }
            else
            {
                height = DEFAULT_DEVICE_LIST_HEADER_HEIGHT + ADDITIONAL_DEVICE_LIST_HEADER_HEIGHT
            }
        }
        return height
    }
    
    func getCellHeight() -> CGFloat
    {
        return 76.0
    }
    
    func getCellViewModel(_ indexPath: IndexPath) -> NodeListCellViewModel
    {
        let status: EDeviceStatus!
        if isShowSections, sections.count > indexPath.section
        {
            status = sections[indexPath.section].status!
        }
        else
        {
            status = defaultStatus
        }
        let modelsAtStatus = nodes.filter { $0.status == status }
        return modelsAtStatus[indexPath.row]
    }
    
    func getIndexPath(_ model: NodeListCellViewModel) -> IndexPath
    {
        let modelsAtStatus = nodes.filter { $0.status == model.status }
        let fingerprints = modelsAtStatus.map { $0.fingerprint }
        let index = fingerprints.index(of: model.fingerprint)!
        let section = sections.index { $0.status! == model.status }
        return IndexPath(row: index, section: isShowSections ? section! : 0)
    }

    func getSelectedNodes() -> [NodeListCellViewModel]
    {
        return nodes.filter { $0.isSelected == true }
    }
    
    func getUserInteractionEnableNodes() -> [NodeListCellViewModel]
    {
        return nodes.filter { $0.isUserInteractionEnabled == true }
    }
    
    func getSelectedFingerprints() -> [String]
    {
        return getSelectedNodes().map { $0.fingerprint }
    }
    
    func replace(_ model: NodeListCellViewModel)
    {
        let modelsAtStatus = nodes.filter { $0.status == model.status }
        let fingerprints = modelsAtStatus.map { $0.fingerprint }
        if fingerprints.contains(model.fingerprint)
        {
            let index = fingerprints.index(of: model.fingerprint)!
            let node = nodes[index]
            node.title = model.title
            node.systemId = model.systemId
            node.serialNumber = model.serialNumber
            node.productId = model.productId
            node.version = model.version
            node.edition = model.edition
            node.model = model.model
            node.companyUnique = model.companyUnique
            node.timezone = model.timezone
        }
    }
    
    func isCanChangePage(_ direction: Int) -> Bool
    {
        let enumIndex = page.rawValue + direction
        if enumIndex < 0 || enumIndex > ENodeListPage.maxValue
        {
            return false
        }
        else
        {
            return true
        }
    }
}
