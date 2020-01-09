//
//  ExpandableHeaderViewDelegate.swift
//  Dicloud
//
//  Created by Queralt Sosa Mompel on 10/10/19.
//  Copyright © 2019 Queralt Sosa Mompel. All rights reserved.
//

import UIKit

protocol ExpandableHeaderViewDelegate {
    func toggleSection(header: ExpandableHeaderView, section: Int)
}

class ExpandableHeaderView: UITableViewHeaderFooterView {
    var delegate: ExpandableHeaderViewDelegate?
    var section: Int!
    
    override init (reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.addGestureRecognizer(UITapGestureRecognizer(
            target: self, action: #selector (selectHeaderAction)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func selectHeaderAction(gestureRecognizer: UITapGestureRecognizer) {
        let cell = gestureRecognizer.view as! ExpandableHeaderView
        delegate?.toggleSection(header: self, section: cell.section)
    }
    
    func customInit(title: String, section: Int, delegate: ExpandableHeaderViewDelegate) {
        self.textLabel?.text = title
        self.section = section
        self.delegate = delegate
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.textLabel?.textColor = UIColor.black
        let imageView = UIImageView()
        imageView.frame = CGRect(x:10, y:10, width:20, height:20)
        if (textLabel?.text == "Salir") {
            imageView.image = UIImage(named: "icons8-shutdown-24")
            self.contentView.addSubview(imageView)
        } else if (textLabel?.text == "Settings") {
            imageView.image = UIImage(named: "icons8-wrench-24")
            self.contentView.addSubview(imageView)
        } else {
            let view = UIView()
            view.frame = CGRect(x:10, y:10, width:20, height:20)
            view.backgroundColor = UIColor.white
            self.contentView.addSubview(view)
        }
        self.contentView.backgroundColor = UIColor.white
    }
}
