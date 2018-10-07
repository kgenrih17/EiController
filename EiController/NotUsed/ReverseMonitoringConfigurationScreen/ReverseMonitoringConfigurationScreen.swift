//
//  ReverseMonitoringConfigurationScreen.swift
//  EiController
//
//  Created by Genrih Korenujenko on 05.05.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

class ReverseMonitoringConfigurationScreen: UIViewController, ReverseMonitoringConfigurationScreenInterface
{
    @IBOutlet var enableSwitch: Switch!
    @IBOutlet var addressTextField: UITextField!
    @IBOutlet var addressView: UIView!
    @IBOutlet var addressContentView: UIView!
    @IBOutlet var checkConnectionButton: UIButton!
    @IBOutlet var errorLabel: UILabel!
    var presenter : ReverseMonitoringConfigurationPresenter!
    var value : Int = 0

    @objc(initWithFingerprints:) init(fingerprints: [String])
    {
        super.init(nibName: "ReverseMonitoringConfigurationScreen", bundle: nil)
        self.presenter = ReverseMonitoringConfigurationPresenter.init(screen: self, interactor: interactor(), fingerprints: fingerprints)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        checkConnectionButton.imageView?.contentMode = .scaleAspectFit
        presenter.onCreate()
    }
    
    func refresh(model: ReverseMonitoringConfigurationViewModel)
    {
        enableSwitch.isOn = model.isEnable
        checkConnectionButton.isEnabled = model.isEnable
        addressContentView.isUserInteractionEnabled = model.isEnable
        addressTextField.text = model.address
        errorLabel.text = model.message
        errorLabel.textColor = model.messageColor
        if enableSwitch.isOn
        {
            addressContentView.alpha = 1.0
            checkConnectionButton.alpha = 1.0
        }
        else
        {
            addressContentView.alpha = 0.5
            checkConnectionButton.alpha = 0.5
        }
    }
    
    func setFieldColor(color : UIColor)
    {
        addressView.layer.borderColor = color.cgColor
    }
    
    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let value : String = (textField.text != nil) ? textField.text! + string : string
        checkConnectionButton.isEnabled = value.count > 0
        return true
    }
    
    @IBAction func changeSwitch(sender: Switch)
    {
        presenter.changeEnableFlag(model: prepareModel())
    }
    
    @IBAction func checkConnection()
    {
        presenter.checkConnection(model: prepareModel())
    }
    
    @IBAction func save()
    {
        presenter.save(model: prepareModel())
    }
    
    private func prepareModel() -> ReverseMonitoringConfigurationViewModel
    {
        return ReverseMonitoringConfigurationViewModel.init(isEnable: enableSwitch.isOn, address: addressTextField.text)
    }
}
