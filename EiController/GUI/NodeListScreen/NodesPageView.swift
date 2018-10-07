//
//  NodesPageView.swift
//  EiController
//
//  Created by Henrikh Koreniuzhenko on 11.09.2018.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

class NodesPageView: UIViewController
{
    @IBOutlet var table: UITableView!
    var refreshView: VYRefreshView?
    weak var presenter: NodesListPresenter?
    var viewModel: NodesListViewModel?
    
    init(presenter: NodesListPresenter)
    {
        super.init(nibName: String(describing: NodesPageView.self), bundle: nil)
        self.presenter = presenter
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        addPullDownView()
    }
    
    func fill(_ viewModel: NodesListViewModel)
    {
        self.viewModel = viewModel
        table.reloadData()
    }
    
    private func addPullDownView()
    {
        refreshView = VYRefreshView.init(scrollView: table)
        table.addSubview(refreshView!)
        refreshView?.delegate = self
        refreshView?.updateLastRefreshDate()
    }
}

extension NodesPageView: VYRefreshViewDelegate
{
    func refreshViewShouldStartRefresh(_ view: VYRefreshView) -> Bool
    {
        tableViewDataSourceRefreshDidStart()
        return true
    }
    
    func refreshViewLastRefreshDate(_ view: VYRefreshView) -> Date
    {
        return Date()
    }
}

extension NodesPageView: UIScrollViewDelegate
{
    func tableViewDataSourceRefreshDidStart()
    {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(0.5 * Double(NSEC_PER_SEC)) / Double(NSEC_PER_SEC), execute: {
            self.presenter?.onRefreshLocalNodes()
        })
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        refreshView?.scrollDidScroll()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    {
        refreshView?.scrollDidEndDragging()
    }
}

extension NodesPageView: UITableViewDataSource, UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        guard let numberOfSection = viewModel?.getNumberOfSections()
        else { return 0 }
        return numberOfSection
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        guard let numberOfRows = viewModel?.getNumberOfCells(section)
            else {
                return 0
        }
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        guard let sectionHeight = viewModel?.getSectionHeight(section)
            else { return 0 }
        return sectionHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        guard let cellHeight = viewModel?.getCellHeight()
            else { return 0 }
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = NodeInfoCell.build()
        cell.actionInterface = self
        cell.fill(viewModel!.getCellViewModel(indexPath))
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let model = viewModel!.sections[section]
        let sectionView = viewModel!.isShowSections ? NodeListSectionView.build(model) : nil
        sectionView!.load(model)
        return sectionView
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        (cell as? NodeInfoCell)?.prepareGUI()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if viewModel!.isShowGroupOperations && !viewModel!.isStartedSync
        {
            let cell = tableView.cellForRow(at: indexPath) as? NodeInfoCell
            cell?.changeSelectedState()
        }
        presenter?.onClickCell()
    }
}

extension NodesPageView: INodeInfoCellAction
{
    func swipeShowCommands(_ model: NodeListCellViewModel)
    {
        if let nodeDisplayActions = viewModel!.nodes.filter({ $0.isShowedActions == true }).first
        {
            let indexPath = viewModel!.getIndexPath(nodeDisplayActions)
            let cell = table.cellForRow(at: indexPath) as? NodeInfoCell
            cell?.hideOperations()
        }
    }
    
    func onNodeCellAction(_ action: EDeviceCommanTag, model: NodeListCellViewModel)
    {
        presenter?.onNodeAction(action, model: model)
    }
}

class PageControl : NSObject
{
    var stack : UIStackView!
    
    init(count: Int, stackView: UIStackView)
    {
        self.stack = stackView
        super.init()
        stack.spacing = 16
        stack.distribution = .equalSpacing
        stack.alignment = .center
        prepareViews(count: count, selected: 0)
    }

    func setNumberOfPages(_ pages: Int, currentPage: Int)
    {
        clearStack()
        prepareViews(count: pages, selected: currentPage)
    }
    
    private func clearStack()
    {
        let subviews = stack.subviews
        for item in subviews
        {
            stack.removeArrangedSubview(item)
            item.removeFromSuperview()
        }
    }
    
    private func prepareViews(count: Int, selected: Int)
    {
        for index in 0..<count
        {
            let view = createCircle()
            stack.addArrangedSubview(view)
            let height : CGFloat
            let space : CGFloat
            if index == selected
            {
                height = 10
                space = 0
                view.fillHorizontalGradient()
            }
            else
            {
                height = 8
                space = 1
                let color = UIColor.init(red: 0.404, green: 0.392, blue: 0.478, alpha: 1)
                view.setColors([color, color])
            }
            view.topAnchor.constraint(equalTo: stack.topAnchor, constant: space).isActive = true
            view.bottomAnchor.constraint(equalTo: stack.bottomAnchor, constant: -space).isActive = true
            view.heightAnchor.constraint(equalToConstant: height).isActive = true
            view.widthAnchor.constraint(equalToConstant: height).isActive = true
        }
        stack.setNeedsLayout()
        stack.layoutIfNeeded()
        for item in stack.arrangedSubviews
        {
            item.radius = item.frame.height / CGFloat(2)
            item.updateGradient()
        }
    }
    
    private func createCircle() -> UIView
    {
        let view = UIView()
        view.fillHorizontalGradient()
        return view
    }
    
}
