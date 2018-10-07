//
//  NodeIntegrationView.swift
//  EiController
//
//  Created by Henrikh Koreniuzhenko on 02.09.2018.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

class NodeIntegrationView: UIViewController
{
    @IBOutlet weak var acceptButton : UIButton!
    @IBOutlet weak var contentScrollView : UIScrollView!
    private var editingListener : DataEditingListener!

    @IBOutlet weak var titleView : UIView!
    @IBOutlet var containerTopConstraint : NSLayoutConstraint!

    @IBOutlet weak var managementContainer : UIView!
    @IBOutlet weak var managementSwitch : Switch!
    @IBOutlet weak var managementUpdateSwitch : Switch!
    @IBOutlet weak var useSFTPSwitch : Switch!
    @IBOutlet weak var managementHostTextField : UITextField!
    @IBOutlet weak var portTextField : UITextField!
    @IBOutlet weak var sshTextField : UITextField!
    @IBOutlet weak var timeoutTextField : UITextField!
    @IBOutlet weak var tokenTextField : UITextField!
    @IBOutlet weak var managementCheckButton : UIButton!

    @IBOutlet weak var reverseMonitoringContainer : UIView!
    @IBOutlet weak var reverseMonitoringSwitch : Switch!
    @IBOutlet weak var reverseMonitoringHostTextField : UITextField!
    @IBOutlet weak var reverseMonitoringCheckButton : UIButton!
    @IBOutlet weak var reverseMonitoringErrorLabel : UILabel!
    
    @IBOutlet weak var updateContainer : UIView!
    @IBOutlet weak var updateSwitch : Switch!
    @IBOutlet weak var updateHostTextField : UITextField!
    @IBOutlet weak var updateCheckButton : UIButton!
    @IBOutlet weak var updateErrorLabel : UILabel!

    private var presenter : NodeIntegrationPresenter!
    private var viewModel : NodeIntegrationViewModel?
    
    @objc(initWithFingerprints:) init(fingerprints: [String])
    {
        super.init(nibName: String(describing: NodeIntegrationView.self), bundle: nil)
        self.presenter = NodeIntegrationPresenter.init(interactor: self.interactor(), navigation: self.navigation(), fingerprints: fingerprints)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        presenter.onAttachView(self)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        editingListener = DataEditingListener.init(view: contentScrollView, valueChanged: { (control, isChanged) in
            self.acceptButton.isEnabled = isChanged
        })
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        presenter.onDettachView()
    }
    
    override func close()
    {
        if self.acceptButton.isEnabled
        {
            showAlert("Info", message: "You will lose any information you have edited. Are you sure you wish to close without saving", acceptText: "Yes", declineText: "No") { (isSuccess) in
                if isSuccess
                {
                    super.close()
                }
            }
        }
    }
}

extension NodeIntegrationView: INodeIntegrationView
{
    func fill(_ model: NodeIntegrationViewModel)
    {
        self.viewModel = model
        view.backgroundColor = model.getBackgroundColor()
        managementContainer.backgroundColor = model.getContainerColor()
        managementSwitch.isOn = model.isManagementOn
        managementUpdateSwitch.isOn = model.isUseUpdateOn
        useSFTPSwitch.isOn = model.isUseSFTPOn
        managementHostTextField.text = model.managementHost
        portTextField.text = model.httpPort
        sshTextField.text = model.sshPort
        timeoutTextField.text = model.timeout
        tokenTextField.text = model.token
        refreshManagementState(isEnable: model.isManagementOn)
        
        reverseMonitoringContainer.backgroundColor = model.getContainerColor()
        reverseMonitoringSwitch.isOn = model.isReversMonitoringOn
        reverseMonitoringHostTextField.text = model.reversMonitoringHost
        reverseMonitoringErrorLabel.text = model.reversMonitoringMessage
        reverseMonitoringErrorLabel.textColor = model.reversMonitoringMessageColor
        refreshReverseMonitoringState(isEnable: model.isReversMonitoringOn)
        
        updateContainer.backgroundColor = model.getContainerColor()
        updateSwitch.isOn = model.isUpdateOn
        updateHostTextField.text = model.updateHost
        updateErrorLabel.text = model.updateMessage
        updateErrorLabel.textColor = model.updateMessageColor
        refreshUpdateState(isEnable: model.isUpdateOn)
    }
    
