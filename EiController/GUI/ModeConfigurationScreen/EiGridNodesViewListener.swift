//
//  EiGridNodesViewListener.swift
//  EiController
//
//  Created by Genrih Korenujenko on 15.05.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

protocol EiGridNodesViewListener: NSObjectProtocol
{
    func select(model: EiGridNodeViewModel)
    func cancel()
}
