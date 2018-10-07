//
//  ENodeListPage.swift
//  EiController
//
//  Created by Henrikh Koreniuzhenko on 03.09.2018.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

@objc enum ENodeListPage: Int
{
    case NODE_PAGE
    case CONTROLLER_PAGE
    case NOT_SUPPORTED_PAGE
    static let maxValue = NOT_SUPPORTED_PAGE.rawValue /// Use maxValue for array range. maxValue == [].count
}
