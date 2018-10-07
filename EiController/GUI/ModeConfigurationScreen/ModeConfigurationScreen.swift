//
//  ModeConfigurationScreen.swift
//  EiController
//
//  Created by Genrih Korenujenko on 15.05.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ModeConfigurationScreen: UIViewController, ModeConfigurationScreenInterface, ModeConfigurationNodePairingViewListener, ModeConfigurationPairedNodeViewListener, EiGridNodesViewListener, ModeConfigurationWatchdogViewAction
{
    @IBOutlet weak var titleView : UIView!
    @IBOutlet var containerTopConstraint : NSLayoutConstraint!

    @IBOutlet var modeView : UIView!
    @IBOutlet var auxiliauryButton : UIButton!
    @IBOutlet var nodeView : UIView!
    @IBOutlet var settingsView : UIView!
    
    @IBOutlet var centralContainerHeightConstraint : NSLayoutConstraint!
    
    var watchdogView : ModeConfigurationWatchdogView?
    var pairedNodeView : ModeConfigurationPairedNodeView?
    var pairingNodeView : ModeConfigurationNodePairingView?
    var gridNodesListView : EiGridNodesView?
    
    var presenter : ModeConfigurationPresenter!
    var models : [EiGridNodeViewModel]?
    var mode : EConfigurationScreenMode = .AUXILIAURY
    var selectedModel : EiGridNodeViewModel?
    
    @objc(initWithFingerprint:) init(fingerprint: String)
    {
        super.init(nibName: String(describing: ModeConfigurationScreen.self), bundle: nil)
        self.presenter = ModeConfigurationPresenter.init(screen: self, interactor: interactor(), fingerprint: fingerprint)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        auxiliauryButton.tag = EConfigurationScreenMode.AUXILIAURY.rawValue
        presenter.onCreate()
        if AppStatus.isExtendedMode()
        {
            view.backgroundColor = UIColor.hex("f8f8f8")
        }
        else
        {
            view.backgroundColor = UIColor.hex("23222a")
        }
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        view.setNeedsLayout()
        view.layoutIfNeeded()
        auxiliauryButton.updateGradient()
    }
    
    func removeTitle()
    {
        titleView.removeFromSuperview()
        containerTopConstraint.isActive = true
    }
    
    func setAccept(button: UIButton)
    {
        
    }
    
    func setViewModels(_ models: [EiGridNodeViewModel])
    {
        self.models = models
    }
    
    func setMode(_ mode: EConfigurationScreenMode)
    {
        self.mode = mode
        auxiliauryButton.isSelected = true
    }
    
    func buildManualPairing(_ sn: String)
    {
        showPairing(model: nil, sn: sn)
    }
    
    func buildListPairing(_ model: EiGridNodeViewModel)
    {
        showPairing(model: model, sn: nil)
    }
    
    func buildPaired(with model: EiGridNodeViewModel)
    {
        selectedModel = model
        if pairedNodeView?.superview == nil
        {
            pairingNodeView?.removeFromSuperview()
            pairingNodeView = nil
            pairedNodeView = ModeConfigurationPairedNodeView.build(listener: self)
            addView(pairedNodeView!, toView: nodeView, heightConstraint: centralContainerHeightConstraint)
        }
        pairedNodeView?.load(model: selectedModel!)
        settingsView.isUserInteractionEnabled = true
        settingsView.alpha = 1
    }
    
    func buildWatchdog(model: WatchdogViewModel)
    {
        if watchdogView == nil
        {
            watchdogView = ModeConfigurationWatchdogView.build(self, model)
            addView(watchdogView!, toView: settingsView, heightConstraint: nil)
        }
        else
        {
            watchdogView!.model = model
        }
        if let lSelectedModel = selectedModel, lSelectedModel.isOnline
        {
            settingsView.isUserInteractionEnabled = true
            settingsView.alpha = 1
        }
        else
        {
            settingsView.isUserInteractionEnabled = false
            settingsView.alpha = 0.5
        }
        
        watchdogView?.load()
    }
    
    func clearWatchdog()
    {
        watchdogView?.removeFromSuperview()
        watchdogView = nil
    }
    
    func pairNode(sn: String?)
    {
        presenter.pair(selectedModel, sn, false)
    }
    
    func showNodesList()
    {
        addGridList(listener: self, selected: selectedModel)
    }
    
    //MARK: ModeConfigurationPairedNodeViewListener
    func disconnectNode()
    {
        selectedModel?.isSelected = false
        presenter.disconnect(selectedModel!)
    }
    
    func refreshNode()
    {
        presenter.refreshModeConfiguration()
    }
    
    //MARK: - EiGridNodesViewListener
    func select(model: EiGridNodeViewModel)
    {
        selectedModel?.isSelected = false
        selectedModel = model
        model.isSelected = true
        pairingNodeView?.load(model: selectedModel, sn: nil)
        hideGridsList()
    }
    
    func cancel()
    {
        hideGridsList()
    }
    
    //MARK: - ModeConfigurationWatchdogViewAction
    func showGridsList()
    {
        addGridList(listener: watchdogView!, selected: watchdogView!.model?.grid)
    }
    
    func hideGridsList()
    {
        gridNodesListView?.removeFromSuperview()
        gridNodesListView = nil
    }
    
    func saveWatchdog()
    {
        watchdogView!.model!.grid = selectedModel
        presenter.saveWatchdog(watchdogView!.model!)
    }
    
    private func showPairing(model: EiGridNodeViewModel?, sn: String?)
    {
        selectedModel = model
        pairedNodeView?.removeFromSuperview()
        pairedNodeView = nil
        pairingNodeView = ModeConfigurationNodePairingView.build(listener: self)
        addView(pairingNodeView!, toView: nodeView, heightConstraint: centralContainerHeightConstraint)
        pairingNodeView?.load(model: model, sn: sn)
        settingsView.isUserInteractionEnabled = false
        settingsView.alpha = 0.5
    }

    private func addGridList(listener: EiGridNodesViewListener, selected: EiGridNodeViewModel?)
    {
        let grids = Array(models!)
        for grid in grids
        {
            if grid.fingerprint == selected?.fingerprint || grid.sn() == selected?.sn()
            {
                grid.isSelected = true
            }
            else
            {
                grid.isSelected = false
            }
        }
        gridNodesListView = EiGridNodesView.build(listener: listener)
        navigation().show(gridNodesListView)
        gridNodesListView?.load(models: grids)
    }
    
    private func addView(_ view: UIView, toView: UIView, heightConstraint: NSLayoutConstraint?)
    {
        toView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setNeedsLayout()
        view.leadingAnchor.constraint(equalTo: toView.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: toView.trailingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: toView.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: toView.bottomAnchor).isActive = true
        if let constraint = heightConstraint
        {
            constraint.constant = view.frame.height
        }
        view.layoutSubviews()
        if AppStatus.isExtendedMode()
        {
            view.backgroundColor = UIColor.white
        }
        else
        {
            view.backgroundColor = UIColor.init(red: 0.329, green: 0.318, blue: 0.404, alpha: 1)
        }
    }
    
    @IBAction func changeMode(sender: UIButton)
    {
//        if !sender.isSelected
//        {
//            presenter.changeTo(mode: EConfigurationScreenMode(rawValue: sender.tag)!)
//        }
    }
}
