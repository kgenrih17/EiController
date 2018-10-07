//
//  NodesListView.swift
//  EiController
//
//  Created by Henrikh Koreniuzhenko on 31.08.2018.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

class NodesListView: UIViewController
{
    private var presenter: NodesListPresenter!
    private var viewModel: NodesListViewModel?
    private var centralSyncProgressView: CentralSyncProgressView?
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var syncButton: UIButton!
    @IBOutlet weak var groupOperationView: UIView!
    @IBOutlet var groupOperationBottomConstraint: NSLayoutConstraint!
    @IBOutlet var bottomMenuButtons: [UIButton]!
    @IBOutlet var stackView: UIStackView!
//    @IBOutlet var prevPageSwipeGesture: UISwipeGestureRecognizer!
    private var pageControl: PageControl?
    private var pageScroller: UIPageViewController?
    private var pagesViews = [NodesPageView]()
    private var currentPageView : NodesPageView?
    {
        get
        {
            if viewModel!.numberOfPages > 0
            {
                return pagesViews.filter { $0.view.tag == viewModel!.page.rawValue }.first
            }
            else
            {
                return nil
            }
        }
    }

    @objc(init) init()
    {
        super.init(nibName: String(describing: NodesListView.self), bundle: nil)
        self.presenter = NodesListPresenter.init(interactor: self.interactor(), navigation: self.navigation())
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }

    func createPageScroller()
    {
        pageScroller = UIPageViewController.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageScroller?.dataSource = self
        pageScroller?.delegate = self
        pageScroller?.view.frame = CGRect(x: 0, y: titleView.frame.maxY, width: view.frame.maxX, height: view.frame.height - titleView.frame.maxY - groupOperationView.frame.height)
        addChildViewController(pageScroller!)
        view.insertSubview(pageScroller!.view, at: 0)
        pageScroller!.didMove(toParentViewController: self)
        pageScroller?.view.backgroundColor = UIColor.clear
        pageScroller?.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        pageScroller?.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        pageScroller?.view.topAnchor.constraint(equalTo: titleView.bottomAnchor).isActive = true
        let pageScrollerHeightConstraint = pageScroller?.view.bottomAnchor.constraint(equalTo: groupOperationView.topAnchor)
        pageScrollerHeightConstraint?.priority = .defaultLow
        pageScrollerHeightConstraint?.isActive = true
        pageControl = PageControl.init(count: pagesViews.count, stackView: stackView)
    }
    
    func createPageViews()
    {
        pagesViews.removeAll()
        var keys = viewModel?.cellViewModels.keys.reversed() ?? []
        if keys.isEmpty
        {
            keys.append(.NODE_PAGE)
        }
        keys.sort { (obj1, obj2) -> Bool in
            return obj1.rawValue < obj2.rawValue
        }
        for item in keys
        {
            let pageView = NodesPageView.init(presenter: presenter)
            pageView.view.tag = item.rawValue
            pageView.view.frame = CGRect(x: 0, y: 0, width: view.frame.maxX, height: view.frame.height - titleView.frame.maxY - groupOperationView.frame.height)
            pagesViews.append(pageView)
        }
        if let model = viewModel, let page = pagesViews.filter ({ $0.view.tag == model.page.rawValue }).first
        {
            if page.view.superview == nil
            {
                pageScroller?.setViewControllers([page], direction: .reverse, animated: false, completion: { (isCompleted) in
                    self.presenter.onChangePage(page.view.tag)
                    self.updatePageSwipes()
                })
            }
            else
            {
                currentPageView?.fill(model)
                updatePageSwipes()
            }
        }
        else if let page = pagesViews.first
        {
            pageScroller?.setViewControllers([page], direction: .reverse, animated: false, completion: { (isCompleted) in
                self.presenter.onChangePage(page.view.tag)
                self.updatePageSwipes()
            })
        }
    }
    
    func updatePageSwipes()
    {
        let isEnable = (pagesViews.count > 1)
//        prevPageSwipeGesture.isEnabled = isEnable
        if let scroller = pageScroller
        {
            scroller.isScrollEnabled = isEnable
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let settingsTypes : [ENodeListTab] = [.INTEGRATION_TAB, .NETWORK_SETTINGS_TAB, .RESTART_TAB]
        for (index, button) in bottomMenuButtons.enumerated()
        {
            button.tag = settingsTypes[index].rawValue
        }
        createPageScroller()
        presenter.onCreate()
        createPageViews()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        view.setNeedsLayout()
        presenter.onAttachView(self)
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        presenter.onDettachView()
    }
    
    override func hideProgress()
    {
        super.hideProgress()
        if let pageView = currentPageView, pageView.refreshView!.state != .normal
        {
            pageView.refreshView!.stopRefreshing()
        }
    }
}

private extension NodesListView
{
    func updateGroupOperationState()
    {
        let newGroupOperationState = (!viewModel!.isShowGroupOperations)
        if groupOperationView.isHidden != newGroupOperationState
        {
            groupOperationView.isHidden = newGroupOperationState
            view.setNeedsLayout()
            if groupOperationView.isHidden
            {
                groupOperationBottomConstraint.constant = -groupOperationView.bounds.height
            }
            else
            {
                groupOperationBottomConstraint.constant = 0
            }
            view.layoutIfNeeded()
        }
    }
}

extension NodesListView
{
    @IBAction func centralSync()
    {
        presenter.onSyncWithCentral()
    }
    
