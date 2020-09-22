//
//  Item.swift
//  Listy
//
//  Created by Cielo on 19/09/2020.
//  Copyright © 2020 Osama. All rights reserved.
//

import Foundation

class Item: Encodable, Decodable {
    var title: String       = ""
    var isDone: Bool        = false
}
