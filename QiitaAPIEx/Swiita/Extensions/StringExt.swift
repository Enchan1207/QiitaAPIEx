//
//  StringExt.swift
//  QiitaAPIEx
//
//  Created by EnchantCode on 2020/07/08.
//  Copyright © 2020 EnchantCode. All rights reserved.
//

import Foundation

extension String {
    // 正規表現置換
    func regexReplace(pattern: String, replace: String) -> String{
        return self.replacingOccurrences(of: pattern, with: replace, options: .regularExpression, range: self.range(of: self))
    }
    
}
