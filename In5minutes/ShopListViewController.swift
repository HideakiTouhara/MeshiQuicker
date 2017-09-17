//
//  ShopListViewController.swift
//  In5minutes
//
//  Created by HideakiTouhara on 2017/08/29.
//  Copyright © 2017年 HideakiTouhara. All rights reserved.
//

import UIKit

class ShopListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
//    var yls: YahooLocalSearch = YahooLocalSearch()
    var yls: YahooLocalSearch = YahooLocalSearch(perPage: 1)
    var loadDataObserver: NSObjectProtocol?

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /*
        var qc = QueryCondition()
        qc.query = "ハンバーグ"
        yls = YahooLocalSearch(perPage: 1, startNumber: 0)
        yls.loadData(condition: qc, reset: true)
        qc.query = "ステーキ"
        yls.loadData(condition: qc)
        qc.query = "ラーメン"
        yls.loadData(condition: qc)
         */

        
        // 読み込み完了通知を受信したときの通知
        loadDataObserver = NotificationCenter.default.addObserver(forName: .apiLoadComplete, object: nil, queue: nil, using: {
            (notification) in
            
            self.tableView.reloadData()
            
            // エラーがあればダイアログを開く
            if notification.userInfo != nil {
                if let userInfo = notification.userInfo as? [String: String] {
                    if userInfo["error"] != nil {
                        let alertView = UIAlertController(title: "通信エラー", message: "通信エラーが発生しました。", preferredStyle: .alert)
                        alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                            action in return
                        })
                        )
                        self.present(alertView, animated: true, completion: nil)
                    }
                }
            }
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // 通知の待受を終了
        NotificationCenter.default.removeObserver(self.loadDataObserver!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let navBarHeight = self.navigationController!.navigationBar.frame.size.height
        return (view.frame.height - navBarHeight) / 3
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // セルの選択状態を解除
        tableView.deselectRow(at: indexPath, animated: true)
        // Segueの実行
        performSegue(withIdentifier: "PushShopDetail", sender: indexPath)
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return yls.shops.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if yls.shops.count > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShopListItem") as! ShopListItemTableViewCell
            cell.shop = yls.shops[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PushShopDetail" {
            let vc = segue.destination as! ShopDetailViewController
            if let indexPath = sender as? IndexPath {
                vc.shop = yls.shops[indexPath.row]
            }
        }
    }

}
