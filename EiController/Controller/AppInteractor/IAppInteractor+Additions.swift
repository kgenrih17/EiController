//
//  IAppInteractor+Additions.swift
//  EiController
//
//  Created by Henrikh Koreniuzhenko on 05.09.2018.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

extension AppInteractorInterface
{
    func getNodeStorage() -> INodeStorage
    {
        return self.nodeStorageInterface as! INodeStorage
    }
}
