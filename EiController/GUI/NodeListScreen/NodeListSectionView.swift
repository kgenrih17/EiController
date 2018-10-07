//
//  NodeListSectionView.swift
//  EiController
//
//  Created by Henrikh Koreniuzhenko on 02.09.2018.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

private let DEFAULT_DEVICE_LIST_HEADER_HEIGHT: CGFloat = 30.0
private let ADDITIONAL_DEVICE_LIST_HEADER_HEIGHT: CGFloat = 8.0

class NodeListSectionView: UIView
{
    @IBOutlet weak var titleGradientLabel: GradientLabel!
    @IBOutlet private var gradientWidthConstraint: NSLayoutConstraint!
    
    static func build(_ model: NodeListSectionViewModel) -> NodeListSectionView
    {
        let result = Bundle.main.loadNibNamed(String(describing: NodeListSectionView.self), owner: self, options: nil)?[0] as? NodeListSectionView
        result?.load(model)
        return result!
    }
    
    func load(_ model: NodeListSectionViewModel)
    {
        titleGradientLabel?.title = model.text!
    }
}
