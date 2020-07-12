//
//  HTTPURLResponseExt.swift
//  QiitaAPIEx
//
//  Created by EnchantCode on 2020/07/11.
//  Copyright © 2020 EnchantCode. All rights reserved.
//

import Foundation

extension HTTPURLResponse {
    // レスポンス中のステータスコードの種別を返す
    func typeOfStatusCode() -> HTTPStatusType{
        switch self.statusCode {
        case 100...199:
            return .Information
        case 200...299:
            return .Successful
        case 300...399:
            return .Redirects
        case 400...499:
            return .ClientErrors
        case 500...599:
            return .ServerErrors
            
        default:
            return .Invalid
        }
        
    }
}
