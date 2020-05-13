//
//  Movies.swift
//  Lab4
//
//  Created by Steve Li on 10/19/19.
//  Copyright © 2019 Steve Li. All rights reserved.
//

import Foundation

struct Movie: Codable {
    let id: Int!
    let poster_path: String?
    let title: String?
    let release_date: String?
    let vote_average: Double?
    let overview: String?
    let vote_count:Int!
    let original_language: String?
}

struct APIResults: Codable { // make the properties optional because                              might encounter missing keys
    let page: Int?
    let total_results: Int?
    let total_pages: Int?
    let results: [Movie]?
}
