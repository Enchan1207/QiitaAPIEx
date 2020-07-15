//
//  SwiitaTagStruct.swift
//  QiitaAPIEx
//
//  Created by EnchantCode on 2020/07/15.
//  Copyright © 2020 EnchantCode. All rights reserved.
//

import Foundation

extension Swiita {
    struct Tag: Codable {
        let name: String
        let versions: [String]
        
        /*
         example:
         
         "tags": [
           {
             "name": "Ruby",
             "versions": [
               "0.0.1"
             ]
           }
         ]
         */
    }
}
