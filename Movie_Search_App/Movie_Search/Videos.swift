//
//  Videos.swift
//  Lab4
//
//  Created by Steve Li on 10/21/19.
//  Copyright © 2019 Steve Li. All rights reserved.
//

import Foundation

struct VideoKey: Codable{
    let key: String?
}

struct APIVideoKey: Codable {
    let id: Int!
    let results: [VideoKey]?
}
