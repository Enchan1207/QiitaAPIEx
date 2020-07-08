//
//  tokenStruct.swift
//  QiitaAPIEx
//
//  Created by EnchantCode on 2020/07/08.
//  Copyright © 2020 EnchantCode. All rights reserved.
//

import Foundation

struct AccessToken: Codable {
    let client_id: String
    let scopes: [String]
    let token: String
}
