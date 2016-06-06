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
        contentView.backgroundColor = UIColor(red: 0xEF, green: 0xEF, blue: 0xEF, alpha: 1.0)
        carImageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 50, height: 50))
        mainLabel = UILabel(frame: CGRect(x: 70, y: 10, width: bounds.width-80, height: 20))
        subLabel = UILabel(frame: CGRect(x: 70, y: 40, width: bounds.width-80, height: 20))
        mainLabel.font = UIFont.boldSystemFontOfSize(14)
        subLabel.font = UIFont.italicSystemFontOfSize(14)
        mainLabel.textColor = UIColor(red: 71/255, green: 104/255, blue: 171/255, alpha: 1.0)
        subLabel.textColor = UIColor(red: 71/255, green: 104/255, blue: 171/255, alpha: 1.0)
        carImageView.contentMode = .ScaleAspectFit
        contentView.addSubview(carImageView)
        contentView.addSubview(mainLabel)
        contentView.addSubview(subLabel)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:)")
    }

}
