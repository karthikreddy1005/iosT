//
//  Model.swift
//  Concepts
//
//  Created by Karthik Reddy on 06/10/24.
//

import Foundation

struct Todo: Decodable {
    let userId: Int
    let id: Int
    let title: String
    let completed: Bool
}
