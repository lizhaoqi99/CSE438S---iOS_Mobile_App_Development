//
//  RentDetail.swift
//  HousingSensei
//
//  Created by MonAster on 2019/11/20.
//  Copyright © 2019 InvictusProgramming. All rights reserved.
//

import Foundation

struct RentDetail: Decodable{
    let property_id: String?
    let prop_type: String?
    let address: String?
    let price: String?
    let sqft: String?
    let lat: Double?
    let lon: Double?
    let photo_count: Int?
    let photo: String?
}
