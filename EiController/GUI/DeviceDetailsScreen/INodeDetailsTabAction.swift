//
//  INodeDetailsTabAction.swift
//  EiController
//
//  Created by Henrikh Koreniuzhenko on 20.09.2018.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

@objc protocol INodeDetailsTabAction: NSObjectProtocol
{
    func clickSave()
    func getRightButtonIconName() -> String
    func getRightButtonActiveIconName() -> String
    func removeTitle()
    func setAccept(button: UIButton)
}
