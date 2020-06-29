//
//  QuoteData.swift
//  hawa
//
//  Created by Felinda Gracia Lubis on 6/29/20.
//  Copyright © 2020 Felinda Lubis. All rights reserved.
//

import Foundation

struct QuoteData : Decodable {
    let quote : String
    let character : String
}

struct QuoteModel {
    let result : [QuoteData]
}
