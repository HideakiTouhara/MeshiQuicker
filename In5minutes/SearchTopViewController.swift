//
//  ViewController.swift
//  In5minutes
//
//  Created by HideakiTouhara on 2017/08/22.
//  Copyright © 2017年 HideakiTouhara. All rights reserved.
//

import UIKit
import CoreLocation

class SearchTopViewController: UIViewController {
    
    @IBOutlet weak var basicCard: UIView!
    @IBOutlet weak var meat: UIView!
    @IBOutlet weak var jfood: UIView!
    @IBOutlet weak var cfood: UIView!
    @IBOutlet weak var bread: UIView!
    @IBOutlet weak var pasta: UIView!
    
    @IBOutlet weak var thumbImageView: UIImageView!
    
    
    var cards = [UIView]()
    
    var selectedCardCount = 0
    
    var preQueries = [String]()
    
    let ls = LocationService()
    let nc = NotificationCenter.default
    var observers = [NSObjectProtocol]()
    var here: (lat: Double, lon: Double)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cards.append(meat)
        cards.append(jfood)
        cards.append(cfood)
        cards.append(bread)
        cards.append(pasta)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 初期値に戻す
        basicCard.center = self.view.center
        basicCard.transform = CGAffineTransform.identity
        for card in cards {
            card.center = self.view.center
            card.transform = CGAffineTransform.identity
        }
        selectedCardCount = 0
        preQueries = []
        
        
        // 位置情報取得を禁止している場合
        observers.append(
            nc.addObserver(forName: .authDenied, object: nil, queue: nil, using: {
                notification in
                // 位置情報がONになっていないダイアログ表示
                self.present(self.ls.locationServiceDisableAlert, animated: true, completion: nil)
            })
        )
        
        // 位置情報取得を制限している場合
        observers.append(
            nc.addObserver(forName: .authRestricted, object: nil, queue: nil, using: {
                notification in
                // 位置情報が制限されているダイアログ
                self.present(self.ls.locationServiceRestrictedAlert, animated: true, completion: nil)
            })
        )
        
        // 位置情報取得に失敗した場合
        observers.append(
            nc.addObserver(forName: .didFailLocation, object: nil, queue: nil, using: {
                notification in
                // 位置情報取得に失敗したダイアログ
                self.present(self.ls.locationServiceDidFailAlert, animated: true, completion: nil)
            })
        )
        
        // 位置情報を取得した場合
        observers.append(
            nc.addObserver(forName: .didUpdateLocation, object: nil, queue: nil, using: {
                notification in
                
                
                // 位置情報が渡されていなければ早期離脱
                guard let userInfo = notification.userInfo as? [String: CLLocation] else {
                    return
                }
                
                // userInfoがキー location を持っていなければ早期離脱
                guard let clloc = userInfo["location"] else {
                    return
                }
                
                self.here = (lat: clloc.coordinate.latitude, lon: clloc.coordinate.longitude)
            })
        )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Notificationの待ち受けを解除する
        for observer in observers {
            nc.removeObserver(observer)
        }
        
