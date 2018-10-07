//
//  DeviceDetailsScreenNew.swift
//  EiController
//
//  Created by Henrikh Koreniuzhenko on 27.08.2018.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

class DeviceDetailsScreen: UIViewController
{
    @IBOutlet private var managementImageView : UIImageView!
    @IBOutlet private var reverseMonitoringImageView : UIImageView!
    @IBOutlet private var updateImageView : UIImageView!
    ///
    @IBOutlet private var nodeView : UIView!
    @IBOutlet private var nodeContainerView : UIView!
    @IBOutlet private var descriptionView : UIView!
    @IBOutlet private var nameLabel : UILabel!
    @IBOutlet private var iconImageView : UIImageView!
    @IBOutlet private var modelLabel : UILabel!
    @IBOutlet private var versionLabel : UILabel!
    @IBOutlet private var snLabel : UILabel!
    ///
    @IBOutlet private var editNameButton : UIButton!
    @IBOutlet private var editNameView : UIView!
    @IBOutlet private var editTitleLabel : UILabel!
    @IBOutlet private var editContainerView : UIView!
    @IBOutlet private var editNameTextField : UITextField!

    /// Title Bar
    @IBOutlet private var titleLabel : UILabel!
    @IBOutlet private var rightButton : UIButton!
    /// Content
    @IBOutlet private var contentView : UIView!
    @IBOutlet private var actionsView : UIView!
    @IBOutlet private weak var modeView : UIView?
    private var tabContentView: UIViewController?

    private var presenter : DeviceDetailsPresenter!
    @objc var actionInterface : IDeviceDetailsScreenAction?
    var viewModel: DeviceDetailsViewModel?
    
