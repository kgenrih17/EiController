//
//  AuthView.swift
//  EiController
//
//  Created by Henrikh Koreniuzhenko on 13.09.2018.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

/**
 192.168.101.74
 KMA-10
 1111
 
 central4test.evogence.net
 KMA-2
 1111 - admin_level
 789789 - user_level
*/

let pinkColor = UIColor.init(red: 1, green: 0.502, blue: 0.631, alpha: 1)
let purpleColor = UIColor.init(red: 0.678, green: 0.286, blue: 0.875, alpha: 1)

class AuthView: UIViewController
{
    private var presenter : AuthPresenter!
    private var viewModel : AuthViewModel?
    /// Top Bar
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var appModeSwitch: Switch!
    @IBOutlet weak var titleLabel: UILabel!
    /// Extender
    @IBOutlet weak var sslGradientView: UIView!
    @IBOutlet weak var sslSwitch: Switch!
    @IBOutlet weak var hostTextField: UITextField!
    @IBOutlet weak var portTextField: UITextField!
    @IBOutlet weak var companyTextField: UITextField!
    @IBOutlet weak var extenderUsernameTextField: UITextField!
    @IBOutlet weak var extenderPasswordTextField: UITextField!
    @IBOutlet weak var checkConnectionButton: UIButton!
    @IBOutlet weak var pinStackView: UIStackView!
    ///
    @IBOutlet weak var serviceUsernameTextField: UITextField!
    @IBOutlet weak var servicePasswordTextField: UITextField!
    ///
    @IBOutlet weak var authTabModeView: UIView!
    @IBOutlet weak var pinTabButton: UIButton!
    @IBOutlet weak var pinGradientLabel: GradientLabel!
    @IBOutlet weak var pinLineView: UIView!
    @IBOutlet weak var loginTabButton: UIButton!
    @IBOutlet weak var loginGradientLabel: GradientLabel!
    @IBOutlet weak var loginLineView: UIView!
    @IBOutlet weak var pinKeyboardButton: UIButton!
    @IBOutlet weak var pinCirclesStackView: UIStackView!
    @IBOutlet weak var pinKeyboardView: UIView!
    
    @IBOutlet var rightExtenderConstraint: NSLayoutConstraint!
    @IBOutlet var pinLeftConstraint: NSLayoutConstraint!
    @IBOutlet var pinRightConstraint: NSLayoutConstraint!
    @IBOutlet var pinTabBottomConstraint: NSLayoutConstraint!
    @IBOutlet var pinTabRightConstraint: NSLayoutConstraint!

    init()
    {
        super.init(nibName: String(describing: AuthView.self), bundle: nil)
        self.presenter = AuthPresenter.init(interactor: self.interactor(), navigation: self.navigation())
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        appModeSwitch.leftOnImage = UIImage(named: "auth_icon_inactive_service.png")
        appModeSwitch.leftOffImage = UIImage(named: "auth_icon_active_service.png")
        appModeSwitch.rightOnImage = UIImage(named: "auth_icon_active_extender.png")
        appModeSwitch.rightOffImage = UIImage(named: "auth_icon_inactive_extender.png")
        appModeSwitch.thumbView.fillHorizontalGradient()
        appModeSwitch.fillVertivaleBorderGradient()
        appModeSwitch.setColors([.clear])
        sslSwitch.leftLabel.font = UIFont.systemFont(ofSize: 13)
        sslSwitch.rightLabel.font = UIFont.systemFont(ofSize: 13)
        self.view.backgroundColor = UIColor.init(red: 0.137, green: 0.133, blue: 0.165, alpha: 1)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        presenter.onAttachView(self)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        let widthIndent : CGFloat = 18
        let width = pinKeyboardView.frame.width - widthIndent
        let defaultButtonsWidth : CGFloat = 192
        let indent : CGFloat = (width - defaultButtonsWidth) / 4
        view.setNeedsLayout()
        pinLeftConstraint.constant = indent
        pinRightConstraint.constant = indent
        view.layoutIfNeeded()
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        presenter.onDettachView()
    }
}

extension AuthView: IAuthView
{
    func fill(_ model: AuthViewModel)
    {
        self.viewModel = model
        titleLabel.text = model.screenTitle
        appModeSwitch.isOn = model.isAppModeSwitchOn
        sslSwitch.isOn = (viewModel?.isUseSSL)!
        companyTextField.text = viewModel?.companyID
        hostTextField.text = viewModel?.host
        portTextField.text = viewModel?.port
        extenderUsernameTextField.text = viewModel?.extenderUsername
        extenderPasswordTextField.text = viewModel?.extenderPassword
        serviceUsernameTextField.text = viewModel?.serviceUsername
        servicePasswordTextField.text = viewModel?.servicePassword
        updatePin(viewModel?.pin ?? "")
    }
    
