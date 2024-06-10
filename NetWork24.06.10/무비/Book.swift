//
//  Book.swift
//  NetWork24.06.10
//
//  Created by 이윤지 on 6/10/24.
//

import Foundation

struct Book: Decodable {
    let total: Int
    let start: Int
    let display: Int
    let items: [BookInfo]
}

struct BookInfo: Decodable {
    let title: String
    let link: String
    let image: String
    let author: String
    let pubdate: String
    let description: String
}
