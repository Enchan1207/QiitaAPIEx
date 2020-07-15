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
        requestBody: String? = nil,
        method: HTTPMethod? = .GET,
        completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void){
        
        let url = self.apihost.appendingPathComponent(apiPath).setParams(requestParams)
        var request = URLRequest(url: url!)
        request.httpMethod = (method ?? .GET).rawValue
        request.httpBody = requestBody?.data(using: .utf8)
        
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
    
    // SuccessCallback, FailCallbackに対応した型で返す
    internal func apiRequest(
        token: String? = nil,
        apiPath: String,
        requestParams: [String: String]? = nil,
        requestBody: String? = nil,
        method: HTTPMethod? = .GET,
        success: SuccessCallback?, failure: FailCallback?){
        
        apiRequest(token: token, apiPath: apiPath, requestParams: requestParams, requestBody: requestBody, method: method) { (data, response, error) in
            if error == nil {
                let responseString = String(data: data!, encoding: .utf8) ?? "{}"
                let statusCode = (response as? HTTPURLResponse)?.typeOfStatusCode()
                success?(statusCode ?? .Invalid, responseString)
            }else{
                failure?(error!)
            }
        }
    }
    
    // JSON形式のリクエストボディを受け取り、エンコードしてリクエスト
    internal func apiRequest<T: Codable>(
        token: String? = nil,
        apiPath: String,
        requestParams: [String: String]? = nil,
        requestBodyStruct: T? = nil,
        method: HTTPMethod? = .GET,
        success: SuccessCallback?, failure: FailCallback?){
        
        guard let encodedStruct = try? JSONEncoder().encode(requestBodyStruct) else { return }
        let requestBody = String(data: encodedStruct, encoding: .utf8)
        
        apiRequest(token: token, apiPath: apiPath, requestParams: requestParams, requestBody: requestBody, method: method, success: { success?($0, $1) }, failure: {failure?($0)} )
        
    }
    
}
