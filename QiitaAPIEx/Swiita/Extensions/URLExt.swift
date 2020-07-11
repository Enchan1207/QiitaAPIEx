//
//  URLExt.swift
//  QiitaAPIEx
//
//  Created by EnchantCode on 2020/07/11.
//  Copyright © 2020 EnchantCode. All rights reserved.
//

import Foundation

public extension URL {
    // GETパラメータを設定
    func setParams(_ params: [String: String]) -> URL? {
        // URLをURLComponentsに変換
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: (self.baseURL != nil)) else { return nil }
        
        // パラメータを分解してQueryItemに変換
        let queryItems = params.map { (key: String, value: String) -> URLQueryItem in
            return URLQueryItem(name: key, value: value)
        }
        
        // セットしてreturn
        components.queryItems = queryItems
        return components.url
    }
}
