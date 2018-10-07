//
//  NodePerformancePresenter.swift
//  EiController
//
//  Created by Henrikh Koreniuzhenko on 04.09.2018.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

class NodePerformancePresenter: NSObject
{
    weak var view: INodePerformanceView?
    weak var interactor: AppInteractorInterface?
    weak var navigation: NavigationInterface?
    var viewModel: NodePerformanceViewModel?
    var fingerprint: String
    
    init(interactor : AppInteractorInterface, navigation : NavigationInterface, fingerprint: String)
    {
        self.interactor = interactor
        self.navigation = navigation
        self.fingerprint = fingerprint
        super.init()
    }
    
    func onAttachView(_ view: INodePerformanceView)
    {
        self.view = view
        createViewModel()
        view.fill(viewModel!)
    }
    
    func onDettachView()
    {
        view = nil
        viewModel = nil
    }
}

private extension NodePerformancePresenter
{
    func createViewModel()
    {
        let device = interactor?.getNodeStorage().getDeviceByFingerprint(fingerprint)
        viewModel = NodePerformanceViewModel()
        viewModel?.fingerprint = fingerprint
        viewModel?.isExtenderMode = AppStatus.isExtendedMode()
        let cpus = createProgressModels(device!.cpusTemp, "CPU", [])
        viewModel?.models = createProgressModels(device!.cpusLoad, "CPU", cpus)
        let gpus = createProgressModels(device!.gpusTemp, "GPU", [])
        let loadGpus = NSMutableArray.init(array: device!.gpusTemp.map { _ in return "0" })
        viewModel?.models += createProgressModels(loadGpus, "GPU", gpus)
        if device?.hddTotal != NO_HARDWARE_DATA && device?.hddFree != NO_HARDWARE_DATA
        {
            viewModel?.storageTotal = convertByteToMB(device!.hddTotal)
            viewModel?.storageFree = convertByteToMB(device!.hddFree)
            let hddUsed = device!.hddTotal - device!.hddFree
            viewModel?.storageProgress = CGFloat((Float(hddUsed) / Float(device!.hddTotal)))
        }
        else
        {
            viewModel?.storageTotal = "N/A"
            viewModel?.storageFree = "N/A"
            viewModel?.storageProgress = 0
        }
        
        if device?.ramFree != NO_HARDWARE_DATA && device?.ramTotal != NO_HARDWARE_DATA
        {
            viewModel?.ramTotal = convertByteToMB(device!.ramTotal)
            viewModel?.ramFree = convertByteToMB(device!.ramFree)
            let ramUsed = device!.ramTotal - device!.ramFree
            viewModel?.ramProgress = CGFloat(Float(ramUsed) / Float(device!.ramTotal))
        }
        else
        {
            viewModel?.ramTotal = "N/A"
            viewModel?.ramFree = "N/A"
            viewModel?.ramProgress = 0
        }
    }

    func convertByteToMB(_ bytes: Int) -> String
    {
        let byteFormatter = ByteCountFormatter()
        byteFormatter.countStyle = .binary
        byteFormatter.allowedUnits = (Float(bytes) < pow(10,9.0)) ? .useMB : .useGB
        return byteFormatter.string(fromByteCount: Int64(bytes))
    }
    
    func createProgressModels(_ items: NSMutableArray, _ title: String, _ models: [ProgressViewModel]) -> [ProgressViewModel]
    {
        var result : [ProgressViewModel] = []
        for (index, item) in items.enumerated()
        {
            var progress : Float = 0
            if let number = item as? NSNumber
            {
                progress = number.floatValue
            }
            else if let numeric = item as? String
            {
                progress = Float(numeric)!
            }
            
            var model : ProgressViewModel!
            if index < models.count
            {
                model = models[index]
                model.loadProgress = CGFloat(progress)
                if progress > 0
                {
                    model.loadTitle = "\(progress)%"
                }
                else
                {
                    model.loadTitle = "N/A"
                }
            }
            else
            {
                model = ProgressViewModel()
                model.isExtenderMode = viewModel!.isExtenderMode
                model.temperatureProgress = CGFloat(progress)
                if items.count > 1
                {
                    model.title = "\(title) \(index + 1)"
                }
                else
                {
                    model.title = title
                }
                
                if progress > 0
                {
                    model.temperatureTitle = "\(progress)°C"
                }
                else
                {
                    model.temperatureTitle = "N/A"
                }
            }
            model!.fillColors()
            result.append(model)
        }
        return result
    }
}
