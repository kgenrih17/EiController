//
//  NodeInfoCell.swift
//  EiController
//
//  Created by Henrikh Koreniuzhenko on 02.09.2018.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

private let DEFAULT_RIGHT_LOG_VIEW_INDENT: CGFloat = 88
private let DEFAULT_LEFT_INDENT: CGFloat = 9

class NodeInfoCell: UITableViewCell
{
    @IBOutlet var restartNodeButton: UIButton!
    @IBOutlet var restartPlaybackButton: UIButton!
    @IBOutlet var rebootAndShutdownButton: UIButton!
    @IBOutlet var syncWithCentralView: UIView?
    @IBOutlet var syncWithCentralButton: UIButton?
    @IBOutlet var deviceViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet var deviceView: UIView!
    @IBOutlet var applianceName: UILabel!
    @IBOutlet var serialNumber: UILabel!
    @IBOutlet var versionLabel: UILabel!
    @IBOutlet var modelLabel: UILabel!
    @IBOutlet var applianceView: UIView!
    @IBOutlet var descriptionView: UIView!
    @IBOutlet var applianceImg: UIImageView!
    @IBOutlet var actionBackgroundView: UIView!
    @IBOutlet var uploadImageView: UIImageView!
    @IBOutlet var selectedImageView: UIImageView!
    
    /// Sync Info
    @IBOutlet var syncView: UIView!
    @IBOutlet var syncIconImageView: UIImageView!
    @IBOutlet var syncMessageLabel: UILabel!
    
    ///
    @IBOutlet var swipeLeftGestureRecognizer: UISwipeGestureRecognizer!
    @IBOutlet var swipeRightGestureRecognizer: UISwipeGestureRecognizer!
    @IBOutlet var actions: [UIButton]!
    @IBOutlet var showDetailsButton: UIButton!
    
    var slidePoint: CGFloat = 0.0

    weak var actionInterface: INodeInfoCellAction?
    var model: NodeListCellViewModel?
    
    // MARK: - Init
    static func build() -> NodeInfoCell
    {
        return Bundle.main.loadNibNamed(String.init(describing: NodeInfoCell.self), owner: self, options: nil)![0] as! NodeInfoCell
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        syncWithCentralButton!.tag = EDeviceCommanTag.SYNC_WITH_EI_CENTRAL_TAG.rawValue
        restartNodeButton.tag = EDeviceCommanTag.RESTART_NODE_TAG.rawValue
        restartPlaybackButton.tag = EDeviceCommanTag.RESTART_PLAYBACK_TAG.rawValue
        rebootAndShutdownButton.tag = EDeviceCommanTag.REBOOT_AND_SHUTDOWN_TAG.rawValue
        showDetailsButton.tag = EDeviceCommanTag.GET_INFO_TAG.rawValue
    }
    
    // MARK: - Public Methods
    func fill(_ viewModel: NodeListCellViewModel)
    {
        model = viewModel
        applianceName.text = model!.title
        applianceName.textColor = model!.getTitleColor()
        serialNumber.text = model!.serialNumber
        versionLabel.text = model!.version
        versionLabel.textColor = model!.getVersionColor()
        versionLabel.backgroundColor = model!.getVersionBackgroundColor()
        modelLabel.text = model!.model
        applianceImg.image = model!.getIcon()
        uploadImageView.image = model!.getUpdateIcon()
        syncMessageLabel.text = model!.syncMessage
        syncMessageLabel.textColor = model!.getSyncColor()
        syncIconImageView.image = model!.getSyncIcon()
        isUserInteractionEnabled = model!.isUserInteractionEnabled
        restartNodeButton.isEnabled = model!.isEnableCommands
        restartPlaybackButton.isEnabled = model!.isEnableCommands
        rebootAndShutdownButton.isEnabled = model!.isEnableCommands
        syncWithCentralButton?.isEnabled = (model!.isEnableCommands && model!.isReadyToBeUpdated)
        showDetailsButton.isEnabled = model!.isEnableCommands
        descriptionView.backgroundColor = model!.getBackgroundColor()
    }

    func prepareGUI()
    {
        syncView.isHidden = !model!.isShowSyncMessage
        uploadImageView.isHidden = !model!.isReadyToBeUpdated
        syncWithCentralButton?.isEnabled = model!.isReadyToBeUpdated
        let isEnableOperations = model!.isEnableCommands
        swipeLeftGestureRecognizer?.isEnabled = isEnableOperations
        swipeRightGestureRecognizer?.isEnabled = isEnableOperations
        setNeedsLayout()
        if let view = syncWithCentralView, !model!.swipeCommands.contains(.SYNC_WITH_EI_CENTRAL_TAG)
        {
            view.removeFromSuperview()
            syncWithCentralView = nil
            if let button = syncWithCentralButton, let index = actions.index(of: button)
            {
                actions.remove(at: index)
                syncWithCentralButton = nil
            }
        }
        actionBackgroundView.isHidden = !model!.isShowedActions
        deviceViewLeftConstraint.isActive = !model!.isShowedActions
        layoutIfNeeded()
        actionBackgroundView.updateGradient()
    }
    
    func changeSelectedState()
    {
        model?.isSelected = !model!.isSelected
        if model!.isSelected
        {
            descriptionView.fillHorizontalGradient()
            selectedImageView.isHidden = false
        }
        else
        {
            descriptionView.setColors([model!.getBackgroundColor(), model!.getBackgroundColor()])
            descriptionView.lineWidth = 0
            selectedImageView.isHidden = true
        }
        versionLabel.backgroundColor = model!.getVersionBackgroundColor()
    }

    @IBAction func hideOperations()
    {
        actionInterface!.swipeHideCommands(model!)
        model!.isShowedActions = false
        setNeedsLayout()
        deviceViewLeftConstraint.isActive = true
        UIView.animate(withDuration: 0.3, animations: {
            self.layoutIfNeeded()
        }) { finished in
            self.actionBackgroundView.isHidden = true
        }
    }
    
    @IBAction func showOperations()
    {
        actionInterface!.swipeShowCommands(model!)
        model!.isShowedActions = true
        actionBackgroundView.isHidden = false
        setNeedsLayout()
        deviceViewLeftConstraint.isActive = false
        UIView.animate(withDuration: 0.3, animations: {
            self.layoutIfNeeded()
        })
    }
    
    @IBAction func didAction(_ sender: UIButton)
    {
        actionInterface?.onNodeCellAction(EDeviceCommanTag(rawValue: sender.tag)!, model: model!)
        hideOperations()
    }
}
