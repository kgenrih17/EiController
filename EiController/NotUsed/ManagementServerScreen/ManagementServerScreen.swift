//
//  ManagementServerScreen.swift
//  EiController
//
//  Created by Genrih Korenujenko on 17.05.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit
import RxSwift

class ManagementServerScreen: UIViewController, ManagementServerScreenInterface
{
    @IBOutlet var enableSwitch : Switch!
    ///
    @IBOutlet var switchsView : UIView!
    @IBOutlet var useToUpdateSwitch : Switch!
    @IBOutlet var useSFTPSwitch : Switch!
    ///
    @IBOutlet var ipViewView : UIView!
    @IBOutlet var ipTextField : UITextField!
    @IBOutlet var httpPortTextField : UITextField!
    @IBOutlet var sshPortTextField : UITextField!
    @IBOutlet var checkConnectionButton : UIButton!
    @IBOutlet var errorLabel : UILabel!
    ///
    @IBOutlet var esSettingsView : UIView!
    @IBOutlet var esTaskTimeoutTextField : UITextField!
    @IBOutlet var registrationTokenTextField : UITextField!
    
    var presenter : ManagementServerPresenter!
    
    @objc(initWithFingerprints:) init(fingerprints: [String])
    {
        super.init(nibName: String(describing: ManagementServerScreen.self), bundle: nil)
        self.presenter = ManagementServerPresenter.init(screen: self, interactor: interactor(), fingerprints: fingerprints)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        checkConnectionButton.imageView?.contentMode = .scaleAspectFit
        backButton.imageView?.contentMode = .scaleAspectFit
        presenter.onCreate()
    }
    
    func refresh(integration: DeviceIntegrationInfo)
    {
        enableSwitch.isOn = integration.isOn
        useToUpdateSwitch.isOn = integration.isUseUpdate
        useSFTPSwitch.isOn = integration.isUseSFTP
        ipTextField.text = integration.host
        httpPortTextField.text = integration.httpPort <= 0 ? "" : String(integration.httpPort)
        sshPortTextField.text = integration.sshPort <= 0 ? "" : String(integration.sshPort)
        esTaskTimeoutTextField.text = integration.esTaskCompletionTimeout <= 0 ? "" : String(integration.esTaskCompletionTimeout)
        registrationTokenTextField.text = integration.registrationToken
        refreshUserInteraction(isOn: integration.isOn)
    }
    
    func showMessage(_ message: String, color: UIColor)
    {
        errorLabel.text = message
        errorLabel.textColor = color
    }
    
    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let newValue = (textField.text != nil) ? textField.text! + string : string;
        if (textField == httpPortTextField || textField == sshPortTextField)
        {
            return presenter.isValidPort(newValue)
        }
        else if (textField == esTaskTimeoutTextField)
        {
        return presenter.isValidTimeout(newValue)
        }
        else if (textField == registrationTokenTextField)
        {
            return presenter.isValidToken(newValue)
        }
        return true;
    }
    
    @IBAction func changeEnable(sender: Switch)
    {
        if sender == enableSwitch
        {
            presenter.enableChanged(sender.isOn)
        }
    }
    
    @IBAction func checkConnection()
    {
        presenter.checkConnection(integration: prepareIntegration())
    }
    
    @IBAction func save()
    {
        presenter.save(integration: prepareIntegration())
    }
    
    private func refreshUserInteraction(isOn: Bool)
    {
        switchsView.isUserInteractionEnabled = isOn
        ipViewView.isUserInteractionEnabled = isOn
        esSettingsView.isUserInteractionEnabled = isOn
        if isOn
        {
            switchsView.alpha = 1
            ipViewView.alpha = 1
            esSettingsView.alpha = 1
        }
        else
        {
            switchsView.alpha = 0.5
            ipViewView.alpha = 0.5
            esSettingsView.alpha = 0.5
        }
    }
    
    private func prepareIntegration() -> DeviceIntegrationInfo
    {
        let result = DeviceIntegrationInfo()
        result.host = ipTextField.text
        result.registrationToken = registrationTokenTextField.text
        result.httpPort = Int(httpPortTextField.text!) != nil ? Int(httpPortTextField.text!)! : 0
        result.sshPort = Int(sshPortTextField.text!) != nil ? Int(sshPortTextField.text!)! : 0
        result.esTaskCompletionTimeout = Int(esTaskTimeoutTextField.text!) != nil ? Int(esTaskTimeoutTextField.text!)! : 0
        result.isOn = enableSwitch.isOn
        result.isUseUpdate = useToUpdateSwitch.isOn
        result.isUseSFTP = useSFTPSwitch.isOn
        return result
    }
}
