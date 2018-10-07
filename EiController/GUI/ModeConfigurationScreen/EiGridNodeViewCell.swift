//
//  EiGridNodeViewCell.swift
//  EiController
//
//  Created by Genrih Korenujenko on 15.05.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

class EiGridNodeViewCell: UITableViewCell
{
    @IBOutlet var deviceView : UIView!
    @IBOutlet var descView : UIView!
    @IBOutlet var titleLabel : UILabel!
    @IBOutlet var ipLabel : UILabel!
    @IBOutlet var snLabel : UILabel!
    @IBOutlet var versionLabel : UILabel!
    @IBOutlet var modelLabel : UILabel!
    @IBOutlet var iconImageView : UIImageView!
    
    class func build<T: EiGridNodeViewCell>() -> T
    {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        let view = UIView()
        view.backgroundColor = UIColor.clear
        selectedBackgroundView = view
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        updateGradients()
    }
    
    public func load(model: EiGridNodeViewModel)
    {
        descView.fillHorizontalGradient()
        descView.setColors([model.getNodeContainerColor(), model.getNodeContainerColor()])
        deviceView.fillHorizontalGradient()
        deviceView.setColors([UIColor.hex("FFFFFF"), UIColor.hex("DADADC")])
        titleLabel.text = String.valueOrNA(model.title)
        titleLabel.textColor = model.textColor
        ipLabel.text = String.valueOrNA(model.ip)
        snLabel.text = String.valueOrNA(model.sn())
        versionLabel.text = String.valueOrNA(model.osVersion)
        versionLabel.textColor = model.getVersionTextColor()
        versionLabel.backgroundColor = model.getVersionBackgroundColor()
        modelLabel.text = String.valueOrNA(model.model)
        iconImageView.image = model.image
        setNeedsLayout()
        layoutIfNeeded()
        updateGradients()
    }
    
    func updateGradients()
    {
        descView.updateGradient()
        descView.radius = 2
        deviceView.updateGradient()
        deviceView.radius = 2
    }
}
