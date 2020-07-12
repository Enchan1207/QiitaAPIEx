//
//  SwiitaLGTM.swift - LGTM
//  QiitaAPIEx
//
//  Created by EnchantCode on 2020/07/11.
//  Copyright © 2020 EnchantCode. All rights reserved.
//

import Foundation

extension Swiita {
    /// Check if user liked the article.
    /// - Parameters:
    ///  - itemid: target item id.
    func isLiked(
        itemid: String,
        success: ((_ result: String) -> Void)?,
        failure: ((_ error: Error) -> Void)?){
        
        apiRequest(apiPath: "/api/v2/items/\(itemid)/like") { (data, response, error) in
            if (error == nil) {
                success?(String(data: data!, encoding: .utf8) ?? "{}")
            }else{
                failure?(error!)
            }
        }
    }
    
    func likeArticle(itemid: String,
                     success: ((_ result: Bool) -> Void)?,
                     failure: ((_ error: Error) -> Void)?) {
        
        apiRequest(apiPath: "/api/v2/items/\(itemid)/like", method: .PUT) { (data, response, error) in
            let statusCode = (response as? HTTPURLResponse)?.typeOfStatusCode()
            (error == nil) ? success?(statusCode == .Successful) : failure?(error!)
        }
    }
    
    func unlikeArticle(itemid: String,
                     success: ((_ result: Bool) -> Void)?,
                     failure: ((_ error: Error) -> Void)?) {
        
        apiRequest(apiPath: "/api/v2/items/\(itemid)/like", method: .DELETE) { (data, response, error) in
            let statusCode = (response as? HTTPURLResponse)?.typeOfStatusCode()
            (error == nil) ? success?(statusCode == .Successful) : failure?(error!)
        }
    }
    
}
