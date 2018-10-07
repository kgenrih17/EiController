//
//  EiGridNodesView.swift
//  EiController
//
//  Created by Genrih Korenujenko on 15.05.18.
//  Copyright © 2018 RadicalComputing. All rights reserved.
//

import UIKit

class EiGridNodesView: UIView, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet var textLabel : UILabel!
    @IBOutlet var nodesTableView : UITableView!
    @IBOutlet var cancelButton : UIButton!
    @IBOutlet var contentView: UIView!
    
    var models : [EiGridNodeViewModel]?
    var listener : EiGridNodesViewListener?
    
    class func build<T: EiGridNodesView>(listener: EiGridNodesViewListener) -> T
    {
        let result = Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
        result.listener = listener
        return result
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        let identifier = String(describing: EiGridNodeViewCell.self)
        let nib = UINib.init(nibName: identifier, bundle: nil)
        nodesTableView.register(nib, forCellReuseIdentifier: identifier)
        cancelButton.imageView?.contentMode = .scaleAspectFit
    }
    
    public func load(models: [EiGridNodeViewModel])
    {
        self.models = models
        if AppStatus.isExtendedMode()
        {
            textLabel.textColor = UIColor.hex("36383c")
            contentView.backgroundColor = UIColor.hex("f8f8f8")
        }
        else
        {
            textLabel.textColor = UIColor.white
            contentView.backgroundColor = UIColor.init(red: 0.129, green: 0.125, blue: 0.157, alpha: 1)
        }
        nodesTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return models != nil ? models!.count : 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 71.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: EiGridNodeViewCell.self), for: indexPath) as! EiGridNodeViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        let gridCell = cell as! EiGridNodeViewCell 
        gridCell.load(model: models![indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        listener?.select(model: models![indexPath.row])
    }
    
    @IBAction func cancel()
    {
        listener?.cancel()
    }
}
