//
//  NodeNetworkSettingsView.swift
//  EiController
//
//  Created by Henrikh Koreniuzhenko on 21.09.2018.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

class NodeNetworkSettingsView: UIViewController
{
    @IBOutlet weak var acceptButton : UIButton!
    @IBOutlet weak var contentScrollView : UIScrollView!
    private var editingListener : DataEditingListener!
    
    @IBOutlet weak var titleView : UIView!
    @IBOutlet var containerTopConstraint : NSLayoutConstraint!
    
    @IBOutlet weak var topContainer : UIView!
    @IBOutlet weak var ethernetLabel : GradientLabel!
    @IBOutlet weak var ethernetButton : UIButton!
    @IBOutlet weak var ethernetLineView : UIView!
    @IBOutlet weak var wifiLabel : GradientLabel!
    @IBOutlet weak var wifiButton : UIButton!
    @IBOutlet weak var wifiLineView : UIView!
    
    @IBOutlet weak var wifiView : UIView!
    @IBOutlet var wifiTopConstraint : NSLayoutConstraint!
    @IBOutlet weak var statusSwitch : Switch!
    @IBOutlet weak var preferredSwitch : Switch!
    @IBOutlet weak var ssidTextField : UITextField!
    @IBOutlet weak var securityProtocolTextField : UITextField!
    @IBOutlet weak var authKeyTextField : UITextField!

    @IBOutlet weak var viewDHCP : UIView!
    @IBOutlet weak var useDHCPSwitch : Switch!
    @IBOutlet weak var ipVersionSwitch : ControlSwitch!
    
    @IBOutlet weak var viewIPv6 : UIView!
    @IBOutlet weak var ipAddressIPv6 : UITextField!
    @IBOutlet weak var prefixLengthIPv6 : UITextField!
    @IBOutlet weak var gatewayIPv6 : UITextField!

    @IBOutlet weak var viewIPv4 : UIView!
    @IBOutlet var ipAddressIPv4 : [UITextField]!
    @IBOutlet var netmaskIPv4 : [UITextField]!
    @IBOutlet var gatewayIPv4 : [UITextField]!

    @IBOutlet weak var dnssView : UIView!
    @IBOutlet var dns1 : [UITextField]!
    @IBOutlet var dns2 : [UITextField]!
    @IBOutlet var dns3 : [UITextField]!

    @IBOutlet var protocolsView : UIView!
    @IBOutlet var protocolsTableView : UITableView!

    private var presenter : NodeNetworkSettingsPresenter!
    private var viewModel : NodeNetworkSettingsViewModel?
    
    @objc(initWithFingerprints:) init(fingerprints: [String])
    {
        super.init(nibName: String(describing: NodeNetworkSettingsView.self), bundle: nil)
        self.presenter = NodeNetworkSettingsPresenter.init(interactor: self.interactor(), navigation: self.navigation(), fingerprints: fingerprints)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        ssidTextField.delegate = self
        securityProtocolTextField.delegate = self
        authKeyTextField.delegate = self
        ipAddressIPv6.delegate = self
        prefixLengthIPv6.delegate = self
        gatewayIPv6.delegate = self
        for dns in [dns1, dns2, dns3, ipAddressIPv4, netmaskIPv4, gatewayIPv4]
        {
            for field in dns!
            {
                field.delegate = self
            }
        }
        ethernetLabel.font = UIFont.boldSystemFont(ofSize: 14)
        wifiLabel.font = UIFont.boldSystemFont(ofSize: 14)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        presenter.onAttachView(self)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        editingListener = DataEditingListener.init(view: contentScrollView, valueChanged: { (control, isChanged) in
            self.acceptButton.isEnabled = isChanged
        })
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        presenter.onDettachView()
    }
    
    override func close()
    {
        if self.acceptButton.isEnabled
        {
            showAlert("Info", message: "You will lose any information you have edited. Are you sure you wish to close without saving", acceptText: "Yes", declineText: "No") { (isSuccess) in
                if isSuccess
                {
                    super.close()
                }
            }
        }
    }
}

extension NodeNetworkSettingsView: INodeNetworkSettingsView
{
    func fill(_ model: NodeNetworkSettingsViewModel)
    {
        self.viewModel = model
        view.backgroundColor = viewModel!.getBackgroundColor()
        let containerColor = viewModel!.getContainerColor()
        wifiView.backgroundColor = containerColor
        viewDHCP.backgroundColor = containerColor
        viewIPv4.backgroundColor = containerColor
        viewIPv6.backgroundColor = containerColor
        topContainer.backgroundColor = containerColor
        dnssView.backgroundColor = containerColor
        wifiLineView.disableColor = viewModel!.getDisableTabLineColor()
        ethernetLineView.disableColor = viewModel!.getDisableTabLineColor()
        fill(texts: model.dns1, textFields: dns1)
        fill(texts: model.dns2, textFields: dns2)
        fill(texts: model.dns3, textFields: dns3)
    }
    
