//
//  File.swift
//  EiController
//
//  Created by Genrih Korenujenko on 17.07.2018.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: Switch {
    
    /// Reactive wrapper for `isOn` property.
    public var isOn: ControlProperty<Bool> {
        return value
    }
    
    /**
     Reactive wrapper for `isOn` property.
     
     **⚠️ Versions prior to iOS 10.2 were leaking `UISwitch`s, so on those versions
     underlying observable sequence won't complete when nothing holds a strong reference
     to UISwitch.⚠️**
     */
    public var value: ControlProperty<Bool> {
        return base.rx.controlPropertyWithDefaultEvents(
            getter: { uiSwitch in
                uiSwitch.isOn
        }, setter: { uiSwitch, value in
            uiSwitch.isOn = value
        }
        )
    }
    
    internal func controlPropertyWithDefaultEvents<T>(
        editingEvents: UIControlEvents = [.allEditingEvents, .valueChanged, .touchUpInside],
        getter: @escaping (Base) -> T,
        setter: @escaping (Base, T) -> ()
        ) -> ControlProperty<T> {
        return controlProperty(
            editingEvents: [.allEditingEvents, .valueChanged, .touchUpInside],
            getter: getter,
            setter: setter
        )
    }
}

