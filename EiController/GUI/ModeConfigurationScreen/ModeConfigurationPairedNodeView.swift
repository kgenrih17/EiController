//
//  ModeConfigurationPairedNodeView.swift
//  EiController
//
//  Created by Genrih Korenujenko on 15.05.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

class ModeConfigurationPairedNodeView: UIView
{
    @IBOutlet var nodeView : UIView!
    @IBOutlet var titleLabel : UILabel!
    @IBOutlet var ipLabel : UILabel!
    @IBOutlet var snLabel : UILabel!
    @IBOutlet var modelLabel : UILabel!
    @IBOutlet var osVersionLabel : UILabel!
    @IBOutlet var statusImageView : UIImageView!
    @IBOutlet var modelIcon : UIImageView!
    @IBOutlet var disconnectButton : UIButton!
    @IBOutlet var refreshButton : UIButton!
    
    var listener : ModeConfigurationPairedNodeViewListener?
    
    class func build<T: ModeConfigurationPairedNodeView>(listener: ModeConfigurationPairedNodeViewListener) -> T
    {
        let result = Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
        result.listener = listener
        return result
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        disconnectButton.imageView?.contentMode = .scaleAspectFit
        refreshButton.imageView?.contentMode = .scaleAspectFit
    }
    
    public func load(model: EiGridNodeViewModel)
    {
        titleLabel.text = model.title.isEmpty ? "N/A" : model.title
        titleLabel.textColor = model.getNameColor()
        ipLabel.text = model.ip.isEmpty ? "N/A" : model.ip
        snLabel.text = model.sn().isEmpty ? "N/A" : model.sn()
        modelLabel.text = model.model.isEmpty ? "N/A" : model.model
        osVersionLabel.text = model.osVersion.isEmpty ? "N/A" : model.osVersion
        osVersionLabel.textColor = model.getVersionTextColor()
        osVersionLabel.backgroundColor = model.getVersionBackgroundColor()
        nodeView.backgroundColor = model.getNodeContainerColor()
        statusImageView.image = model.statusImage
        modelIcon.image = model.image
    }
    
    @IBAction func disconnect()
    {
        listener?.disconnectNode()
    }
    
    @IBAction func refresh()
    {
        listener?.refreshNode()
    }
}