        observers = []
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PushShopList" {
            let vc = segue.destination as! ShopListViewController
            selectQueries(preQueries: preQueries, vc: vc)
        }
    }
    
    // MARK: - IBAction
    
    @IBAction func panCard(_ sender: UIPanGestureRecognizer) {
        
        if(selectedCardCount >= cards.count){
            return
        }
        
        let card = sender.view!
        let point = sender.translation(in: view)
        let xFromCenter = card.center.x - view.center.x
        
        card.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
        cards[selectedCardCount].center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
        
        card.transform = CGAffineTransform(rotationAngle: 0.61 * (xFromCenter / (view.frame.width / 2)))
        cards[selectedCardCount].transform = CGAffineTransform(rotationAngle: 0.61 * (xFromCenter / (view.frame.width / 2)))
        
        if xFromCenter > 0 {
            thumbImageView.image = #imageLiteral(resourceName: "good")
            thumbImageView.tintColor = UIColor.green
        } else {
            thumbImageView.image = #imageLiteral(resourceName: "bad")
            thumbImageView.tintColor = UIColor.red
        }
        
        thumbImageView.alpha = abs(xFromCenter) / (view.bounds.size.width / 3)
        
        if sender.state ==  UIGestureRecognizerState.ended {
            
            if card.center.x < 75 {
                ls.startUpdatingLocation()
                UIView.animate(withDuration: 0.4, animations: {
                    self.cards[self.selectedCardCount].center = CGPoint(x: self.cards[self.selectedCardCount].center.x - 300, y: self.cards[self.selectedCardCount].center.y)
                })
                card.center = self.view.center
                card.transform = CGAffineTransform.identity
                self.thumbImageView.alpha = 0
                
                if(selectedCardCount < cards.count - 1){
                    selectedCardCount += 1
                } else {
                    performSegue(withIdentifier: "PushShopList", sender: self)
                }
                return
                
            } else if card.center.x > (view.frame.width - 75) {
                ls.startUpdatingLocation()
                UIView.animate(withDuration: 0.4, animations: {
                    self.cards[self.selectedCardCount].center = CGPoint(x: self.cards[self.selectedCardCount].center.x + 300, y: self.cards[self.selectedCardCount].center.y)
                })
                card.center = self.view.center
                card.transform = CGAffineTransform.identity
                self.thumbImageView.alpha = 0
                
                preQueries.append(cards[selectedCardCount].restorationIdentifier!)
                
                if(selectedCardCount < cards.count - 1){
                    selectedCardCount += 1
                } else {
                    performSegue(withIdentifier: "PushShopList", sender: self)
                }
                return
            }
            UIView.animate(withDuration: 0.4, animations: {
                card.center = self.view.center
                card.transform = CGAffineTransform.identity
                self.cards[self.selectedCardCount].center = self.view.center
                self.cards[self.selectedCardCount].transform = CGAffineTransform.identity
                self.thumbImageView.alpha = 0
            })
        }
    }
    
    func selectQueries(preQueries: [String], vc: ShopListViewController) {
        var selectedQuery = [String]()
        var searchWords = [String]()
        for query in preQueries {
            if query == "meat" {
                searchWords = ["ステーキ", "焼肉", "肉", "ハンバーグ"]
//                selectedQuery.append("ハンバーグ")
                selectedQuery.append(searchWords[Int(arc4random_uniform(UInt32(searchWords.count)))])
            } else if query == "jfood" {
                searchWords = ["寿司", "魚", "和食"]
                selectedQuery.append(searchWords[Int(arc4random_uniform(UInt32(searchWords.count)))])
//                selectedQuery.append("寿司")
            } else if query == "cfood" {
                searchWords = ["ラーメン", "中華", "そば"]
                selectedQuery.append(searchWords[Int(arc4random_uniform(UInt32(searchWords.count)))])
//                selectedQuery.append("ラーメン")
            } else if query == "bread" {
                searchWords = ["パン", "フレンチ", "ファミレス"]
                selectedQuery.append(searchWords[Int(arc4random_uniform(UInt32(searchWords.count)))])
//                selectedQuery.append("パン")
            } else if query == "pasta" {
                searchWords = ["パスタ", "イタリアン", "ピザ"]
                selectedQuery.append(searchWords[Int(arc4random_uniform(UInt32(searchWords.count)))])
//                selectedQuery.append("パスタ")
            } else {
                searchWords = ["カフェ", "ハンバーガー", "牛丼"]
                selectedQuery.append(searchWords[Int(arc4random_uniform(UInt32(searchWords.count)))])
            }
        }
        
        var qc: QueryCondition = QueryCondition()
        qc.lat = self.here?.lat
        qc.lon = self.here?.lon
        
        switch selectedQuery.count {
        case 0:
//            qc.query = selectedQuery[0]
            vc.yls.loadData(condition: qc, reset: true, startNumber: 1)
            vc.yls.loadData(condition: qc, startNumber: 2)
            vc.yls.loadData(condition: qc, startNumber: 3)
            break
        case 1:
            qc.query = selectedQuery[0]
            vc.yls.loadData(condition: qc, reset: true, startNumber: 1)
            vc.yls.loadData(condition: qc, startNumber: 2)
            vc.yls.loadData(condition: qc, startNumber: 3)
            break
        case 2:
            qc.query = selectedQuery[0]
            vc.yls.loadData(condition: qc, reset: true, startNumber: 1)
            qc.query = selectedQuery[1]
            vc.yls.loadData(condition: qc, startNumber: 1)
            vc.yls.loadData(condition: qc, startNumber: 2)
            break
        case 3:
            qc.query = selectedQuery[0]
            vc.yls.loadData(condition: qc, reset: true, startNumber: 1)
            qc.query = selectedQuery[1]
            vc.yls.loadData(condition: qc, startNumber: 1)
            qc.query = selectedQuery[2]
            vc.yls.loadData(condition: qc, startNumber: 2)
            break
        case 4:
            selectedQuery.remove(at: Int(arc4random_uniform(4)))
            qc.query = selectedQuery[0]
            vc.yls.loadData(condition: qc, reset: true, startNumber: 1)
            qc.query = selectedQuery[1]
            vc.yls.loadData(condition: qc, startNumber: 1)
            qc.query = selectedQuery[2]
            vc.yls.loadData(condition: qc, startNumber: 2)
            break
        case 5:
            selectedQuery.remove(at: Int(arc4random_uniform(5)))
            selectedQuery.remove(at: Int(arc4random_uniform(4)))
            qc.query = selectedQuery[0]
            vc.yls.loadData(condition: qc, reset: true, startNumber: 1)
            qc.query = selectedQuery[1]
            vc.yls.loadData(condition: qc, startNumber: 1)
            qc.query = selectedQuery[2]
            vc.yls.loadData(condition: qc, startNumber: 2)
            break
        default:
            qc.query = "うどん"
            vc.yls.loadData(condition: qc, reset: true, startNumber: 1)
            qc.query = "牛丼"
            vc.yls.loadData(condition: qc, startNumber: 2)
            qc.query = "肉"
            vc.yls.loadData(condition: qc, startNumber: 3)
            break
        }
    }
}

