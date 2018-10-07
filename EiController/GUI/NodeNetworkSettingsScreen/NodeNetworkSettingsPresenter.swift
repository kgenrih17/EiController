//
//  NodeNetworkSettingsPresenter.swift
//  EiController
//
//  Created by Henrikh Koreniuzhenko on 21.09.2018.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

class NodeNetworkSettingsPresenter: NSObject
{
    private weak var view: INodeNetworkSettingsView?
    private weak var interactor: AppInteractorInterface?
    private weak var navigation: NavigationInterface?
    private var fingerprints: [String]
    
    private var commandSender: INodeCommandSender!
    private var viewModel: NodeNetworkSettingsViewModel?
    
    init(interactor : AppInteractorInterface, navigation : NavigationInterface, fingerprints: [String])
    {
        self.interactor = interactor
        self.navigation = navigation
        self.fingerprints = fingerprints
        self.commandSender = NodeCommandSender.build(DeviceOperationLogsTable())
        super.init()
    }
    
    func onAttachView(_ view: INodeNetworkSettingsView)
    {
        self.view = view
        createViewModel()
        view.fill(viewModel!)
        view.showEthernetTab()
    }
    
    func onDettachView()
    {
        view = nil
    }
    
    func onClickSave()
    {
        view?.retrieveChanges()
        sendSet()
    }
    
    func onClickProtocol(index: Int)
    {
        viewModel?.wifi.securityProtocol = Array(viewModel!.getProtocols().values)[index]
    }
}

private extension NodeNetworkSettingsPresenter
{
    func createViewModel()
    {
        viewModel = NodeNetworkSettingsViewModel()
        viewModel?.isExtender = AppStatus.isExtendedMode()
        if fingerprints.count == 1
        {
            let node = getFirstNode()
            if node.netSettings == nil
            {
                sendGet()
            }
            else
            {
                fillViewModel(node.netSettings)
            }
        }
    }
    
    func fillViewModel(_ netSettings: NetworkSettings)
    {
        viewModel!.dns1 = netSettings.dns1.components(separatedBy: ".")
        viewModel!.dns2 = netSettings.dns2.components(separatedBy: ".")
        viewModel!.dns3 = netSettings.dns3.components(separatedBy: ".")
        viewModel!.ethernet.isUseDHCP = (netSettings.ipdhcp == 1)
        viewModel!.ethernet.isIP6 = (netSettings.ethernetIP.versionType == .IP6_VERSION_TYPE)
        viewModel!.ethernet.ip4.ipAddress = netSettings.ethernetIP.address.components(separatedBy: ".")
        viewModel!.ethernet.ip4.gateway = netSettings.ethernetIP.gateway.components(separatedBy: ".")
        viewModel!.ethernet.ip4.netmask = netSettings.ethernetIP.netmask.components(separatedBy: ".")
        viewModel!.ethernet.ip6.ipAddress = netSettings.ethernetIP.address
        viewModel!.ethernet.ip6.gateway = netSettings.ethernetIP.gateway
        viewModel!.ethernet.ip6.netmask = netSettings.ethernetIP.netmask
        viewModel!.wifi.isUseDHCP = (netSettings.wifiIpdhcp1 == 1)
        viewModel!.wifi.isStatusOn = (netSettings.wifiEnabled == 1)
        viewModel!.wifi.isPreferredOn = (netSettings.wifiPreferred == 1)
        viewModel!.wifi.ssid = netSettings.wifiSsid
        viewModel!.wifi.authKey = netSettings.wifiAuthKey
        viewModel!.wifi.authIdentity = netSettings.wifiAuthIdentity
        viewModel!.wifi.authPassword = netSettings.wifiAuthPassword
        viewModel!.wifi.authPrivateKeyPassword = netSettings.wifiAuthPrivateKeyPassword
        viewModel!.wifi.isIP6 = (netSettings.wifiIP.versionType == .IP6_VERSION_TYPE)
        viewModel!.wifi.ip4.ipAddress = netSettings.wifiIP.address.components(separatedBy: ".")
        viewModel!.wifi.ip4.gateway = netSettings.wifiIP.gateway.components(separatedBy: ".")
        viewModel!.wifi.ip4.netmask = netSettings.wifiIP.netmask.components(separatedBy: ".")
        viewModel!.wifi.ip6.ipAddress = netSettings.wifiIP.address
        viewModel!.wifi.ip6.gateway = netSettings.wifiIP.gateway
        viewModel!.wifi.ip6.netmask = netSettings.wifiIP.netmask
        let protocols = viewModel!.getProtocols()
        if protocols.keys.contains(netSettings.wifiSecurityProtocol)
        {
            viewModel!.wifi.securityProtocol = protocols[netSettings.wifiSecurityProtocol]!
        }
        else
        {
            viewModel!.wifi.securityProtocol = protocols.values.first!
        }
    }
    
