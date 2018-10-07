//
//  UIImage+ModelIcon.swift
//  EiController
//
//  Created by Henrikh Koreniuzhenko on 28.09.2018.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

private let IOS_ICON_NAME = "icon_model_ios_big.png"
private let ANDROID_ICON_NAME = "icon_model_android_big.png"

extension UIImage
{
    class func nodeIconBy(model: String?) -> UIImage
    {
        let imageName = getImageNameBy(model: model)
        var result : UIImage?
        if imageName != nil
        {
            if let jpgImage = UIImage.init(named: imageName!.appending(".jpg").lowercased())
            {
                result = jpgImage
            }
            else if let pngImage = UIImage.init(named: imageName!.appending(".png").lowercased())
            {
                result = pngImage
            }
        }
        return result == nil ? UIImage.init(named: "icon_model_unknown.png")! : result!
    }
    
    class private func getImageNameBy(model: String?) -> String?
    {
        var imageName : String?
        let androidModels = ["asme_android", "asme_appliance_android", "asme_tablet_android", "asme_aio_android"]
        let iosModels = ["iPad", "iOS"]
        if let lModel = model, !lModel.isEmpty
        {
            for modelName in androidModels
            {
                if lModel.contains(modelName)
                {
                    imageName = "icon_model_android_big"
                }
            }
            for modelName in iosModels
            {
                if lModel.contains(modelName)
                {
                    imageName = "icon_model_ios_big"
                }
            }
            if imageName == nil
            {
                imageName = "icon_model_\(lModel)_big" /// Appliance
            }
        }
        return imageName
    }
}

