//
//  ShopListItemTableViewCell.swift
//  In5minutes
//
//  Created by HideakiTouhara on 2017/08/29.
//  Copyright © 2017年 HideakiTouhara. All rights reserved.
//

import UIKit

class ShopListItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var catchCopy: UILabel!
    @IBOutlet weak var station: UILabel!
    @IBOutlet weak var photo: UIImageView!
    
    @IBOutlet weak var nameYFromTop: NSLayoutConstraint!
    
    
    var shop: Shop = Shop() {
        didSet {
            if let url = shop.photoUrl {
                photo.sd_setImage(with: URL(string: url))
            }
            
            name.text = shop.name
            
            if shop.station != nil {
                station.isHidden = false
                station.text = shop.station
                _ = station.sizeThatFits(CGSize(width: photo.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
            } else {
                station.isHidden = true
            }
            
            if shop.catchCopy != nil {
                catchCopy.isHidden = false
                catchCopy.text = shop.catchCopy
//                catchCopy.numberOfLines = 0
//                catchCopy.lineBreakMode = .byWordWrapping
//                sizeToFit()
            } else {
                catchCopy.isHidden = true
                nameYFromTop.constant = photo.frame.size.height / 2
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        catchCopy.numberOfLines = 0
//        catchCopy.sizeThatFits(CGSize(width: self.frame.width, height: CGFloat.greatestFiniteMagnitude))
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
