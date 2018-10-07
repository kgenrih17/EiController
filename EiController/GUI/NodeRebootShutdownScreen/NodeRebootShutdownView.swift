//
//  NodeRebootShutdownView.swift
//  EiController
//
//  Created by Henrikh Koreniuzhenko on 20.09.2018.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

class NodeRebootShutdownView: UIViewController
{
    @IBOutlet weak var acceptButton : UIButton!
    @IBOutlet weak var contentScrollView : UIScrollView!
    private var editingListener : DataEditingListener!

    @IBOutlet weak var titleView : UIView!
    @IBOutlet var containerTopConstraint : NSLayoutConstraint!

    @IBOutlet weak var restartContainer : UIView!
    @IBOutlet weak var restartSwitch : Switch!
    @IBOutlet weak var restartButtonGradient : UIView!
    @IBOutlet weak var restartButton : UIButton!
    
    @IBOutlet weak var playbackContainer : UIView!
    @IBOutlet weak var playbackSwitch : Switch!
    @IBOutlet weak var playbackButtonGradient : UIView!
    @IBOutlet weak var playbackButton : UIButton!
    
    @IBOutlet weak var shutdownContainer : UIView!
    @IBOutlet weak var shutdownSwitch : Switch!
    @IBOutlet weak var shutdownButtonGradient : UIView!
    @IBOutlet weak var shutdownButton : UIButton!
    
    var timePopUp : PopupView?
    
    private var presenter : NodeRebootShutdownPresenter!
    private var viewModel : NodeRebootShutdownViewModel?
    
    @objc(initWithFingerprint:) init(fingerprint: String)
    {
        super.init(nibName: String(describing: NodeRebootShutdownView.self), bundle: nil)
        self.presenter = NodeRebootShutdownPresenter.init(interactor: self.interactor(), navigation: self.navigation(), fingerprint: fingerprint)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        timePopUp = PopupView.init(nibName: String(describing: PopupView.self), bundle: nil)
        timePopUp!.setParent(view)
    }
    
    override func removeFromParentViewController()
    {
        super.removeFromParentViewController()
        timePopUp?.removeFromParentViewController()
        timePopUp?.view.removeFromSuperview()
        timePopUp = nil
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

extension NodeRebootShutdownView: INodeRebootShutdownView
{
    func fill(_ model: NodeRebootShutdownViewModel)
    {
        viewModel = model
        view.backgroundColor = model.getBackgroundColor()
        restartContainer.backgroundColor = model.getContainerColor()
        restartSwitch.isOn = model.isRestartOn
        restartButton.isEnabled = model.isRestartOn
        restartButton.setTitle(model.restartTitle, for: .normal)
        refresh(gradient: restartButtonGradient, isOn: model.isRestartOn)
        
        playbackContainer.backgroundColor = model.getContainerColor()
        playbackSwitch.isOn = model.isPlaybackOn
        playbackButton.isEnabled = model.isPlaybackOn
        playbackButton.setTitle(model.playbackTitle, for: .normal)
        refresh(gradient: playbackButtonGradient, isOn: model.isPlaybackOn)
        
        shutdownContainer.backgroundColor = model.getContainerColor()
        shutdownSwitch.isOn = model.isShutdownOn
        shutdownButton.isEnabled = model.isShutdownOn
        shutdownButton.setTitle(model.shutdownTitle, for: .normal)
        refresh(gradient: shutdownButtonGradient, isOn: model.isShutdownOn)
    }
    
    func retrieveChanges()
    {
        viewModel?.isRestartOn = restartSwitch.isOn
        viewModel?.restartTitle = restartButton.titleLabel!.text!
        viewModel?.isPlaybackOn = playbackSwitch.isOn
        viewModel?.playbackTitle = playbackButton.titleLabel!.text!
        viewModel?.isShutdownOn = shutdownSwitch.isOn
        viewModel?.shutdownTitle = shutdownButton.titleLabel!.text!
    }
}

private extension NodeRebootShutdownView
{
    func refresh(gradient: UIView, isOn: Bool)
    {
        if isOn
        {
            gradient.borderStartColor = UIColor.init(red: 0.678, green: 0.286, blue: 0.875, alpha: 1)
            gradient.borderEndColor = UIColor.init(red: 1, green: 0.502, blue: 0.631, alpha: 1)
            gradient.setColors([UIColor.white, UIColor.white])
        }
        else
        {
            let color = UIColor.init(red: 0.404, green: 0.4, blue: 0.475, alpha: 1)
            gradient.borderStartColor = color
            gradient.borderEndColor = color
            gradient.borderDisableColor = color
            gradient.setColors([UIColor.clear, UIColor.clear])
        }
    }
    
    func showPopupBy(date: Date, _ completion: @escaping PopupViewHideCompl)
    {
        timePopUp!.show(date)
        timePopUp!.closeCompletion(completion)
    }
}

extension NodeRebootShutdownView: INodeDetailsTabAction
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

extension NodeRebootShutdownView
{
    @IBAction func clickRestart(aSwitch: Switch)
    {
        restartButton.isEnabled = aSwitch.isOn
        refresh(gradient: restartButtonGradient, isOn: aSwitch.isOn)
    }
    
    @IBAction func clickPlayback(aSwitch: Switch)
    {
        playbackButton.isEnabled = aSwitch.isOn
        refresh(gradient: playbackButtonGradient, isOn: aSwitch.isOn)
    }
    
    @IBAction func clickShutdown(aSwitch: Switch)
    {
        shutdownButton.isEnabled = aSwitch.isOn
        refresh(gradient: shutdownButtonGradient, isOn: aSwitch.isOn)
    }
    
    @IBAction func clickRestartDate()
    {
        showPopupBy(date: viewModel!.restartDate) { (date) in
            self.viewModel!.restartDate = date!
            self.restartButton.setTitle(String.from(date!, "hh:mm a", NSString.localUS()), for: .normal)
        }
    }
    
    @IBAction func clickPlaybackDate()
    {
        showPopupBy(date: viewModel!.playbackDate) { (date) in
            self.viewModel!.playbackDate = date!
            self.playbackButton.setTitle(String.from(date!, "hh:mm a", NSString.localUS()), for: .normal)
        }
    }
    
    @IBAction func clickShutdownDate()
    {
        showPopupBy(date: viewModel!.restartDate) { (date) in
            self.viewModel!.shutdownDate = date!
            self.shutdownButton.setTitle(String.from(date!, "hh:mm a", NSString.localUS()), for: .normal)
        }
    }
}
