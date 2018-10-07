//
//  AuthPresenter.swift
//  EiController
//
//  Created by Henrikh Koreniuzhenko on 13.09.2018.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

private let PIN_CLEAR_PIN_TAG: Int = 100
private let PIN_DELETE_BUTTON_TAG: Int = 101
private let PIN_ENTER_BUTTON_TAG: Int = 102
private let CF_BUNDLE_SHORT_VERSION_KEY = "CFBundleShortVersionString"

class AuthPresenter: NSObject
{
    weak var view: IAuthView?
    weak var navigation: NavigationInterface?
    var interactor: AppInteractorInterface & AuthInterface
    var api: EiCentralAPI?
    var authManager: AuthManagerInterface?
    var viewModel: AuthViewModel!
    
    init(interactor : AppInteractorInterface & AuthInterface, navigation : NavigationInterface)
    {
        self.interactor = interactor
        self.navigation = navigation
        self.authManager = interactor.getAuthManager()
        super.init()
    }
    
    func onAttachView(_ view: IAuthView)
    {
        self.view = view
        createViewModel()
        view.showLoginTab()
        view.fill(viewModel)
        if viewModel.isAppModeSwitchOn
        {
            view.showServiceView()
        }
        else
        {
            view.showExtenderView()
        }
    }
    
    func onDettachView()
    {
        view = nil
    }
    
    func onClickMode(_ isOn: Bool)
    {
        if isOn
        {
            AppStatus.currect().mode = .SERVICE_MODE
            view?.showServiceView()
        }
        else
        {
            AppStatus.currect().mode = .EXTENDED_MODE
            view?.showExtenderView()
        }
    }
    
    func onClickLogin()
    {
        view?.retrieveChanges()
        AppStatus.currect().mode = viewModel.isAppModeSwitchOn ? .SERVICE_MODE : .EXTENDED_MODE
       var error: String? = nil
        if !viewModel.isAppModeSwitchOn
        {
            error = validateExtenderFields()
            if error == nil
            {
                view?.showProgress(withMessage: "Login...")
                authManager?.setConnectionData(createConnectionData())
                if viewModel!.isUsePin
                {
                    authByPin()
                }
                else
                {
                    authByLogin()
                }
            }
            else
            {
                view?.showAlert(withTitle: "Info", message: error)
            }
        }
        else
        {
            error = validate(login: viewModel.serviceUsername, password: viewModel.servicePassword)
            if error == nil
            {
                authManager?.auth(byLogin: viewModel.serviceUsername, password: viewModel.servicePassword) { errorText in
                    if errorText == nil
                    {
                        self.interactor.authIsSuccessful()
                    }
                    else
                    {
                        self.view?.showAlert(withTitle: "Info", message: errorText)
                    }
                }
            }
            else
            {
                self.view?.showAlert(withTitle: "Info", message: error)
            }
        }
    }
    
    func onClickCheckConnection()
    {
        view?.retrieveChanges()
        let error = validateHost()
        if error == nil
        {
            view?.showProgress(withMessage: "Connection...")
            api = EiCentralAPI.build(createConnectionData())
            api?.checkConnection({ (isSuccess) in
                self.parseCheckConnection(response: isSuccess)
            })
        }
        else
        {
            view?.showAlert(withTitle: "Info", message: error)
        }
    }
    
    func onClickPinTab()
    {
        view?.showPinTab()
    }
    
    func onClickLoginTab()
    {
        view?.showLoginTab()
    }
    
    func onEditing(pin: String, editing text: String?, tag: Int)
    {
        var newPin = pin
        if tag == PIN_CLEAR_PIN_TAG
        {
            newPin = ""
        }
        else if tag == PIN_DELETE_BUTTON_TAG
        {
            if !newPin.isEmpty
            {
                newPin.removeLast()
            }
        }
        else if tag == PIN_ENTER_BUTTON_TAG
        {
            view?.hidePinKeyboard()
        }
        else if newPin.count < 8
        {
            newPin += text!
        }
        view?.updatePin(newPin)
    }

}

private extension AuthPresenter
{
    func createViewModel()
    {
        let connectionData = CentralConnectionData.get()!
        let version = Bundle.main.infoDictionary?[CF_BUNDLE_SHORT_VERSION_KEY] as? String
        viewModel = AuthViewModel()
        viewModel.screenTitle = "[Ei] Link \(version ?? "")"
        viewModel.host = connectionData.host
        viewModel.port = String(connectionData.port)
        viewModel.isUseSSL = connectionData.isSupportSSL
        viewModel.isAppModeSwitchOn = AppStatus.isExtendedMode()
    }
    
    func validateExtenderFields() -> String?
    {
        var error = validateHost()
        if error == nil
        {
            if viewModel.companyID.isEmpty
            {
                error = "Please enter Company ID"
            }
            else if viewModel.isUsePin, viewModel.pin.isEmpty
            {
                error = "Please enter PIN"
            }
            else if !viewModel.isUsePin
            {
                error = validate(login: viewModel.extenderUsername, password: viewModel.extenderPassword)
            }
        }
        return error
    }
    
    func validate(login: String, password: String) -> String?
    {
        var error: String? = nil
        if login.isEmpty || password.isEmpty
        {
            error = "Please enter login and password"
        }
        return error
    }
    
    func validateHost() -> String?
    {
        var error: String? = nil
        if viewModel.host.isEmpty
        {
            error = "Please enter hostname"
        }
        return error
    }
    
    func createConnectionData() -> CentralConnectionData
    {
        return CentralConnectionData.create(withSSL: viewModel.isUseSSL, host: viewModel.host, port: viewModel.port.isEmpty ? 0 : Int(viewModel.port)!)
    }
    
    func parseCheckConnection(response: Bool)
    {
        view?.hideProgress()
        var message: String? = nil
        if response
        {
            message = "Connection with the Server was successfully established."
        }
        else
        {
            message = "A connection with the server cannot be established."
        }
        view?.showAlert(withTitle: "Info", message: message)
    }
    
    func authByPin()
    {
        authManager?.auth(byPin: viewModel.pin, companyID: viewModel.companyID) { error in
            self.parseAuth(error)
        }
    }
    
    func authByLogin()
    {
        authManager?.auth(byLogin: viewModel.extenderUsername, password: viewModel.extenderPassword, companyID: viewModel.companyID) { error in
            self.parseAuth(error)
        }
    }
    
    func parseAuth(_ error: String?)
    {
        view?.hideProgress()
        if error == nil
        {
            createConnectionData().save()
            interactor.authIsSuccessful()
        }
        else
        {
            view?.showAlert(withTitle: nil, message: error)
        }
    }
}