    @objc(initWithFingerprint:) init(fingerprint: String)
    {
        super.init(nibName: String(describing: DeviceDetailsScreen.self), bundle: nil)
        self.presenter = DeviceDetailsPresenter.init(interactor: self.interactor(), navigation: self.navigation(), fingerprint)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        for index in 0..<actionsView.subviews.count
        {
            if index == 0
            {
                getActionTopLineAt(index: index)?.isEnable = true
            }
            else
            {
                getActionTopLineAt(index: index)?.isEnable = false
            }
        }
        actionsView.subviews.first?.isEnable = false
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        presenter.onAttachView(self, listener: actionInterface)
        if !viewModel!.isController
        {
            actionsView.setNeedsLayout()
            modeView?.removeFromSuperview()
            modeView = nil
            actionsView.layoutIfNeeded()
            for item in actionsView.subviews
            {
                item.updateGradient()
                for line in item.subviews
                {
                    line.updateGradient()
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        presenter.onDettachView()
    }
    
    @objc(didUpdateDeviceInfo:) func didUpdateDeviceInfo(_ fingerprint: String)
    {
        presenter.onDidUpdateInfo(fingerprint)
    }
}

extension DeviceDetailsScreen: IDeviceDetailsScreen
{
    func fill(_ model: DeviceDetailsViewModel?)
    {
        viewModel = model
        titleLabel.text = model?.title
        
        iconImageView.image = model?.getModelIcon()
        modelLabel.text = model?.model
        nameLabel.text = model?.name
        snLabel.text = model?.sn
        versionLabel.text = model?.version

        nameLabel.textColor = model!.getNameColor()
        editTitleLabel.textColor = model!.getNameColor()
        editContainerView.backgroundColor = model!.getNodeBackgrondColor()
        versionLabel.textColor = model!.getVersionTextColor()
        versionLabel.backgroundColor = model!.getVersionBackgroundColor()
        nodeView.backgroundColor = model!.getNodeBackgrondColor()
        nodeContainerView.layer.borderColor = model!.getNodeBorderColor().cgColor
        nodeContainerView.layer.borderWidth = 1
        descriptionView.backgroundColor = model!.getNodeDescriptionBackgroundColor()
        if model!.isUserMode
        {
            let tabs : [EDetailsTab] = [.INTEGRATION_TAB,
                                        .NETWORK_SETTINGS_TAB,
                                        .RESTART_SCHEDULER_TAB,
                                        .MODE_TAB]
            disableActionButtonAt(tabs: tabs)
            editNameButton.isHidden = true
        }
        managementImageView.image = UIImage(named: viewModel!.managementConnectionImageName)
        reverseMonitoringImageView.image = UIImage(named: viewModel!.reverseMonitoringConnectionImageName)
        updateImageView.image = UIImage(named: viewModel!.updateConnectionImageName)
    }
    
    func showProfile(_ fingerprint: String)
    {
        addTabView(NodeProfileView.init(fingerprint: fingerprint))
        rightButton.isHidden = true
    }

    func showPerformance(_ fingerprint: String)
    {
        addTabView(NodePerformanceView.init(fingerprint: fingerprint))
        rightButton.isHidden = true
    }
    
    func showNetworkSettings(_ fingerprint: String)
    {
        let view = NodeNetworkSettingsView.init(fingerprints: [fingerprint])
        addTabView(view)
        refreshByNewTab(view: view)
    }
    
    func showIntegration(_ fingerprint: String)
    {
        let view = NodeIntegrationView.init(fingerprints: [fingerprint])
        addTabView(view)
        refreshByNewTab(view: view)
    }
    
    func showRestartScheduler(_ fingerprint: String)
    {
        let view = NodeRebootShutdownView.init(fingerprint: fingerprint)
        addTabView(view)
        refreshByNewTab(view: view)
    }
    
    func showMode(_ fingerprint: String)
    {
        let view = ModeConfigurationScreen.init(fingerprint: fingerprint)
        addTabView(view)
        view.removeTitle()
        view.setAccept(button: rightButton)
        rightButton.isHidden = true
    }
    
    func showLog(_ fingerprint: String)
    {
        let view = SyncLogScreen.init(presenterClass: DeviceSyncLogPresenter.self, fingerprint: fingerprint) as! SyncLogScreen & INodeDetailsTabAction
        addTabView(view)
        view.removeTitle()
        rightButton.isHidden = false
    }
    
    func updateImageBy(serverType: EIntegrationServerType)
    {
        switch serverType
        {
        case .MANAGEMENT:
            managementImageView.image = UIImage(named: viewModel!.managementConnectionImageName)
        case .REVERSE_MONITORING:
            reverseMonitoringImageView.image = UIImage(named: viewModel!.reverseMonitoringConnectionImageName)
        case .UPDATE:
            updateImageView.image = UIImage(named: viewModel!.updateConnectionImageName)
        }
    }
}

private extension DeviceDetailsScreen
{
    func refreshByNewTab(view: UIViewController & INodeDetailsTabAction)
    {
        rightButton.setImage(UIImage.init(named: view.getRightButtonActiveIconName()), for: .normal)
        rightButton.setImage(UIImage.init(named: view.getRightButtonIconName()), for: .disabled)
        view.removeTitle()
        view.setAccept(button: rightButton)
        rightButton.isHidden = false
    }
    
    func clearTabContainer()
    {
        if let content = tabContentView
        {
            content.view.removeFromSuperview()
            content.willMove(toParentViewController: nil)
            content.removeFromParentViewController()
            tabContentView = nil
        }
    }
    
    func addTabView(_ controller: UIViewController)
    {
        clearTabContainer()
        tabContentView = controller
        addChildViewController(controller)
        contentView.addSubview(controller.view)
        controller.didMove(toParentViewController: self)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        view.setNeedsLayout()
        controller.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        controller.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        controller.view.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        controller.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        view.layoutIfNeeded()
    }
    
    func getActionTopLineAt(index: Int) -> UIView?
    {
        let view = actionsView.subviews.filter { $0.tag == index }.first
        if view == nil
        {
            return nil
        }
        for item in view!.subviews
        {
            if (item as? UIImageView) == nil && (item as? UIButton) == nil
            {
                return item
            }
        }
        return nil
    }
    
    func disableActionButtonAt(tabs: [EDetailsTab])
    {
        let subviews = actionsView.subviews.filter { tabs.contains(EDetailsTab(rawValue: $0.tag)!) }
        for subview in subviews
        {
            for item in subview.subviews
            {
                if (item as? UIImageView) != nil
                {
                    item.alpha = 0.5
                }
                else if (item as? UIButton) != nil
                {
                    item.isEnable = false
                }
            }
        }
    }
}

extension DeviceDetailsScreen: UIScrollViewDelegate
{
//    func scrollViewDidScroll(_ scrollView: UIScrollView)
//    {
//        if model.isCanRefresh
//        {
//            let indent : CGFloat = 5
//            let height = -updateView.frame.height
//            if scrollView.contentOffset.y <= height - indent
//            {
//                presenter.onRefreshInfo(model)
//                scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
//                if !model.isCanRefresh
//                {
//                    scrollView.setContentOffset(.zero, animated: true)
//                    scrollView.isScrollEnabled = model.isCanRefresh
//                }
//            }
//        }
//    }
}

extension DeviceDetailsScreen /// Actions
{
    @IBAction func selectTab(_ sender: UIButton)
    {
        let tab = EDetailsTab.init(rawValue: sender.tag)!
        presenter.onSelectTab(tab)
    
        let disableView = actionsView.subviews.filter { $0.isEnable == false }.first
        if let view = disableView
        {
            let disableImageView = view.subviews.filter { ($0 as? UIImageView) != nil }.first as? UIImageView
            disableImageView?.image = viewModel!.getImageFor(tab: EDetailsTab(rawValue: view.tag)!)
            getActionTopLineAt(index: view.tag)?.isEnable = false
            view.isEnable = true
        }
        let enableView = sender.superview!
        let enableImageView = enableView.subviews.filter { ($0 as? UIImageView) != nil }.first as? UIImageView
        enableImageView?.image = viewModel!.getImageFor(tab: EDetailsTab(rawValue: enableView.tag)!)
        getActionTopLineAt(index: enableView.tag)?.isEnable = true
        enableView.isEnable = false
    }
    
    @IBAction func clickRight(_ sender: UIButton)
    {
        if let tab = tabContentView as? INodeDetailsTabAction
        {
            tab.clickSave()
        }
    }

    @IBAction func swipeContent(_ sender: UISwipeGestureRecognizer)
    {
        if sender.direction == .left
        {
            presenter.onSwipe(.SWIPE_FROM_RIGHT_TO_LEFT)
        }
        else
        {
            presenter.onSwipe(.SWIPE_FROM_LEFT_TO_RIGHT)
        }
    }
    
    @IBAction func clickEdit(_ sender: UIButton)
    {
        navigation().show(editNameView)
        editNameView.isHidden = false
        editNameTextField.text = viewModel?.name
    }
    
    @IBAction func clickEditSave(_ sender: UIButton)
    {
        editNameView.removeFromSuperview()
        editNameView.isHidden = true
        presenter.onClickSave(title: editNameTextField.text!)
    }
    
    @IBAction func clickEditClose(_ sender: UIButton)
    {
        editNameView.isHidden = true
        editNameView.removeFromSuperview()
    }
}
