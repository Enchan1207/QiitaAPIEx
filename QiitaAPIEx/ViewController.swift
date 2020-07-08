//
//  ViewController.swift
//  QiitaAPIEx
//
//  Created by EnchantCode on 2020/07/08.
//  Copyright © 2020 EnchantCode. All rights reserved.
//

import UIKit
import SafariServices

class ViewController: UIViewController, SFSafariViewControllerDelegate {
    
    @IBOutlet weak var authorizeLabel: UILabel!
    
    private let clientid = "bf0f661c452a2c20fe9f81c4a87225a76b84adb1"
    private let clientsecret = "7367b74ae862bea330f45ccd2ff8269ed8e451a1"
    private var state: String?
    private var token: AccessToken?
    
    private var safariViewController: SFSafariViewController!
    static let AuthorizeCloseNotification = NSNotification.Name(rawValue: "AuthorizeCloseNotification")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // CSRF対策用文字列を生成
        self.state = NSUUID().uuidString.regexReplace(pattern: "-", replace: "")
        
        // safariViewControllerを閉じるためのobserberを追加
        NotificationCenter.default.addObserver(self, selector: #selector(onAuthCompleted(_:)), name: ViewController.AuthorizeCloseNotification, object: nil)
        
    }
    
    // オブザーバーを消す
    deinit {
        NotificationCenter.default.removeObserver(self, name: ViewController.AuthorizeCloseNotification, object: nil)
    }
    
    // 認証ボタン押下時
    @objc func onAuthCompleted(_ notification: NSNotification) {
        guard let callBackURL = notification.object as? URL else { return }
        
        // パラメータをパース
        guard let queries = URLComponents(string: callBackURL.absoluteString)?.queryItems else { return }
        var query = [String: String]()
        queries.forEach { query[$0.name] = $0.value }
        
        // CSRF的に問題なければ、codeを認証情報としてアクセストークンを取得
        if (query["state"] != self.state) { return }
        
        // ここクソ実装
        let url = URL(string: "https://qiita.com/api/v2/access_tokens")
        var request = URLRequest(url: url!)
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.httpMethod = "POST"
        let requestBody =
        """
        {
            "client_id": "\(self.clientid)",
            "client_secret": "\(self.clientsecret)",
            "code": "\(query["code"]!)"
        }
        """
        print(requestBody)
        request.httpBody = requestBody.data(using: .utf8)
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            // 正常にレスポンスが返ってきた場合はアクセストークンを生成
            if (error == nil) {
                if let statusCode = (response as? HTTPURLResponse)?.statusCode, let accessTokenStr = String(data: data!, encoding: .utf8) {
                    self.token = try? JSONDecoder().decode(AccessToken.self, from: accessTokenStr.data(using: .utf8)!)
                }
            }
            
            // safariViewControllerを閉じる
            DispatchQueue.main.sync {
                self.safariViewController.dismiss(animated: true, completion: nil)
            }
        }.resume()
    }
    
    // ストック取得
    func getStock(page: Int, order: Int = 20){
        let url = URL(string: "https://qiita.com/api/v2/users/Enchan/stocks?page=\(page)&per_page=\(order)")
        var request = URLRequest(url: url!)
        request.setValue("Bearer \(self.token!.token)", forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if (error == nil) {
                DispatchQueue.main.sync {
                    self.authorizeLabel.text = String(data: data!, encoding: .utf8)
                }
            }
        }.resume()
    }
    
    // 認証画面を開く
    @IBAction func onTapAuthorize(_ sender: UIButton) {
        
        if let token = self.token {
            sender.setTitle("Show User", for: .normal)
            
            /*
            // トークン経由でリクエスト
            let url = URL(string: "https://qiita.com/api/v2/authenticated_user")
            var request = URLRequest(url: url!)
            request.setValue("Bearer \(token.token)", forHTTPHeaderField: "Authorization")
            let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                if (error == nil) {
                    DispatchQueue.main.sync {
                        self.authorizeLabel.text = String(data: data!, encoding: .utf8)
                    }
                }
            }.resume()
            */
            getStock(page: 1)
            
        }else{
            sender.setTitle("Authorize", for: .normal)
            // 認証情報
            let scope = "read_qiita+write_qiita"
            
            // URL生成
            let params = "client_id=\(self.clientid)&scope=\(scope)&state=\(self.state!)"
            let authurl = URL(string: "https://qiita.com/api/v2/oauth/authorize" + "?" + params)
            
            // safariViewControllerで開く
            safariViewController = SFSafariViewController(url: authurl!)
            safariViewController.modalPresentationStyle = .automatic
            
            present(safariViewController, animated: true, completion: nil)
        }
    }
    
}

