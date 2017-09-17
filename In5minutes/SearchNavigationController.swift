//
//  SearchNavigationController.swift
//  In5minutes
//
//  Created by HideakiTouhara on 2017/09/13.
//  Copyright © 2017年 HideakiTouhara. All rights reserved.
//

import UIKit

class SearchNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Menlo", size: 22)!, NSForegroundColorAttributeName: UIColor.white]

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
