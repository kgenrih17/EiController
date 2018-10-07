//
//  ModeConfigurationNodePairingView.swift
//  EiController
//
//  Created by Genrih Korenujenko on 15.05.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

enum ENodePairingType : Int
{
    case SERIAL_NUMBER
    case GRIDE_NODE
}

class ModeConfigurationNodePairingView: UIView, UITextFieldDelegate
{
    @IBOutlet var snGradientLabel : GradientLabel!
    @IBOutlet var snButton : UIButton!
    @IBOutlet var snLineView : UIView!
    @IBOutlet var snView : UIView!
    @IBOutlet var snTextField : UITextField!
    
    @IBOutlet var gridNodeGradientLabel : GradientLabel!
    @IBOutlet var gridNodeButton : UIButton!
    @IBOutlet var gridNodeLineView : UIView!
    @IBOutlet var gridNodeView : UIView!
    
    @IBOutlet var nodeModelLabel : UILabel!
    @IBOutlet var nodeTitleLabel : UILabel!
    @IBOutlet var nodeIPLabel : UILabel!
    @IBOutlet var nodeSNLabel : UILabel!
    @IBOutlet var nodeVersionLabel : UILabel!
    @IBOutlet var nodeIconImageView : UIImageView!

    @IBOutlet var emptyModelButton : UIButton!
    
    @IBOutlet var pairNodeButton : UIButton!
    
    var listener : ModeConfigurationNodePairingViewListener?
    weak var viewModel: EiGridNodeViewModel?

    class func build<T: ModeConfigurationNodePairingView>(listener: ModeConfigurationNodePairingViewListener) -> T
    {
        let result = Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
        result.listener = listener
        return result
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        pairNodeButton.imageView?.contentMode = .scaleAspectFit
        snButton.tag = ENodePairingType.SERIAL_NUMBER.rawValue
        gridNodeButton.tag = ENodePairingType.GRIDE_NODE.rawValue
        changeType(sender: snButton)
    }
    
    public func load(model: EiGridNodeViewModel?, sn: String?)
    {
        viewModel = model
        if AppStatus.isExtendedMode()
        {
            gridNodeLineView.disableColor = UIColor.init(red: 0.933, green: 0.933, blue: 0.933, alpha: 1)
            snLineView.disableColor = UIColor.init(red: 0.933, green: 0.933, blue: 0.933, alpha: 1)
            gridNodeView.backgroundColor = UIColor.white
        }
        else
        {
            gridNodeLineView.disableColor = UIColor.init(red: 0.314, green: 0.302, blue: 0.384, alpha: 1)
            snLineView.disableColor = UIColor.init(red: 0.314, green: 0.302, blue: 0.384, alpha: 1)
            gridNodeView.backgroundColor = UIColor.hex("545167")
        }
        snTextField.text = sn
        nodeTitleLabel.text = String.valueOrNA(model?.title)
        nodeTitleLabel.textColor = (model != nil) ? model!.textColor : UIColor.white
        nodeIPLabel.text = String.valueOrNA(model?.ip)
        nodeSNLabel.text = String.valueOrNA(model?.sn())
        nodeModelLabel.text = String.valueOrNA(model?.model)
        nodeVersionLabel.text = String.valueOrNA(model?.osVersion)
        nodeIconImageView.image = model?.image
        if model == nil
        {
            snButton.isSelected = false
            changeType(sender: snButton)
        }
        else
        {
            gridNodeButton.isSelected = false
            changeType(sender: gridNodeButton)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return false
    }
    
    @IBAction func pairNode()
    {
        listener?.pairNode(sn: snButton.isSelected ? snTextField.text : nil)
    }
    
    @IBAction func changeNode()
    {
        listener?.showNodesList()
    }
    
    @IBAction func changeType(sender: UIButton)
    {
        if !sender.isSelected
        {
            switch ENodePairingType(rawValue: sender.tag)!
            {
            case .SERIAL_NUMBER:
                gridNodeGradientLabel.isEnabled = false
                gridNodeButton.isSelected = false
                gridNodeLineView.isEnable = false
                gridNodeView.isHidden = true
                snGradientLabel.isEnabled = true
                snButton.isSelected = true
                snLineView.isEnable = true
                snView.isHidden = false
                emptyModelButton.isHidden = true
            case .GRIDE_NODE:
                gridNodeButton.isSelected = true
                gridNodeLineView.isEnable = true
                gridNodeView.isHidden = false
                gridNodeGradientLabel.isEnabled = true
                snGradientLabel.isEnabled = false
                if viewModel != nil
                {
                    gridNodeView.isHidden = false
                    emptyModelButton.isHidden = true
                }
                else
                {
                    gridNodeView.isHidden = true
                    emptyModelButton.isHidden = false
                }
                snButton.isSelected = false
                snLineView.isEnable = false
                snView.isHidden = true
            }
        }
    }
}
