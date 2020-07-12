//
//  SwiitaAPIRequest.swift - APIリクエスト
//  QiitaAPIEx
//
//  Created by EnchantCode on 2020/07/11.
//  Copyright © 2020 EnchantCode. All rights reserved.
//

import Foundation

extension Swiita {
    // 汎用APIリクエスト
    internal func apiRequest(
        token: String? = nil,
        apiPath: String,
        requestParams: [String: String]? = nil,
        method: HTTPMethod? = .GET,
        completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void){
        
        let url = self.apihost.appendingPathComponent(apiPath).setParams(requestParams)
        var request = URLRequest(url: url!)
        request.httpMethod = (method ?? .GET).rawValue
        
        // アクセストークンをセット
        if let generatedToken = self.token {
            request.setValue("Bearer \(generatedToken)", forHTTPHeaderField: "Authorization")
        }
        if let token = token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        // dataTaskを開始
        let session = URLSession.shared
        session.dataTask(with: request, completionHandler: completion).resume()
    }
    
    // ほとんど処理系同じだしこれでもよくね
    internal func apiRequest(
        token: String? = nil,
        apiPath: String,
        requestParams: [String: String]? = nil,
        method: HTTPMethod? = .GET,
        success: SuccessCallback?, failure: FailCallback?){
        
        apiRequest(token: token, apiPath: apiPath, requestParams: requestParams, method: method) { (data, response, error) in
            if error == nil {
                let responseString = String(data: data!, encoding: .utf8) ?? "{}"
                let statusCode = (response as? HTTPURLResponse)?.typeOfStatusCode()
                success?(statusCode ?? .Invalid, responseString)
            }else{
                failure?(error!)
            }
        }
    }
}
