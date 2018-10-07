//
//  NodePerformanceView.swift
//  EiController
//
//  Created by Henrikh Koreniuzhenko on 04.09.2018.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

class NodePerformanceHeader : UICollectionReusableView
{
    @IBOutlet weak var ramView : UIView!
    @IBOutlet weak var ramTotalLabel : UILabel!
    @IBOutlet weak var ramFreeLabel : UILabel!
    @IBOutlet weak var ramTrackView : UIView!
    @IBOutlet weak var ramProgressView : UIView!
    @IBOutlet var ramProgressWidthConstraint : NSLayoutConstraint!

    @IBOutlet weak var storageView : UIView!
    @IBOutlet weak var storageTotalLabel : UILabel!
    @IBOutlet weak var storageFreeLabel : UILabel!
    @IBOutlet weak var storageTrackView : UIView!
    @IBOutlet weak var storageProgressView : UIView!
    @IBOutlet var storageProgressWidthConstraint : NSLayoutConstraint!
    
    func drawRam(progress: CGFloat?)
    {
        let trackWidth = ramTrackView.frame.width
        let progressWidth : CGFloat!
        if let lProgress = progress, lProgress > 0
        {
            progressWidth = lProgress * trackWidth
        }
        else
        {
            progressWidth = CGFloat(0)
        }
        ramProgressWidthConstraint.constant = progressWidth > trackWidth ? trackWidth : progressWidth
    }
    
    func drawStorage(progress: CGFloat?)
    {
        let trackWidth = storageTrackView.frame.width
        let progressWidth : CGFloat!
        if let lProgress = progress, lProgress > 0
        {
            progressWidth = lProgress * trackWidth
        }
        else
        {
            progressWidth = CGFloat(0)
        }
        storageProgressWidthConstraint.constant = progressWidth > trackWidth ? trackWidth : progressWidth
    }
}

class NodePerformanceView: UIViewController
{
    @IBOutlet weak var collection : UICollectionView!

    private var presenter : NodePerformancePresenter!
    private var viewModel : NodePerformanceViewModel?

    @objc(initWithFingerprint:) init(fingerprint: String)
    {
        super.init(nibName: String(describing: NodePerformanceView.self), bundle: nil)
        self.presenter = NodePerformancePresenter.init(interactor: self.interactor(), navigation: self.navigation(), fingerprint: fingerprint)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let identifier = String(describing: CollectionProgressViewCell.self)
        let nib = UINib.init(nibName: identifier, bundle: nil)
        collection.register(nib, forCellWithReuseIdentifier: identifier)
        let identifierHeader = String(describing: NodePerformanceHeader.self)
        let nibHeader = UINib.init(nibName: identifierHeader, bundle: nil)
        collection.register(nibHeader, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header")
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        presenter.onAttachView(self)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        view.setNeedsLayout()
        view.layoutIfNeeded()
        collection.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        presenter.onDettachView()
    }
}

private extension NodePerformanceView
{
    private func drawProgress(tackView: UIView, progress: CGFloat?, progressView: UIView)
    {
        let trackWidth = tackView.frame.width
        let progressWidth : CGFloat!
        if let lProgress = progress, lProgress > 0
        {
            progressWidth = lProgress / CGFloat(100) * trackWidth
        }
        else
        {
            progressWidth = CGFloat(0)
        }
        var frame = progressView.frame
        frame.size.width = progressWidth > trackWidth ? trackWidth : progressWidth
        progressView.frame = frame
    }
}

extension NodePerformanceView: INodePerformanceView
{
    func fill(_ model: NodePerformanceViewModel)
    {
        viewModel = model
        view.backgroundColor = model.getBackgroundColor()
    }
}

extension NodePerformanceView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return viewModel!.models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let cellIndents = CGFloat(27)
        let width = (collectionView.frame.width - cellIndents) / CGFloat(2.0)
        let height = CGFloat(106)
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CollectionProgressViewCell.self), for: indexPath)
        (cell as! CollectionProgressViewCell).load(model: viewModel!.models[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize
    {
        return CGSize(width: collectionView.frame.width, height: 92)
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        let collectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as! NodePerformanceHeader
        collectionHeader.backgroundColor = .clear
        collectionHeader.ramView.backgroundColor = viewModel!.getContainerColor()
        collectionHeader.ramTotalLabel.text = viewModel!.ramTotal
        collectionHeader.ramTotalLabel.textColor = viewModel!.getTitleColor()
        collectionHeader.ramFreeLabel.text = viewModel!.ramFree
        collectionHeader.ramFreeLabel.textColor = viewModel!.getTitleColor()
        collectionHeader.ramTrackView.backgroundColor = viewModel!.getTrackProgressColor()
        collectionHeader.ramTrackView.layer.borderColor = viewModel!.getTrackProgressBorderColor().cgColor
        collectionHeader.storageView.backgroundColor = viewModel!.getContainerColor()
        collectionHeader.storageTotalLabel.text = viewModel!.storageTotal
        collectionHeader.storageTotalLabel.textColor = viewModel!.getTitleColor()
        collectionHeader.storageFreeLabel.text = viewModel!.storageFree
        collectionHeader.storageFreeLabel.textColor = viewModel!.getTitleColor()
        collectionHeader.storageTrackView.backgroundColor = viewModel!.getTrackProgressColor()
        collectionHeader.storageTrackView.layer.borderColor = viewModel!.getTrackProgressBorderColor().cgColor
        collectionHeader.drawRam(progress: viewModel!.ramProgress)
        collectionHeader.drawStorage(progress: viewModel!.storageProgress)
        collectionHeader.ramProgressView.updateGradient()
        collectionHeader.storageProgressView.updateGradient()
        return collectionHeader
    }
}