    func sendGet() {
        view?.showProcessing()
        let node = getFirstNode()
        commandSender.send(command: .GET_NET_SETTINGS, node: node, parameters: nil) { result in
            self.view?.hideProgress()
            if result.error == nil
            {
                self.updateByGet(networkSettings: result.params as! NetworkSettings)
            }
            else
            {
                self.view?.showAlert(withTitle: "Error", message: result.error)
            }
        }
    }
    
    func sendSet()
    {
        view?.showProcessing()
        let nodes = getAllNodes()
        let params = getParams()
        commandSender.send(command: .SET_NET_SETTINGS, nodes: nodes, parameters: getParams()) { result in
            self.view?.hideProgress()
            if result.error == nil
            {
                self.update(networkSettings: params)
                self.view?.showAlert(withTitle: "Info", message: "Successful")
            }
            else
            {
                self.view?.showAlert(withTitle: "Error", message: result.error)
            }
        }
    }
    
    func updateByGet(networkSettings: NetworkSettings)
    {
        update(networkSettings: networkSettings)
        fillViewModel(networkSettings)
        view?.fill(viewModel!)
        view?.showEthernetTab()
    }
    
    func update(networkSettings: NetworkSettings)
    {
        for node in getAllNodes()
        {
            node.netSettings = networkSettings
        }
    }
    
    func getParams() -> NetworkSettings
    {
        let params = NetworkSettings()
        params.dns1 = viewModel!.dns1.joined(separator: ".")
        params.dns2 = viewModel!.dns2.joined(separator: ".")
        params.dns3 = viewModel!.dns3.joined(separator: ".")
        params.ipdhcp = (viewModel!.ethernet.isUseDHCP) ? 1 : 0
        if viewModel!.ethernet.isIP6
        {
            params.ethernetIP = IPSettings.build(viewModel!.ethernet.ip6.ipAddress,
                                                 netmask: viewModel!.ethernet.ip6.netmask,
                                                 gateway: viewModel!.ethernet.ip6.gateway,
                                                 version: "Ipv6")
        }
        else
        {
            params.ethernetIP = IPSettings.build(viewModel!.ethernet.ip4.ipAddress.joined(separator: "."),
                                                 netmask: viewModel!.ethernet.ip4.netmask.joined(separator: "."),
                                                 gateway: viewModel!.ethernet.ip4.gateway.joined(separator: "."),
                                                 version: "Ipv4")
        }
        params.wifiEnabled = (viewModel!.wifi.isStatusOn) ? 1 : 0
        params.wifiPreferred = (viewModel!.wifi.isPreferredOn) ? 1 : 0
        params.wifiIpdhcp1 = (viewModel!.wifi.isUseDHCP) ? 1 : 0
        params.wifiSsid = viewModel!.wifi.ssid
        params.wifiAuthIdentity = viewModel!.wifi.authIdentity
        params.wifiAuthKey = viewModel!.wifi.authKey
        params.wifiAuthPassword = viewModel!.wifi.authPassword
        params.wifiAuthPrivateKeyPassword = viewModel!.wifi.authPrivateKeyPassword
        if viewModel!.wifi.isIP6
        {
            params.wifiIP = IPSettings.build(viewModel!.wifi.ip6.ipAddress,
                                             netmask: viewModel!.wifi.ip6.netmask,
                                             gateway: viewModel!.wifi.ip6.gateway,
                                             version: "Ipv6")
        }
        else
        {
            params.wifiIP = IPSettings.build(viewModel!.wifi.ip4.ipAddress.joined(separator: "."),
                                             netmask: viewModel!.wifi.ip4.netmask.joined(separator: "."),
                                             gateway: viewModel!.wifi.ip4.gateway.joined(separator: "."),
                                             version: "Ipv4")
        }
        if !viewModel!.wifi.securityProtocol.isEmpty
        {
            params.wifiSecurityProtocol = viewModel!.getProtocols().filter { $0.value == viewModel!.wifi.securityProtocol }.keys.first!
        }
        else
        {
            params.wifiSecurityProtocol = ""
        }
        return params
    }
    
    func getAllNodes() -> [Device]
    {
        return interactor!.getNodeStorage().getDevicesByFingerprints(fingerprints)
    }
    
    func getFirstNode() -> Device
    {
        return interactor!.getNodeStorage().getDeviceByFingerprint(fingerprints.first!)!
    }
}
