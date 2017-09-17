//
//  ShopDetailViewController.swift
//  In5minutes
//
//  Created by HideakiTouhara on 2017/09/13.
//  Copyright © 2017年 HideakiTouhara. All rights reserved.
//

import UIKit
import MapKit

class ShopDetailViewController: UIViewController {
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var catchcopy: UIView!
    @IBOutlet weak var catchcopyLabel: UILabel!
    @IBOutlet weak var tel: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var map: MKMapView!

    @IBOutlet weak var catchcopyHeight: NSLayoutConstraint!
    @IBOutlet weak var nameHeight: NSLayoutConstraint!
    @IBOutlet weak var addressContainerHeight: NSLayoutConstraint!

    
    var shop = Shop()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = shop.photoUrl {
            photo.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "loading"))
        } else {
            photo.image = UIImage(named: "loading")
        }
        if shop.catchCopy != nil {
            catchcopyLabel.text = shop.catchCopy
        } else {
            catchcopyHeight.constant = 0
        }
        name.text = shop.name
        tel.text = shop.tel
        address.text = shop.address
        
        if let lat = shop.lat {
            if let lon = shop.lon {
                // 地図の表示範囲を指定
                let cllc = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                let mkcr = MKCoordinateRegionMakeWithDistance(cllc, 200, 200)
                map.setRegion(mkcr, animated: false)
                // ピンを設定
                let pin = MKPointAnnotation()
                pin.coordinate = cllc
                map.addAnnotation(pin)
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        let nameFrame = name.sizeThatFits(
            CGSize(width: name.frame.size.width, height: CGFloat.greatestFiniteMagnitude)
        )
        nameHeight.constant = nameFrame.height
        let addressFrame = address.sizeThatFits(
            CGSize(width: address.frame.size.width, height: CGFloat.greatestFiniteMagnitude)
        )
        addressContainerHeight.constant = addressFrame.height
        if shop.catchCopy != nil {
            let catchcopyFrame = catchcopyLabel.sizeThatFits(
                CGSize(width: catchcopyLabel.frame.width, height: CGFloat.greatestFiniteMagnitude)
            )
            catchcopyHeight.constant = catchcopyFrame.height
        }
    }
    

    // MARK: - IBAction
    
    @IBAction func telTapped(_ sender: UIButton) {
        guard let tel = shop.tel else {
            return
        }
        guard let url = URL(string: "tel:\(tel)") else {
            return
        }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func mapButtonTapped(_ sender: UIButton) {
        print("maptapped")
        guard let lat = shop.lat else {
            return
        }
        guard let lon = shop.lon else {
            return
        }
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            UIApplication.shared.open(URL(string: "comgooglemaps://?q=\(lat),\(lon)&zoom=14")!, options: [:], completionHandler: nil)
        }
    }
    
    
    

}
