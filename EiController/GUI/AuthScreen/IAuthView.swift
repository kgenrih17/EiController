//
//  IAuthView.swift
//  EiController
//
//  Created by Henrikh Koreniuzhenko on 13.09.2018.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

protocol IAuthView: ScreenInterface
{
    func fill(_ model: AuthViewModel)
    func retrieveChanges()
    func showPinTab()
    func showLoginTab()
    func showExtenderView()
    func showServiceView()
    func hidePinKeyboard()
    func updatePin(_ pin: String)
}
