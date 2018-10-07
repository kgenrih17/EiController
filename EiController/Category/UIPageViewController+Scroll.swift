//
//  UIPageViewController+Scroll.swift
//  EiController
//
//  Created by Henrikh Koreniuzhenko on 26.09.2018.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

extension UIPageViewController
{
    var isScrollEnabled: Bool
    {
        get
        {
            var isEnabled: Bool = true
            for view in view.subviews
            {
                if let subView = view as? UIScrollView
                {
                    isEnabled = subView.isScrollEnabled
                }
            }
            return isEnabled
        }
        set
        {
            for view in view.subviews
            {
                if let subView = view as? UIScrollView
                {
                    subView.isScrollEnabled = newValue
                }
            }
        }
    }
}
