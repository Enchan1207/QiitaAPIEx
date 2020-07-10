//
//  Swiita.swift
//  QiitaAPIEx
//
//  Created by EnchantCode on 2020/07/10.
//  Copyright © 2020 EnchantCode. All rights reserved.
//

import Foundation
import UIKit
import SafariServices

class Swiita{
    internal let clientid = "bf0f661c452a2c20fe9f81c4a87225a76b84adb1"
    internal let clientsecret = "7367b74ae862bea330f45ccd2ff8269ed8e451a1"
    
    internal var state: String?
    internal var safariViewController: SFSafariViewController!
    internal var notifyProtocol: NSObjectProtocol?
    
    // コールバックのハンドリング
    static func handleCallback(URLContexts: Set<UIOpenURLContext>, callBack: URL){
        // QiitaKitのコールバックURLなら認証画面を閉じるリクエストと判断、NotificationCenterで通知
        guard let url = URLContexts.first?.url else { return }
        if callBack.host == url.host{
            NotificationCenter.default.post(Notification(name: .qiitaKitAuthCallback, object: nil, userInfo: ["callbackURL": url]))
        }
    }
    
    // 認証画面を開く
    func authorize(presentViewController: UIViewController?, safariDelegate: SFSafariViewControllerDelegate? = nil, scope: String, success: @escaping (_ token: AccessToken) -> Void, failure: @escaping (_ error: Error) -> Void){
        // safariViewControllerを閉じるためのobserberを設定
        self.notifyProtocol = NotificationCenter.default.addObserver(forName: .qiitaKitAuthCallback, object: nil, queue: .main) { (notification) in
            
            // パラメータをパースして認証情報とstateを取得
            guard let callBackURL = notification.userInfo?["callbackURL"] as? URL else { return }
            guard let queries = URLComponents(string: callBackURL.absoluteString)?.queryItems else { return }
            var query = [String: String]()
            queries.forEach { query[$0.name] = $0.value }
            
            self.generateAccessToken(code: query["code"]!, state: query["state"]!, success: { (token) in
                DispatchQueue.main.sync {
                    self.safariViewController.dismiss(animated: true, completion: nil)
                }
                success(token)
            }) { (error) in
                DispatchQueue.main.sync {
                    self.safariViewController.dismiss(animated: true, completion: nil)
                }
                failure(error)
            }
            
            // オブザーバーを消す
            if let notifyProtocol = self.notifyProtocol {
                NotificationCenter.default.removeObserver(notifyProtocol)
            }
        }
        
        // URL生成
        self.state = NSUUID().uuidString.regexReplace(pattern: "-", replace: "")
        let params = "client_id=\(self.clientid)&scope=\(scope)&state=\(self.state!)"
        let authurl = URL(string: "https://qiita.com/api/v2/oauth/authorize" + "?" + params)
        
        // safariViewControllerで開く
        safariViewController = SFSafariViewController(url: authurl!)
        safariViewController.modalPresentationStyle = .automatic
        safariViewController.delegate = safariDelegate
        
        presentViewController?.present(safariViewController, animated: true, completion: nil)
    }
    
    // code, stateからアクセストークンを引っ張る
    func generateAccessToken(code: String, state: String, success: @escaping (_ token: AccessToken) -> Void, failure: @escaping (_ error: Error) -> Void) {
        // CSRF的に問題なければ、codeを認証情報としてアクセストークンを取得
        if (state != self.state) { return }
        struct RequestBody: Codable {
            let client_id: String
            let client_secret: String
            let code: String
        }
        let requestBody = String(data: try! JSONEncoder().encode(RequestBody(client_id: self.clientid, client_secret: self.clientsecret, code: code)), encoding: .utf8)!
        
        let url = URL(string: "https://qiita.com/api/v2/access_tokens")
        var request = URLRequest(url: url!)
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.httpMethod = "POST"
        request.httpBody = requestBody.data(using: .utf8)
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                failure(error)
            }else{
                if let accessTokenStr = String(data: data!, encoding: .utf8) {
                    let token = try? JSONDecoder().decode(AccessToken.self, from: accessTokenStr.data(using: .utf8)!)
                    success(token!)
                }
            }
        }.resume()
    }
    
    deinit {
        // オブザーバーを消す
        if let notifyProtocol = self.notifyProtocol {
            NotificationCenter.default.removeObserver(notifyProtocol)
        }
    }
}
