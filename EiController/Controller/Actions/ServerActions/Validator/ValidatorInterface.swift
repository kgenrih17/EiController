//
//  ValidatorInterface.swift
//  EiController
//
//  Created by Genrih Korenujenko on 11.04.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

protocol ValidatorInterface
{
    init(response : Any?)
    func isValid() -> Bool
    func getError() -> String
}
