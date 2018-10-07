//
//  UpdateServerScreenInterface.swift
//  EiController
//
//  Created by Genrih Korenujenko on 05.05.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

protocol UpdateServerScreenInterface: ScreenInterface
{
    func refresh(model : UpdateServerViewModel)
    func setFieldColor(color : UIColor)
}
