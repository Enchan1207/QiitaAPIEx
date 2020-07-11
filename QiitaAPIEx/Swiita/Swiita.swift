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
    internal let clientid: String
    internal let clientsecret: String
    internal let apihost: URL
    internal let tokenString: String?
    
    internal var state: String?
    internal var safariViewController: SFSafariViewController!
    internal var notifyProtocol: NSObjectProtocol?
    
    init(clientid: String, clientsecret: String, apihost: URL? = nil, tokenString: String? = nil){
        self.clientid = clientid
        self.clientsecret = clientsecret
        self.apihost = apihost ?? URL(string: "https://qiita.com")!
        self.tokenString = tokenString
    }
    
    deinit {
        // 認証コールバック用のオブザーバを消す
        if let notifyProtocol = self.notifyProtocol {
            NotificationCenter.default.removeObserver(notifyProtocol)
        }
    }
}