    func retrieveChanges()
    {
        viewModel?.isManagementOn = managementSwitch.isOn
        viewModel?.isUseUpdateOn = managementUpdateSwitch.isOn
        viewModel?.isUseSFTPOn = useSFTPSwitch.isOn
        viewModel?.managementHost = managementHostTextField.text!
        viewModel?.httpPort = portTextField.text!
        viewModel?.sshPort = sshTextField.text!
        viewModel?.timeout = timeoutTextField.text!
        viewModel?.token = tokenTextField.text!
        
        viewModel?.isReversMonitoringOn = reverseMonitoringSwitch.isOn
        viewModel?.reversMonitoringHost = reverseMonitoringHostTextField.text!

        viewModel?.isUpdateOn = updateSwitch.isOn
        viewModel?.updateHost = updateHostTextField.text!
    }
}

extension NodeIntegrationView: INodeDetailsTabAction
{
    @IBAction func clickSave()
    {
        presenter.onClickSave()
    }
    
    func getRightButtonIconName() -> String
    {
        return "settings_icon_accept.png"
    }
    
    func getRightButtonActiveIconName() -> String
    {
        return "settings_icon_accept_active.png"
    }
    
    func removeTitle()
    {
        titleView.removeFromSuperview()
        containerTopConstraint.isActive = true
    }
    
    func setAccept(button: UIButton)
    {
        acceptButton = button
        acceptButton.isEnabled = false
    }
}

private extension NodeIntegrationView
{
    func refreshManagementState(isEnable: Bool)
    {
        managementUpdateSwitch.isEnable = isEnable
        useSFTPSwitch.isEnable = isEnable
        managementHostTextField.superview!.isEnable = isEnable
        portTextField.superview!.isEnable = isEnable
        sshTextField.superview!.isEnable = isEnable
        timeoutTextField.superview!.isEnable = isEnable
        tokenTextField.superview!.isEnable = isEnable
        managementCheckButton.isEnabled = isEnable
        managementCheckButton.superview!.isEnable = isEnable
    }
    
    func refreshReverseMonitoringState(isEnable: Bool)
    {
        reverseMonitoringHostTextField.superview!.isEnable = isEnable
        reverseMonitoringCheckButton.isEnable = isEnable
        reverseMonitoringErrorLabel.isEnable = isEnable
        reverseMonitoringCheckButton.superview!.isEnable = isEnable
    }
    
    func refreshUpdateState(isEnable: Bool)
    {
        updateHostTextField.superview!.isEnable = isEnable
        updateCheckButton.isEnable = isEnable
        updateErrorLabel.isEnable = isEnable
        updateCheckButton.superview!.isEnable = isEnable
    }
}

extension NodeIntegrationView
{
    @IBAction func clickCheckManagement()
    {
        presenter.onClickCheckManagement()
    }
    
    @IBAction func clickCheckReverseMonitoring()
    {
        presenter.onClickCheckReverseMonitoring()
    }
    
    @IBAction func clickCheckUpdate()
    {
        presenter.onClickCheckUpdate()
    }
    
    @IBAction func clickManagement(aSwitch: Switch)
    {
        refreshManagementState(isEnable: aSwitch.isOn)
    }
    
    @IBAction func clickReverseMonitoring(aSwitch: Switch)
    {
        refreshReverseMonitoringState(isEnable: aSwitch.isOn)
    }
    
    @IBAction func clickUpdate(aSwitch: Switch)
    {
        refreshUpdateState(isEnable: aSwitch.isOn)
    }
}
