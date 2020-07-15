//
//  SwiitaArticleStruct.swift
//  QiitaAPIEx
//
//  Created by EnchantCode on 2020/07/15.
//  Copyright © 2020 EnchantCode. All rights reserved.
//

import Foundation

extension Swiita {
    struct Article : Codable{
        let body: String
        let coediting: Bool?
        let group_url_name: String?
        private let `private`: Bool
        let tags: [Tag]
        let title: String
        let tweet: Bool
        
        // 全プロパティを初期化
        init(title:String, body: String, tags: [Tag] = [], coediting: Bool? = nil, groupURL: String? = nil, isPrivate: Bool, withTweet: Bool){
            
            self.body = body
            self.coediting = coediting
            self.group_url_name = groupURL
            self.`private` = isPrivate
            self.tags = tags
            self.title = title
            self.tweet = withTweet
        }
        
        // 個人ユーザ向けイニシャライザ
        init(title:String, body: String, tags: [Tag] = [], isPrivate: Bool, withTweet: Bool) {
            self.init(title: title, body: body, tags: tags, coediting: nil, groupURL: nil, isPrivate: isPrivate, withTweet: withTweet)
        }
        
        // プロパティ名privateは直に触らせない
        func isPrivate() -> Bool {
            return self.`private`
        }
        
        /*
         example:
         
         {
           "body": "# Example",
           "coediting": false,
           "group_url_name": "dev",
           "private": false,
           "tags": [
             {
               "name": "Ruby",
               "versions": [
                 "0.0.1"
               ]
             }
           ],
           "title": "Example title",
           "tweet": false
         }
         */
    }
    
}
