//
//  SwiitaCommentStruct.swift - コメントハンドリング用構造体
//  QiitaAPIEx
//
//  Created by EnchantCode on 2020/07/15.
//  Copyright © 2020 EnchantCode. All rights reserved.
//

import Foundation

extension Swiita {
    internal struct Comment: Codable {
        let body: String
    }
}
