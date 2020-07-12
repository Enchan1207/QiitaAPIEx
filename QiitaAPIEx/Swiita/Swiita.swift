//
//  Swiita.swift - イニシャライザやメンバ変数
//  QiitaAPIEx
//
//  Created by EnchantCode on 2020/07/10.
//  Copyright © 2020 EnchantCode. All rights reserved.
//

import Foundation
import UIKit
import SafariServices

public class Swiita{
    public typealias SuccessCallback = (_ statusCode: HTTPStatusType, _ response: String) -> Void
    public typealias FailCallback = (_ error: Error) -> Void
    
    internal let clientid: String
    internal let clientsecret: String
    internal let apihost: URL
    internal let token: String?
    
    internal var state: String?
    internal var safariViewController: SFSafariViewController!
    internal var notifyProtocol: NSObjectProtocol?
    
    init(clientid: String, clientsecret: String, apihost: URL? = nil, token: String? = nil){
        self.clientid = clientid
        self.clientsecret = clientsecret
        self.apihost = apihost ?? URL(string: "https://qiita.com")!
        self.token = token
    }
    
    deinit {
        // 認証コールバック用のオブザーバを消す
        if let notifyProtocol = self.notifyProtocol {
            NotificationCenter.default.removeObserver(notifyProtocol)
        }
    }
}