    func retrieveChanges()
    {
        applyEthernetChanges()
        applyWiFiChanges()
        viewModel?.dns1 = retrieveDNSFrom(textFields: dns1)
        viewModel?.dns2 = retrieveDNSFrom(textFields: dns2)
        viewModel?.dns3 = retrieveDNSFrom(textFields: dns3)
    }
    
    func showEthernetTab()
    {
        wifiView.isHidden = true
        wifiButton.isSelected = false
        ethernetButton.isSelected = true
        wifiLineView.isEnable = false
        wifiLabel.isEnable = false
        ethernetLineView.isEnable = true
        ethernetLabel.isEnable = true
        useDHCPSwitch.isEnable = true
        useDHCPSwitch.isOn = viewModel!.ethernet.isUseDHCP
        ipVersionSwitch.isOn = viewModel!.ethernet.isIP6
        refreshIPVersionView()
        refreshDHCPState(isEnable: useDHCPSwitch.isOn)
        refreshWifiConstraint()
    }
    
    func showWiFiTab()
    {
        wifiView.isHidden = false
        wifiButton.isSelected = true
        ethernetButton.isSelected = false
        wifiLineView.isEnable = true
        wifiLabel.isEnable = true
        ethernetLineView.isEnable = false
        ethernetLabel.isEnable = false
        statusSwitch.isOn = viewModel!.wifi.isStatusOn
        preferredSwitch.isOn = viewModel!.wifi.isPreferredOn
        useDHCPSwitch.isOn = viewModel!.wifi.isUseDHCP
        ipVersionSwitch.isOn = viewModel!.wifi.isIP6
        ssidTextField.text = viewModel!.wifi.ssid
        securityProtocolTextField.text = viewModel!.wifi.securityProtocol
        authKeyTextField.text = viewModel!.wifi.authKey
        refreshIPVersionView()
        useDHCPSwitch.isEnable = statusSwitch.isOn
        refreshStatusState(isEnable: statusSwitch.isOn)
        refreshWifiConstraint()
    }
    
    func showIP4View()
    {
        viewIPv4.isHidden = false
        viewIPv6.isHidden = true
        if ethernetButton.isSelected
        {
            fill(texts: viewModel!.ethernet.ip4.ipAddress, textFields: ipAddressIPv4)
            fill(texts: viewModel!.ethernet.ip4.netmask, textFields: netmaskIPv4)
            fill(texts: viewModel!.ethernet.ip4.gateway, textFields: gatewayIPv4)
        }
        else
        {
            fill(texts: viewModel!.wifi.ip4.ipAddress, textFields: ipAddressIPv4)
            fill(texts: viewModel!.wifi.ip4.netmask, textFields: netmaskIPv4)
            fill(texts: viewModel!.wifi.ip4.gateway, textFields: gatewayIPv4)
        }
    }
    
    func showIP6View()
    {
        viewIPv4.isHidden = true
        viewIPv6.isHidden = false
        if ethernetButton.isSelected
        {
            ipAddressIPv6.text = viewModel!.ethernet.ip6.ipAddress
            prefixLengthIPv6.text = viewModel!.ethernet.ip6.netmask
            gatewayIPv6.text = viewModel!.ethernet.ip6.gateway
        }
        else
        {
            ipAddressIPv6.text = viewModel!.wifi.ip6.ipAddress
            prefixLengthIPv6.text = viewModel!.wifi.ip6.netmask
            gatewayIPv6.text = viewModel!.wifi.ip6.gateway
        }
    }
}

extension NodeNetworkSettingsView: INodeDetailsTabAction
{
    @IBAction func clickSave()
    {
        presenter.onClickSave()
    }
    
    func getRightButtonIconName() -> String
    {
        return "settings_icon_accept.png"
    }
    
    func getRightButtonActiveIconName() -> String
    {
        return "settings_icon_accept_active.png"
    }
    
    func removeTitle()
    {
        titleView.removeFromSuperview()
        containerTopConstraint.isActive = true
    }
    
    func setAccept(button: UIButton)
    {
        acceptButton = button
        acceptButton.isEnabled = false
    }
}

private extension NodeNetworkSettingsView
{
    func applyEthernetChanges()
    {
        viewModel!.ethernet.isUseDHCP = useDHCPSwitch.isOn
        viewModel!.ethernet.isIP6 = ipVersionSwitch.isOn
        viewModel!.ethernet.ip4.ipAddress = (ipAddressIPv4.map { $0.text } as! [String])
        viewModel!.ethernet.ip4.netmask = (netmaskIPv4.map { $0.text } as! [String])
        viewModel!.ethernet.ip4.gateway = (gatewayIPv4.map { $0.text } as! [String])
        viewModel!.ethernet.ip6.ipAddress = ipAddressIPv6.text!
        viewModel!.ethernet.ip6.netmask = prefixLengthIPv6.text!
        viewModel!.ethernet.ip6.gateway = gatewayIPv6.text!
    }
    
