//
//  SwiitaAuth.swift - ユーザ認証 /access_tokens/
//  QiitaAPIEx
//
//  Created by EnchantCode on 2020/07/10.
//  Copyright © 2020 EnchantCode. All rights reserved.
//

import Foundation
import UIKit
import SafariServices

extension Swiita {
    
    /// Handling of callback URL.
    ///
    /// - Parameters:
    ///   - URLContexts: `openURLContexts` in `SceneDelegate.swift`
    ///   - callBack: callback URL registed Qiita
    static func handleCallback(URLContexts: Set<UIOpenURLContext>, callBack: URL){
        // QiitaKitのコールバックURLなら認証画面を閉じるリクエストと判断、NotificationCenterで通知
        guard let url = URLContexts.first?.url else { return }
        if callBack.host == url.host{
            NotificationCenter.default.post(Notification(name: .qiitaKitAuthCallback, object: nil, userInfo: ["callbackURL": url]))
        }
    }
    
    /// Open authentication screen.
    ///
    /// - Parameters:
    ///   - presentViewController: View controller that show SKSafariView
    ///   - authority: the access  authority of Qiita APIs
    ///   - success: callback when authenticate succeeded.
    ///   - failure: callback when authenticate failed.
    func authorize(presentViewController: UIViewController?, safariDelegate: SFSafariViewControllerDelegate? = nil, authority: [qiitaAPIAuthority], success: @escaping (_ token: String) -> Void, failure: @escaping (_ error: Error) -> Void){
        
        /// TODO: CSRF対策文字列の生成方法
        let state = NSUUID().uuidString.regexReplace(pattern: "-", replace: "")
        // safariViewControllerを閉じるためのobserberを設定
        self.notifyProtocol = NotificationCenter.default.addObserver(forName: .qiitaKitAuthCallback, object: nil, queue: .main) { (notification) in
            
            // パラメータをパースして認証情報とstateを取得
            guard let callBackURL = notification.userInfo?["callbackURL"] as? URL else { return }
            guard let queries = URLComponents(string: callBackURL.absoluteString)?.queryItems else { return }
            var query = [String: String]()
            queries.forEach { query[$0.name] = $0.value }
            
            self.generateAccessToken(code: query["code"]!, clientState: state, responseState: query["state"]!, success: { (token) in
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
        let scope = authority.map { $0.rawValue }.joined(separator: "+")
        let parameters: [String: String] = ["client_id": self.clientid, "scope": scope, "state": state]
        let authurl = self.apihost.appendingPathComponent("/api/v2/oauth/authorize").setParams(parameters)!
        
        // safariViewControllerで認証ウィンドウを開く
        safariViewController = SFSafariViewController(url: authurl)
        safariViewController.modalPresentationStyle = .automatic
        safariViewController.delegate = safariDelegate
        
        presentViewController?.present(safariViewController, animated: true, completion: nil)
    }
    
    // code, stateからアクセストークンを引っ張る
    internal func generateAccessToken(code: String, clientState: String, responseState:String, success: @escaping (_ token: String) -> Void, failure: @escaping (_ error: Error) -> Void) {
        // CSRF的に問題なければ、codeを認証情報としてアクセストークンを取得
        if (state != self.state) { return }
        struct TokenRequestParams: Codable {
            let client_id: String
            let client_secret: String
            let code: String
        }
        let requestBody = String(data: try! JSONEncoder().encode(TokenRequestParams(client_id: self.clientid, client_secret: self.clientsecret, code: code)), encoding: .utf8)!
        
        let url = self.apihost.appendingPathComponent("/api/v2/access_tokens")
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.httpMethod = "POST"
        request.httpBody = requestBody.data(using: .utf8)
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                failure(error)
            }else{
                if let accessTokenStr = String(data: data!, encoding: .utf8) {
                    struct AccessToken: Codable {
                        let client_id: String
                        let scopes: [qiitaAPIAuthority]
                        let token: String
                    }
                    let token = try? JSONDecoder().decode(AccessToken.self, from: accessTokenStr.data(using: .utf8)!)
                    success(token!.token)
                }
            }
        }.resume()
    }
    
    /// Delete access token.
    ///
    /// - Parameters:
    ///   - token: access token to delete.
    func deleteAccessToken(
        token: String,
        success: SuccessCallback? = nil,
        failure: FailCallback? = nil){
        
        apiRequest(apiPath: "/api/v2/access_tokens/\(token)", method: .DELETE, success: { success?($0, $1)}) {failure?($0)}
    }
    
    /// Get authorized user.
    func getAuthorizedUser(success: SuccessCallback? = nil,
                           failure: FailCallback? = nil){
        
        apiRequest(apiPath: "/api/v2/authenticated_user", success: { success?($0, $1)}) {failure?($0)}
    }
}
