//
//  NodeProfileView.swift
//  EiController
//
//  Created by Henrikh Koreniuzhenko on 04.09.2018.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

class NodeProfileView: UIViewController
{
    @IBOutlet private var commandsView : UIView!
    @IBOutlet private var rebootLabel : UILabel!
    @IBOutlet private var rebootButton : UIButton!
    @IBOutlet private var rebootImage : UIImageView!
    @IBOutlet private var restartLabel : UILabel!
    @IBOutlet private var restartButton : UIButton!
    @IBOutlet private var restartImage : UIImageView!
    @IBOutlet private var shutdownLabel : UILabel!
    @IBOutlet private var shutdownButton : UIButton!
    @IBOutlet private var shutdownImage : UIImageView!
    @IBOutlet private var infoView : UIView!
    @IBOutlet private var editionLabel : UILabel!
    @IBOutlet private var systemIDLabel : UILabel!
    @IBOutlet private var locationLabel : UILabel!
    @IBOutlet private var companyLabel : UILabel!
    @IBOutlet private var ipAddressLabel : UILabel!
    @IBOutlet private var timeZoneLabel : UILabel!
    @IBOutlet private var registrationDateLabel : UILabel!
    @IBOutlet private var eiInfoLabel : UILabel!
    @IBOutlet private var activityLabel : UILabel!
    @IBOutlet private var rebootSchedulerLabel : UILabel!
    @IBOutlet private var upTimeLabel : UILabel!
    @IBOutlet private var systemTimeLabel : UILabel!

    private var presenter : NodeProfilePresenter!
    var viewModel : NodeProfileViewModel?
    
    @objc(initWithFingerprint:) init(fingerprint: String)
    {
        super.init(nibName: String(describing: NodeProfileView.self), bundle: nil)
        self.presenter = NodeProfilePresenter.init(interactor: self.interactor(), navigation: self.navigation(), fingerprint: fingerprint)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
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
}

extension NodeProfileView: INodeProfileView
{
    func fill(_ model: NodeProfileViewModel?)
    {
        viewModel = model
        self.view.backgroundColor = model?.getBackgroundColor()
        editionLabel.text = model?.edition
        systemIDLabel.text = model?.systemID
        locationLabel.text = model?.location
        companyLabel.text = model?.company
        ipAddressLabel.text = model?.ipAddress
        timeZoneLabel.text = model?.timeZone
        registrationDateLabel.text = model?.registrationDate
        eiInfoLabel.text = model?.eiInfo
        activityLabel.text = model?.activity
        upTimeLabel.text = model?.upTime
        systemTimeLabel.text = model?.systemTime
        rebootSchedulerLabel.text = model?.rebootScheduler
        commandsView.isUserInteractionEnabled = (model?.isEnableCommands)!
        
        let textColor = model!.getTitleColor()
        editionLabel.textColor = textColor
        systemIDLabel.textColor = textColor
        locationLabel.textColor = textColor
        companyLabel.textColor = textColor
        ipAddressLabel.textColor = textColor
        timeZoneLabel.textColor = textColor
        registrationDateLabel.textColor = textColor
        eiInfoLabel.textColor = textColor
        activityLabel.textColor = textColor
        upTimeLabel.textColor = textColor
        systemTimeLabel.textColor = textColor
        rebootSchedulerLabel.textColor = model?.rebootSchedulerColor

        let containerColor = model?.getContainerColor()
        infoView.backgroundColor = containerColor

        if model!.isUserMode
        {
            shutdownLabel.alpha = 0.5
            shutdownImage.alpha = 0.5
            shutdownButton.isEnabled = false
            rebootLabel.alpha = 0.5
            rebootImage.alpha = 0.5
            rebootButton.isEnabled = false
        }
        if model!.isNeedUpdate || model!.isUserMode
        {
            restartLabel.text = "SYNC"
            restartButton.tag = EProfileAction.SYNC_ACTION.rawValue
            restartImage.image = UIImage.init(named: "node_action_eisync_icon.png")
        }
        else
        {
            restartLabel.text = "RESTART"
            restartButton.tag = EProfileAction.RESTART_ACTION.rawValue
            restartImage.image = UIImage.init(named: "details_icon_restart.png")
        }
    }
}

extension NodeProfileView
{
    @IBAction func clickAction(sender: UIButton)
    {
        presenter.onClick(action: EProfileAction(rawValue: sender.tag)!)
    }
}
