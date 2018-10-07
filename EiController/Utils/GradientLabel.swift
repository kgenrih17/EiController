//
//  GradientLabel.swift
//  EiController
//
//  Created by Henrikh Koreniuzhenko on 16.09.2018.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

@IBDesignable
@objc class GradientLabel: UIView
{
    @IBInspectable var title: String = "" { didSet { updateText() }}
    @IBInspectable var alignment: Int = 1 { didSet { updateText() }}
    var label = UILabel()
    open var text: String? { get { return label.text } set { label.text = newValue } }
    open var font: UIFont! { get { return label.font } set { label.font = newValue } }
    open var textColor: UIColor? { get { return nil } set { } }
    open var textAlignment: NSTextAlignment { get { return label.textAlignment } set { label.textAlignment = newValue } }
    open var isEnabled: Bool { get { return label.isEnabled } set { label.isEnabled = newValue } }
    open var numberOfLines: Int { get { return label.numberOfLines } set { label.numberOfLines = newValue } }
    open var adjustsFontSizeToFitWidth: Bool { get { return label.adjustsFontSizeToFitWidth } set { label.adjustsFontSizeToFitWidth = newValue } }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.addSubview(label)
        label.font = UIFont.systemFont(ofSize: 14)
        label.backgroundColor = .clear
        label.frame = bounds
        label.numberOfLines = 0
        label.textAlignment = .center
        label.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        self.mask = label
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        updateText()
    }
    
    private func updateText()
    {
        label.textAlignment = NSTextAlignment.init(rawValue: alignment) ?? .center
        text = title
        let width = label.textSize().width / label.frame.width
        startLocation = Double(0.5 - width)
        endLocation = Double(0.5 + width)
    }
}

extension UILabel
{
    func textSize() -> CGSize
    {
        return NSString(string: text ?? "").boundingRect(with: CGSize(width: Double(bounds.width), height: .greatestFiniteMagnitude),
                                                         options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                         attributes: [NSAttributedStringKey.font: font],
                                                         context: nil).size
    }
}
