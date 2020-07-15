//
//  SwiitaComment.swift - コメント
//  QiitaAPIEx
//
//  Created by EnchantCode on 2020/07/15.
//  Copyright © 2020 EnchantCode. All rights reserved.
//

import Foundation

extension Swiita {
    /// Get comment.
    /// - Parameters:
    ///     - commentid: target comment id.
    func getComment(commentid: String,
                    success: SuccessCallback? = nil,
                    failure: FailCallback? = nil){
        
        apiRequest(apiPath: "/api/v2/comments/\(commentid)", success: { success?($0, $1)}) {failure?($0)}
    }
    
    /// Delete comment.
    /// - Parameters:
    ///     - commentid: target comment id.
    func removeComment(commentid: String,
                       success: SuccessCallback? = nil,
                       failure: FailCallback? = nil){
        
        apiRequest(apiPath: "/api/v2/comments/\(commentid)", method: .DELETE, success: { success?($0, $1)}) {failure?($0)}
    }
    
    /// Update comment.
    /// - Parameters:
    ///     - commentid: target comment id.
    ///     - content: updated comment content (allow markdown)
    func updateComment(commentid: String,
                       content: String,
                       success: SuccessCallback? = nil,
                       failure: FailCallback? = nil){
        apiRequest(apiPath: "/api/v2/comments/\(commentid)", requestBodyStruct: Comment(body: content), method: .PATCH, success: { success?($0, $1)}) {failure?($0)}
    }
    
    /// Get comments added to the article.
    /// - Parameters:
    ///     - itemid: target article id.
    func getCommentsInArticle(itemid: String,
                              success: SuccessCallback? = nil,
                              failure: FailCallback? = nil){
        
        apiRequest(apiPath: "/api/v2/items/\(itemid)/comments", success: { success?($0, $1)}) {failure?($0)}
    }
    
    /// Post comment to the article.
    /// - Parameters:
    ///     - itemid: target article id.
    ///     - commentid: target comment id.
    ///     - content: updated comment content (allow markdown)
    func addCommentToArticle(itemid: String,
                             commentid: String,
                             content: String,
                             success: SuccessCallback? = nil,
                             failure: FailCallback? = nil){
        
        apiRequest(apiPath: "/api/v2/items/\(itemid)/comments", requestBodyStruct: Comment(body: content), method: .POST, success: { success?($0, $1)}) {failure?($0)}
    }
    
    
    
}
