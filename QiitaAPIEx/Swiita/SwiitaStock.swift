//
//  SwiitaStock.swift - ストック
//  QiitaAPIEx
//
//  Created by EnchantCode on 2020/07/11.
//  Copyright © 2020 EnchantCode. All rights reserved.
//

import Foundation

extension Swiita {
    
    /// Get stocked articles.
    ///
    /// - Parameters:
    ///   - userid: target users id
    ///   - page: page(**1 origin**)
    ///   - perpage: number of articles per page
    func getStock(
        userid: String,
        page: Int,
        perPage: Int = 20,
        success: SuccessCallback? = nil,
        failure: FailCallback? = nil){
        
        let params = ["page": "\(page)", "per_page": "\(perPage)"]
        apiRequest(apiPath: "/api/v2/users/\(userid)/stocks", requestParams: params, success: { success?($0, $1)}, failure: {failure?($0)})
    }
    
    /// Stock new article.
    ///
    /// - Parameters:
    ///   - itemid: target articles id
    func addStock(
        itemid: String,
        success: SuccessCallback? = nil,
        failure: FailCallback? = nil){

        apiRequest(apiPath: "/api/v2/items/\(itemid)/stock", method: .PUT, success: { success?($0, $1)}) {failure?($0)}
    }
    
    /// Delete stocked article.
    ///
    /// - Parameters:
    ///   - itemid: target articles id
    ///   - success: result of api request
    func removeStock(
        itemid: String,
        success: SuccessCallback? = nil,
        failure: FailCallback? = nil){
        
        apiRequest(apiPath: "/api/v2/items/\(itemid)/stock", method: .DELETE, success: { success?($0, $1)}) {failure?($0)}
    }
    
    /// Check the article is stocked.
    ///
    /// - Parameters:
    ///   - itemid: target articles id
    ///   - success: result of api request
    func isStocked(
        itemid: String,
        success: SuccessCallback? = nil,
        failure: FailCallback? = nil){
        apiRequest(apiPath: "/api/v2/items/\(itemid)/stock", success: { success?($0, $1)}) {failure?($0)}
    }
}
