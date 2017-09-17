//
//  LocationService.swift
//  In5minutes
//
//  Created by HideakiTouhara on 2017/09/10.
//  Copyright © 2017年 HideakiTouhara. All rights reserved.
//

import Foundation
import CoreLocation

public extension Notification.Name {
    // 位置情報使用拒否Notification
    public static let authDenied = Notification.Name("AuthDenied")
    // 位置情報使用制限Notification
    public static let authRestricted = Notification.Name("AuthRestricted")
    // 位置情報使用可能Notification
    public static let authorized = Notification.Name("Authorized")
    // 位置情報完了可能Notification
    public static let didUpdateLocation = Notification.Name("DidUpdateLocation")
    // 位置情報取得失敗Notification
    public static let didFailLocation = Notification.Name("DidFailLocation")
}

public class LocationService: NSObject, CLLocationManagerDelegate {
    private let cllm = CLLocationManager()
    private let nc = NotificationCenter.default
    
    // 位置情報がON担っていないダイアログ
    public var locationServiceDisableAlert: UIAlertController {
        get {
            let alert = UIAlertController(title: "位置情報が取得できません", message: "設定からプライバシー → 位置情報画面を開いてこのアプリの位置情報の許可を「このAppの使用中のみ許可」と設定してください。", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "閉じる", style: .cancel, handler: nil)
            )
            return alert
        }
    }
    
    // 位置情報が制限されているダイアログ
    public var locationServiceRestrictedAlert: UIAlertController {
        get {
            let alert = UIAlertController(title: "位置情報が取得できません", message: "設定から一般 → 機能制限画面を開いてこのアプリが位置情報を使用できるように設定してください。", preferredStyle: .alert)
            alert.addAction(
                UIAlertAction(title: "閉じる", style: .cancel, handler: nil)
            )
            return alert
        }
    }
    
    // 位置情報取得に失敗したダイアログ
    public var locationServiceDidFailAlert: UIAlertController {
        get {
            let alertView = UIAlertController(title: nil, message: "位置情報の取得に失敗しました。", preferredStyle: .alert)
            alertView.addAction(
                UIAlertAction(title: "閉じる", style: .cancel, handler: nil)
            )
            return alertView
        }
    }
    
    // イニシャライザ
    public override init() {
        super.init()
        cllm.delegate = self
    }
    
    // MARK: - CLLocationManagerDelegate
    
    // 位置情報の使用許可状態が変化したときに実行される
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            cllm.requestWhenInUseAuthorization()
        case .restricted:
            nc.post(name: .authRestricted, object: nil)
        case .denied:
            nc.post(name: .authDenied, object: nil)
        case .authorizedWhenInUse:
            break;
        default:
            break;
        }
    }
    
    // 位置情報を取得したときに実行される
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // 位置情報の取得を停止
        cllm.stopUpdatingLocation()
        // locationsは配列なので最後の１つを利用する
        if let location = locations.last {
            // 位置情報を乗せてNotificationを送信する
            nc.post(name: .didUpdateLocation, object: self, userInfo: ["location": location])
        }
    }
    
    // 位置情報の取得に失敗したときに実行される
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // 失敗Notificationを送信する
        nc.post(name: .didFailLocation, object: nil)
    }
    
    // MARK: - アプリケーションロジック
    
    // 位置情報の取得を開始する
    public func startUpdatingLocation() {
        cllm.startUpdatingLocation()
    }
}
