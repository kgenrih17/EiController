//
//  CollectionProgressViewCell.swift
//  EiController
//
//  Created by Genrih Korenujenko on 10.05.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

class CollectionProgressViewCell: UICollectionViewCell
{
    @IBOutlet weak var titleLabel : GradientLabel!
    @IBOutlet weak var temperatureTitleLabel : UILabel!
    @IBOutlet weak var temperatureTrackView : UIView!
    @IBOutlet weak var temperatureProgressView : UIView!
    @IBOutlet var temperatureProgressWidthConstraint : NSLayoutConstraint!
    @IBOutlet weak var loadTitleLabel : UILabel!
    @IBOutlet weak var loadTrackView : UIView!
    @IBOutlet weak var loadProgressView : UIView!
    @IBOutlet var loadProgressWidthConstraint : NSLayoutConstraint!

    var viewModel: ProgressViewModel?
    
    class func build<T: CollectionProgressViewCell>() -> T
    {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        drawProgress(tackView: temperatureTrackView, progress: viewModel?.temperatureProgress, constr: temperatureProgressWidthConstraint)
        drawProgress(tackView: loadTrackView, progress: viewModel?.loadProgress, constr: loadProgressWidthConstraint)
        temperatureProgressView.updateGradient()
        loadProgressView.updateGradient()
    }
    
    func load(model: ProgressViewModel)
    {
        viewModel = model
        backgroundColor = model.getContainerColor()
        titleLabel.title = model.title
        temperatureTitleLabel.text = model.temperatureTitle
        temperatureTitleLabel.textColor = model.getProgressTitleColor()
        temperatureTrackView.backgroundColor = model.getTrackProgressColor()
        temperatureTrackView.layer.borderColor = model.getTrackProgressBorderColor().cgColor
        temperatureProgressView.setColors(model.temperatureColors)
        
        loadTitleLabel.text = model.loadTitle
        loadTitleLabel.textColor = model.getProgressTitleColor()
        loadTrackView.backgroundColor = model.getTrackProgressColor()
        loadTrackView.layer.borderColor = model.getTrackProgressBorderColor().cgColor
        loadProgressView.setColors(model.loadColors)
    }
    
    func drawProgress(tackView: UIView, progress: CGFloat?, constr: NSLayoutConstraint)
    {
        let trackWidth = tackView.frame.width
        let progressWidth : CGFloat!
        if let lProgress = progress, lProgress > 0
        {
            progressWidth = lProgress / CGFloat(100) * trackWidth
        }
        else
        {
            progressWidth = CGFloat(0)
        }
        constr.constant = progressWidth > trackWidth ? trackWidth : progressWidth
    }
}