    @IBAction func clickSettings()
    {
        presenter.onClickSettings()
    }
    
//    @IBAction func didSwipe(_ sender: UISwipeGestureRecognizer)
//    {
//        let controller : UIViewController?
//        guard let viewControllerIndex = pagesViews.index(of: viewController as! NodesPageView) else
//        {
//            return nil
//        }
//        let previousIndex = viewControllerIndex - 1
//        guard previousIndex >= 0 else
//        {
//            controller = pagesViews.last
//        }
//        guard pagesViews.count > previousIndex else
//        {
//            return
//        }
//        controller = pagesViews[previousIndex]
//        pageScroller?.setViewControllers([controller!], direction: .reverse, animated: true, completion: { (isCompleted) in
//            self.presenter.onChangePage(page.view.tag)
//        })
//    }
    
    @IBAction func doGroupSettings(_ sender: UIButton)
    {
        presenter.onGroupSettings(ENodeListTab(rawValue: sender.tag)!, models: viewModel!.getSelectedNodes())
    }
}

extension NodesListView: CentralSyncProgressViewActionInterface
{
    func closeCentralSyncProgressView()
    {
        centralSyncProgressView?.removeFromSuperview()
        centralSyncProgressView = nil
    }
}

extension NodesListView: INodesListView
{
    func fill(_ model: NodesListViewModel)
    {
        viewModel = model
        if viewModel!.cellViewModels.count != pagesViews.count
        {
            createPageViews()
        }
        if let pageView = currentPageView, pageView.refreshView!.state != .normal
        {
            pageView.refreshView!.stopRefreshing()
        }
        refreshPageControl()
        syncButton.isHidden = (!viewModel!.isShowSyncWithCentralButton || viewModel!.isStartedSync)
        updateGroupOperationState()
    }
    
    func refreshPageControl()
    {
        if !pagesViews.isEmpty, let page = currentPageView, let index = pagesViews.index(of: page)
        {
            pageControl?.setNumberOfPages(pagesViews.count, currentPage: index)
        }
        else
        {
            pageControl?.setNumberOfPages(0, currentPage: 0)
        }
        titleLabel.text = viewModel!.getTitle()
        currentPageView?.fill(viewModel!)
    }
    
    func changeStateActiveElements(_ model: NodesListViewModel)
    {
        viewModel = model
        syncButton.isHidden = (!viewModel!.isShowSyncWithCentralButton || viewModel!.isStartedSync)
        updateGroupOperationState()
    }
    
    func updateCell(by indexPath: IndexPath)
    {
        currentPageView?.table.reloadRows(at: [indexPath], with: .fade)
    }
    
    func refreshSyncProgress(_ syncViewModel: CentralSyncProgressViewModel)
    {
        if centralSyncProgressView == nil
        {
            centralSyncProgressView = CentralSyncProgressView.progress(with: self, model: syncViewModel)
            view.addSubview(centralSyncProgressView!)
        }
        else
        {
            centralSyncProgressView?.load(syncViewModel)
        }
    }
    
    func enableGroupOperations()
    {
        for subview in groupOperationView.subviews
        {
            for item in subview.subviews
            {
                if (item as? UILabel) != nil || (item as? UIImageView) != nil
                {
                    item.alpha = 1
                }
            }
        }
    }
    
    func disableGroupOperations()
    {
        for subview in groupOperationView.subviews
        {
            for item in subview.subviews
            {
                if (item as? UILabel) != nil || (item as? UIImageView) != nil
                {
                    item.alpha = 0.5
                }
            }
        }
    }
}

extension NodesListView: UIPageViewControllerDataSource, UIPageViewControllerDelegate
{
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool)
    {
        if completed
        {
            presenter.onChangePage(pageViewController.viewControllers!.first!.view.tag)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        guard let viewControllerIndex = pagesViews.index(of: viewController as! NodesPageView) else
        {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else
        {
            return pagesViews.last
        }
        guard pagesViews.count > previousIndex else
        {
            return nil
        }
        return pagesViews[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        guard let viewControllerIndex = pagesViews.index(of: viewController as! NodesPageView) else
        {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = pagesViews.count
        guard orderedViewControllersCount != nextIndex else
        {
            return pagesViews.first
        }
        guard orderedViewControllersCount > nextIndex else
        {
            return nil
        }
        return pagesViews[nextIndex]
    }
}
