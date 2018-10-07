//
//  IDeviceDetailsScreenAction.swift
//  EiController
//
//  Created by Henrikh Koreniuzhenko on 27.08.2018.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

@objc protocol IDeviceDetailsScreenAction: NSObjectProtocol
{
    func refreshDetailsFor(_ fingerprint: String)
    func didSwipe(_ swipe: ESwipeDirection, fingerprint: String)
}
