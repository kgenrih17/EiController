//
//  SettingsView.swift
//  EiController
//
//  Created by Henrikh Koreniuzhenko on 02.09.2018.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

class SettingsView: UIViewController
{
    @IBOutlet weak var publisherShadowView: UIView!
    @IBOutlet weak var publisherContainer: UIView!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var centralShadowView: UIView!
    @IBOutlet weak var centralContainer: UIView!
    @IBOutlet weak var centralLabel: UILabel!
    @IBOutlet weak var syncShadowView: UIView!
    @IBOutlet weak var syncContainer: UIView!
    @IBOutlet weak var intervalTextField: UITextField!
    @IBOutlet weak var autoSyncSwitch: Switch!
    @IBOutlet weak var showStatusSwitch: Switch!
    @IBOutlet weak var logoutContainerView: UIView!
    @IBOutlet weak var progressContainerView: UIView!
    @IBOutlet var progressConstraint: NSLayoutConstraint!
    @IBOutlet weak var spaceContainerView: UIView!
    @IBOutlet weak var spaceLabel: UILabel!
    @IBOutlet weak var versionContainerView: UIView!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var syncCentralContainer: UIView!

    private var presenter : SettingsPresenter!
    private var viewModel : SettingsViewModel?
    
    init()
    {
        super.init(nibName: String(describing: SettingsView.self), bundle: nil)
        self.presenter = SettingsPresenter.init(interactor: self.interactor(), navigation: self.navigation())
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
    
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        presenter.onDettachView()
    }
    
    func changeGradient(isOn: Bool, view: UIView)
    {
        if isOn
        {
            view.backgroundColor = .clear
            view.startColor = UIColor.init(red: 1, green: 0.502, blue: 0.631, alpha: 1)
            view.endColor = UIColor.init(red: 0.678, green: 0.286, blue: 0.875, alpha: 1)
            view.startLocation = 0
            view.endLocation = 1
            view.horizontalMode = true
            view.diagonalMode = false
        }
        else
        {
            view.clear()
            view.backgroundColor = UIColor.init(red: 0.325, green: 0.325, blue: 0.4, alpha: 1)
        }
    }
}

extension SettingsView: ISettingsView
{
    func fill(_ model: SettingsViewModel)
    {
        self.viewModel = model
        view.backgroundColor = model.getBackgroundColor()
        publisherLabel.text = model.eiPublisherAddress
        centralLabel.text = model.eiCentralAddress
        autoSyncSwitch.isOn = model.isAutoSyncOn
        intervalTextField.text = model.interval
        intervalTextField.isEnabled = model.isAutoSyncOn
        showStatusSwitch.isOn = model.isShowStatusOn
        spaceLabel.text = model.space
        spaceLabel.textColor = model.getTextColor()
        versionLabel.text = model.version
        versionLabel.textColor = model.getTextColor()
        versionContainerView.backgroundColor = model.getContainerColor()
        logoutContainerView.backgroundColor = model.getContainerColor()
        spaceContainerView.backgroundColor = model.getContainerColor()
        progressContainerView.backgroundColor = model.getSpaceTrackColor()
        let width = model.progress * progressContainerView.frame.width
        view.setNeedsLayout()
        progressConstraint.constant = width > progressContainerView.frame.width ? progressContainerView.frame.width : width
        if !model.isExtenderMode
        {
            publisherContainer.removeFromSuperview()
            publisherShadowView.removeFromSuperview()
            centralContainer.removeFromSuperview()
            centralShadowView.removeFromSuperview()
            syncContainer.removeFromSuperview()
            syncShadowView.removeFromSuperview()
        }
        view.layoutIfNeeded()
    }
    
    func changeIntervalStateTo(enable: Bool)
    {
        intervalTextField.isEnabled = enable
    }
    
    func retrieveChanges()
    {
        viewModel?.isAutoSyncOn = autoSyncSwitch.isOn
        viewModel?.isShowStatusOn = showStatusSwitch.isOn
        viewModel?.interval = intervalTextField.text!
    }
}

extension SettingsView
{
    @IBAction func clickAutoSync()
    {
        intervalTextField.superview!.isEnable = autoSyncSwitch.isOn
        intervalTextField.endEditing(true)
    }
    
    @IBAction func clickLogs()
    {
        presenter.onClickLogs()
    }
    
    @IBAction func clickAccept()
    {
        presenter.onClickAccept()
    }
    
    @IBAction func clickLogout()
    {
        presenter.onClickLogout()
    }
}
