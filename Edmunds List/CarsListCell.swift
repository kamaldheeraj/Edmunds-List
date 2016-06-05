//
//  CarsListCell.swift
//  Edmunds List
//
//  Created by Kamal Dandamudi on 6/5/16.
//  Copyright © 2016 Kamal Dandamudi. All rights reserved.
//

import UIKit

class CarsListCell: UITableViewCell {

    var carImageView:UIImageView!
    var mainLabel:UILabel!
    var subLabel:UILabel!
    var car:Car!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        carImageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 50, height: 50))
        mainLabel = UILabel(frame: CGRect(x: 70, y: 10, width: bounds.width-80, height: 20))
        subLabel = UILabel(frame: CGRect(x: 70, y: 40, width: bounds.width-80, height: 20))
        contentView.addSubview(carImageView)
        contentView.addSubview(mainLabel)
        contentView.addSubview(subLabel)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }

}