    func applyWiFiChanges()
    {
        viewModel!.wifi.isStatusOn = statusSwitch.isOn
        viewModel!.wifi.isPreferredOn = preferredSwitch.isOn
        viewModel!.wifi.isUseDHCP = useDHCPSwitch.isOn
        viewModel!.wifi.isIP6 = ipVersionSwitch.isOn
        viewModel!.wifi.ssid = ssidTextField.text ?? ""
        viewModel!.wifi.securityProtocol = securityProtocolTextField.text ?? ""
        viewModel!.wifi.authKey = authKeyTextField.text ?? ""
        viewModel!.wifi.ip4.ipAddress = (ipAddressIPv4.map { $0.text } as! [String])
        viewModel!.wifi.ip4.netmask = (netmaskIPv4.map { $0.text } as! [String])
        viewModel!.wifi.ip4.gateway = (gatewayIPv4.map { $0.text } as! [String])
        viewModel!.wifi.ip6.ipAddress = ipAddressIPv6.text!
        viewModel!.wifi.ip6.netmask = prefixLengthIPv6.text!
        viewModel!.wifi.ip6.gateway = gatewayIPv6.text!
    }
    
    func refreshWifiConstraint()
    {
        view.setNeedsLayout()
        if wifiButton.isSelected
        {
            wifiTopConstraint.constant = -4
            wifiView.isHidden = false
        }
        else
        {
            wifiTopConstraint.constant = -(wifiView.frame.height + CGFloat(4))
            wifiView.isHidden = true
        }
        view.layoutIfNeeded()
    }
    
    func refreshIPVersionView()
    {
        if ipVersionSwitch.isOn
        {
            showIP6View()
        }
        else
        {
            showIP4View()
        }
    }
    
    func fill(texts: [String?], textFields: [UITextField])
    {
        for (index, field) in textFields.enumerated()
        {
            if index < texts.count
            {
                field.text = texts[index]
            }
            else
            {
                field.text = ""
            }
        }
    }
    
    func retrieveDNSFrom(textFields: [UITextField]) -> [String]
    {
        var result = [String]()
        for field in textFields
        {
            result.append(field.text ?? "")
        }
        return result
    }
    
    func refreshStatusState(isEnable: Bool)
    {
        preferredSwitch.isEnable = isEnable
        ssidTextField.superview!.isEnable = isEnable
        securityProtocolTextField.superview!.isEnable = isEnable
        authKeyTextField.superview!.isEnable = isEnable
        if isEnable
        {
            refreshDHCPState(isEnable: useDHCPSwitch.isOn)
        }
        else
        {
            refreshDHCPState(isEnable: !isEnable)
        }
    }
    
    func refreshDHCPState(isEnable: Bool)
    {
        view.endEditing(true)
        for dnss in [ipAddressIPv4, netmaskIPv4, gatewayIPv4] as! [[UITextField]]
        {
            for field in dnss
            {
                field.superview!.isEnable = !isEnable
            }
        }
        ipVersionSwitch.isEnable = !isEnable
        ipAddressIPv6.superview!.isEnable = !isEnable
        prefixLengthIPv6.superview!.isEnable = !isEnable
        gatewayIPv6.superview!.isEnable = !isEnable
    }
}

extension NodeNetworkSettingsView
{
    @IBAction func clickTab(sender: UIButton)
    {
        if sender != ethernetButton
        {
            applyEthernetChanges()
            showWiFiTab()
        }
        else
        {
            applyWiFiChanges()
            showEthernetTab()
        }
    }
    
    @IBAction func clickSecurityProtocol()
    {
        view.endEditing(true)
        protocolsView.isHidden = false
        navigation().show(protocolsView)
        protocolsTableView.reloadData()
    }
    
    @IBAction func clickIPVersion(aSwitch: ControlSwitch)
    {
        view.endEditing(true)
        if aSwitch.isOn
        {
            showIP6View()
        }
        else
        {
            showIP4View()
        }
    }
    
    @IBAction func clickStatus(aSwitch: Switch)
    {
        refreshStatusState(isEnable: aSwitch.isOn)
    }
    
    @IBAction func clickDHCP(aSwitch: Switch)
    {
        refreshDHCPState(isEnable: aSwitch.isOn)
    }
    
    @IBAction func clickCloseSecurityProtocol()
    {
        protocolsView.removeFromSuperview()
        protocolsView.isHidden = true
    }
}

extension NodeNetworkSettingsView: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return viewModel!.getProtocols().values.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "Cell")
        cell.textLabel?.text = Array(viewModel!.getProtocols().values)[indexPath.row]
        cell.textLabel?.textColor = viewModel!.isExtender ? UIColor.init(red: 0.212, green: 0.22, blue: 0.235, alpha: 1) : UIColor.white
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        presenter.onClickProtocol(index: indexPath.row)
        securityProtocolTextField.text = viewModel!.wifi.securityProtocol
        clickCloseSecurityProtocol()
    }
}
