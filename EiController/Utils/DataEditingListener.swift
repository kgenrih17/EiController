//
//  DataEditingListener.swift
//  Additions
//
//  Created by Henrikh Koreniuzhenko on 05.10.2018.
//  Copyright © 2018 Koreniuzhenko Henrikh. All rights reserved.
//

import UIKit

typealias ControlItem = (isEnabled: Bool, value: AnyHashable)

class DataEditingListener
{
    weak var listeningView : UIView!
    {
        didSet
        {
            checkView()
        }
    }
    var subcontrols = [UIControl]()
    var values = [UIControl:ControlItem]()
    var callBack : ((UIControl,Bool) -> Void)?
    
    init(view: UIView, valueChanged: ((UIControl,Bool) -> Void)?)
    {
        listeningView = view
        callBack = valueChanged
        load()
    }
    
    func checkView()
    {
        if listeningView == nil || listeningView.superview == nil
        {
            removeSubcontrols()
        }
    }
    
    func removeSubcontrols()
    {
        for control in subcontrols
        {
            control.removeTarget(self, action: #selector(valueChange(sender:)), for: .valueChanged)
        }
        subcontrols.removeAll()
        values.removeAll()
    }
    
    func isChanged() -> Bool
    {
        var result = true
        let currentValues = getValues()
        for subcontrol in currentValues
        {
            let isContaint = values.contains(where: { (item) -> Bool in
                if (item.key == subcontrol.key)
                {
                    let controlItem = item.value
                    let control = subcontrol.value
                    return (controlItem.isEnabled == control.isEnabled && controlItem.value == control.value)
                }
                else
                {
                    return false
                }
            })
            if !isContaint
            {
                result = false
                break
            }
        }
        return !result
    }
}

private extension DataEditingListener
{
    func load()
    {
        if !subcontrols.isEmpty
        {
            removeSubcontrols()
        }
        subcontrols.append(contentsOf: prepareSubcontrolsFrom(view: listeningView))
        values = getValues()
    }
    
    func prepareSubcontrolsFrom(view: UIView) -> [UIControl]
    {
        var controls = [UIControl]()
        var subcontrols = [UIControl]()
        for subview in view.subviews
        {
            if let control = subview as? UIControl
            {
                if (control as? UITextField) != nil || (control as? UIDatePicker) != nil
                {
                    control.addTarget(self, action: #selector(valueChange(sender:)), for: .editingChanged)
                }
                else if (control as? UIButton) != nil || (control as? Switch) != nil || (control as? UISegmentedControl) != nil
                {
                    control.addTarget(self, action: #selector(valueChange(sender:)), for: .touchUpInside)
                }
                else if control.allControlEvents.contains(.valueChanged)
                {
                    control.addTarget(self, action: #selector(valueChange(sender:)), for: .valueChanged)
                }
                else if control.allControlEvents.contains(.editingChanged)
                {
                    control.addTarget(self, action: #selector(valueChange(sender:)), for: .editingChanged)
                }
                controls.append(control)
            }
            else
            {
                subcontrols.append(contentsOf: prepareSubcontrolsFrom(view: subview))
            }
        }
        controls.append(contentsOf: subcontrols)
        return controls
    }
    
    @objc func valueChange(sender: UIControl)
    {
        callBack?(sender, isChanged())
    }
    
    func getValues() -> [UIControl:ControlItem]
    {
        var values = [UIControl:ControlItem]()
        for control in subcontrols
        {
            let value : ControlItem!
            if let item = control as? UITextField
            {
                value = ControlItem(item.isEnabled, item.text ?? "")
            }
            else if let item = control as? UIButton
            {
                value = ControlItem(item.isEnabled, item.isSelected)
            }
            else if let item = control as? UISwitch
            {
                value = ControlItem(item.isEnabled, item.isOn)
            }
            else if let item = control as? UISegmentedControl
            {
                value = ControlItem(item.isEnabled, item.selectedSegmentIndex)
            }
            else if let item = control as? UISlider
            {
                value = ControlItem(item.isEnabled, item.value)
            }
            else if let item = control as? UIDatePicker
            {
                value = ControlItem(item.isEnabled, item.date.timeIntervalSince1970)
            }
            else if let item = control as? Switch
            {
                value = ControlItem(item.isEnabled, item.isOn)
            }
            else
            {
                value = ControlItem(control.isEnabled, 0)
            }
            values[control] = value
        }
        return values
    }
}
