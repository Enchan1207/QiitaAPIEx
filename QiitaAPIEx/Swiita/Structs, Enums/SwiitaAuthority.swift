//
//  SwiitaAuthority.swift - アプリがAPIに要求する権限
//  QiitaAPIEx
//
//  Created by EnchantCode on 2020/07/10.
//  Copyright © 2020 EnchantCode. All rights reserved.
//

import Foundation

public enum qiitaAPIAuthority: String, Codable {
    case read = "read_qiita"
    case write = "write_qiita"
    case readTeam = "read_qiita_team"
    case writeTeam = "write_qiita_team"
}
