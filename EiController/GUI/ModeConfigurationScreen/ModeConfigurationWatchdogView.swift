//
//  ModeConfigurationWatchdogView.swift
//  EiController
//
//  Created by Genrih Korenujenko on 15.05.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

protocol ModeConfigurationWatchdogViewAction
{
    func showGridsList()
    func hideGridsList()
    func saveWatchdog()
}

class ModeConfigurationWatchdogView: UIView
{
    @IBOutlet weak var acceptButton : UIButton!
    @IBOutlet weak var contentView : UIView!
    private var editingListener : DataEditingListener!
    
    @IBOutlet var portSwitch : Switch!
    @IBOutlet var watchdogSwitch : Switch!

    @IBOutlet var timeoutTextField : UITextField!
    
    @IBOutlet var saveButton : UIButton!
    
    var actionInterface: ModeConfigurationWatchdogViewAction?
    var model: WatchdogViewModel?
    
    class func build(_ actionInterface: ModeConfigurationWatchdogViewAction,
                     _ model: WatchdogViewModel) -> ModeConfigurationWatchdogView
    {
        let result = Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)!.first as! ModeConfigurationWatchdogView
        result.actionInterface = actionInterface
        result.model = model
        return result
    }
    
    @IBAction func changeEnablePort(sender: Switch)
    {
        model?.isEnablePort = sender.isOn
        refreshEnableState()
        if !model!.isEnablePort
        {
            watchdogSwitch.isOn = false
            changeEnableWatchdog(sender: watchdogSwitch)
        }
    }
    
    @IBAction func changeEnableWatchdog(sender: Switch)
    {
        model?.isEnableWatchdog = sender.isOn
        model!.timeout = 0
        refreshEnableWatchdogState()
    }
    
    @IBAction func save()
    {
        endEditing(true)
        actionInterface?.saveWatchdog()
    }
}

//MARK: Public
extension ModeConfigurationWatchdogView
{
    func load()
    {
        saveButton.imageView?.contentMode = .scaleAspectFit
        portSwitch.isOn = model!.isEnablePort
        watchdogSwitch.isOn = model!.isEnableWatchdog
        refreshEnableWatchdogState()
        refreshGrid()
        refreshEnableState()
        editingListener = DataEditingListener.init(view: contentView, valueChanged: { (control, isChanged) in
            self.acceptButton.isEnabled = isChanged
        })
    }
    
    private func refreshEnableWatchdogState()
    {
        timeoutTextField.superview!.isEnable = model!.isEnableWatchdog
        timeoutTextField.text = String(model!.timeout)
    }
    
    private func refreshEnableState()
    {
        watchdogSwitch.isEnable = portSwitch.isOn
        refreshEnableWatchdogState()
    }
    
    private func refreshGrid()
    {
//        emptyModelMessageLabel.isHidden = !model!.isShowSelectGridMessage
//        nodeTitleLabel.text = model!.grid?.title
//        if let text = nodeTitleLabel.text, text.isEmpty
//        {
//            nodeTitleLabel.text = "N/A"
//        }
//        nodeIPLabel.text = model!.grid?.ip
//        if let text = nodeIPLabel.text, text.isEmpty
//        {
//            nodeIPLabel.text = "N/A"
//        }
//        nodeSNLabel.text = model!.grid?.sn()
//        if let text = nodeSNLabel.text, text.isEmpty
//        {
//            nodeSNLabel.text = "N/A"
//        }
    }
}

//MARK: - EiGridNodesViewListener
extension ModeConfigurationWatchdogView: EiGridNodesViewListener
{
    func select(model: EiGridNodeViewModel)
    {
        self.model!.grid?.isSelected = false
        self.model!.grid = model
        self.model!.grid?.isSelected = true
        self.model?.isShowSelectGridMessage = false
        refreshGrid()
        cancel()
    }
    
    func cancel()
    {
        actionInterface?.hideGridsList()
    }
}

//MARK: UITextFieldDelegate
extension ModeConfigurationWatchdogView: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if let text = textField.text, let timeout = Int(text)
        {
            model?.timeout = timeout
        }
        else
        {
            model?.timeout = 0
        }
    }
}
