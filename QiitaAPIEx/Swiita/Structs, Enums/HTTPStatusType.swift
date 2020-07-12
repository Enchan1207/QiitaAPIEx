//
//  HTTPStatusCode.swift
//  QiitaAPIEx
//
//  Created by EnchantCode on 2020/07/11.
//  Copyright © 2020 EnchantCode. All rights reserved.
//

import Foundation

/// Source:  https://developer.mozilla.org/en-US/docs/Web/HTTP/Status
public enum HTTPStatusType {
    case Information
    case Successful
    case Redirects
    case ClientErrors
    case ServerErrors
    
    case Invalid
}
