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
        success: SuccessCallback?,
        failure: FailCallback?){
        
        apiRequest(apiPath: "/api/v2/items/\(itemid)/like", success: { success?($0, $1)}) {failure?($0)}
    }
    
    /// Add "LGTM!" to the article.
    /// - Parameters:
    ///  - itemid: target article id.
    func likeArticle(itemid: String,
                     success: SuccessCallback?,
                     failure: FailCallback?) {
        
        apiRequest(apiPath: "/api/v2/items/\(itemid)/like", method: .PUT, success: { success?($0, $1)}) {failure?($0)}
    }
    
    /// Remove "LGTM!" to the article.
    /// - Parameters:
    ///  - itemid: target article id.
    func unlikeArticle(itemid: String,
                       success: SuccessCallback?,
                       failure: FailCallback?) {
        
        apiRequest(apiPath: "/api/v2/items/\(itemid)/like", method: .DELETE, success: { success?($0, $1)}) {failure?($0)}
    }
    
}
