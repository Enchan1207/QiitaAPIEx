//
//  SwiitaArticle.swift - 記事
//  QiitaAPIEx
//
//  Created by EnchantCode on 2020/07/15.
//  Copyright © 2020 EnchantCode. All rights reserved.
//

import Foundation

extension Swiita {
    
    /// Get articles posted by authenticated user.
    ///
    /// - Parameters:
    ///   - page: page(**1 origin**)
    ///   - perpage: number of articles per page
    func getMyArticle(page: Int,
                      perPage: Int = 20,
                      success: SuccessCallback? = nil,
                      failure: FailCallback? = nil){
        
        let params = ["page": "\(page)", "per_page": "\(perPage)"]
        apiRequest(apiPath: "api/v2/authenticated_user/items", requestParams: params, success: {success?($0, $1)}, failure: {failure?($0)})
    }
    
    /// Search articles using search query.
    ///
    /// - Parameters:
    ///   - page: page(**1 origin**)
    ///   - perpage: number of articles per page
    func searchArticles(query: String,
                        page: Int,
                        perPage: Int = 20,
                        success: SuccessCallback? = nil,
                        failure: FailCallback? = nil){
        
        let params = ["query": query, "page": "\(page)", "per_page": "\(perPage)"]
        apiRequest(apiPath: "/api/v2/items", requestParams: params, success: {success?($0, $1)}, failure: {failure?($0)})
    }
    
    /// Get articles posted by authenticated user.
    ///
    /// - Parameters:
    ///   - article: Article struct which will be posted
    func postArticle(article: Article,
                     success: SuccessCallback? = nil,
                     failure: FailCallback? = nil){
        
        apiRequest(apiPath: "/api/v2/items", requestBodyStruct: article, method: .POST, success: { success?($0, $1)}) {failure?($0)}
    }
    
    
    func getArticleByID(itemid: String,
    success: SuccessCallback? = nil,
    failure: FailCallback? = nil){
        
        apiRequest(apiPath: "/api/v2/items/\(itemid)", success: { success?($0, $1)}) {failure?($0)}
    }
    
}