    func retrieveChanges()
    {
        viewModel?.isAppModeSwitchOn = appModeSwitch.isOn
        viewModel?.isUseSSL = sslSwitch.isOn
        viewModel?.companyID = companyTextField.text!
        viewModel?.host = hostTextField.text!
        viewModel?.port = portTextField.text!
        viewModel?.extenderUsername = extenderUsernameTextField.text!
        viewModel?.extenderPassword = extenderPasswordTextField.text!
        viewModel?.serviceUsername = serviceUsernameTextField.text!
        viewModel?.servicePassword = servicePasswordTextField.text!
        viewModel?.isUsePin = pinTabButton.isSelected
    }
    
    func showPinTab()
    {
        pinTabButton.isSelected = true
        pinLineView.isEnable = true
        pinGradientLabel.isEnable = true
        loginTabButton.isSelected = false
        loginLineView.isEnable = false
        loginGradientLabel.isEnable = false
        view.setNeedsLayout()
        pinTabRightConstraint.isActive = true
        pinTabBottomConstraint.isActive = true
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    
    func showLoginTab()
    {
        loginTabButton.isSelected = true
        loginLineView.isEnable = true
        loginGradientLabel.isEnable = true
        pinTabButton.isSelected = false
        pinLineView.isEnable = false
        pinGradientLabel.isEnable = false
        view.setNeedsLayout()
        pinTabRightConstraint.isActive = false
        pinTabBottomConstraint.isActive = false
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    
    func showExtenderView()
    {
        view.setNeedsLayout()
        rightExtenderConstraint.isActive = false
        UIView.animate(withDuration: 0.15, animations: {
            self.view.backgroundColor = UIColor.init(red: 0.973, green: 0.973, blue: 0.973, alpha: 1)
            self.view.layoutIfNeeded()
        }) { _ in
            self.view.backgroundColor = UIColor.init(red: 0.973, green: 0.973, blue: 0.973, alpha: 1)
        }
    }
    
    func showServiceView()
    {
        view.setNeedsLayout()
        rightExtenderConstraint.isActive = true
        UIView.animate(withDuration: 0.15, animations: {
            self.view.backgroundColor = UIColor.init(red: 0.137, green: 0.133, blue: 0.165, alpha: 1)
            self.view.layoutIfNeeded()
        }) { _ in
            self.view.backgroundColor = UIColor.init(red: 0.137, green: 0.133, blue: 0.165, alpha: 1)
        }
    }
    
    @IBAction func hidePinKeyboard()
    {
        pinKeyboardView.isHidden = true
        if let pin = viewModel?.pin, pin.count == 0
        {
            pinKeyboardButton.setTitle("Press to enter PIN", for: .normal)
            pinCirclesStackView.isHidden = true
        }
        else
        {
            pinKeyboardButton.setTitle(nil, for: .normal)
            pinCirclesStackView.isHidden = false
        }
    }
    
    func updatePin(_ pin: String)
    {
        viewModel?.pin = pin
        for view in pinStackView.arrangedSubviews
        {
            pinStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        let height : CGFloat = 18
        for _ in 0..<pin.count
        {
            let view = UIView()
            view.fillHorizontalGradient()
            pinStackView.addArrangedSubview(view)
            view.heightAnchor.constraint(equalToConstant: height).isActive = true
            view.widthAnchor.constraint(equalToConstant: height).isActive = true
        }
        pinStackView.setNeedsLayout()
        pinStackView.layoutIfNeeded()
        for item in pinStackView.arrangedSubviews
        {
            item.radius = item.frame.height / CGFloat(2)
            item.updateGradient()
        }
    }
}

extension AuthView
{
    @IBAction func clickMode(sender: Switch)
    {
        presenter.onClickMode(sender.isOn)
        appModeSwitch.thumbView.fillHorizontalGradient()
        appModeSwitch.fillVertivaleBorderGradient()
        appModeSwitch.setColors([.clear])
    }

    @IBAction func clickLogin(sender: UIButton)
    {
        presenter.onClickLogin()
    }

    @IBAction func clickSSL(sender: Switch)
    {
        
    }
    
    @IBAction func clickCheckConnection(sender: UIButton)
    {
        presenter.onClickCheckConnection()
    }
    
    @IBAction func clickPinTab(sender: UIButton)
    {
        presenter.onClickPinTab()
    }
    
    @IBAction func clickLoginTab(sender: UIButton)
    {
        presenter.onClickLoginTab()
    }
    
    @IBAction func clickShowPinKeyboard(sender: UIButton)
    {
        pinKeyboardView.isHidden = false
    }
    
    @IBAction func clickPinEditing(sender: UIButton)
    {
        presenter.onEditing(pin: viewModel!.pin, editing: sender.titleLabel?.text, tag: sender.tag)
    }
}
