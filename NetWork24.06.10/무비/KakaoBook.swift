//
//  KakaoBook.swift
//  NetWork24.06.10
//
//  Created by 이윤지 on 6/11/24.
//

//카카오 책

import Foundation

struct KakaoBook: Codable {
    let documents: [Document]
    let meta: Meta
}

struct BookDetail: Decodable {
    let title: String
    let contents: String
}



struct Document: Codable {
    let authors: [String]
    let contents, datetime, isbn: String
    let price: Int
    let publisher: String
    let salePrice: Int
    let status: Status
    let thumbnail: String
    let title: String
    let translators: [String]
    let url: String

    enum CodingKeys: String, CodingKey {
        case authors, contents, datetime, isbn, price, publisher
        case salePrice = "sale_price"
        case status, thumbnail, title, translators, url
    }
}

enum Status: String, Codable {
    case empty = ""
    case 정상판매 = "정상판매"
}

struct Meta: Codable {
    let isEnd: Bool
    let pageableCount, totalCount: Int

    enum CodingKeys: String, CodingKey {
        case isEnd = "is_end"
        case pageableCount = "pageable_count"
        case totalCount = "total_count"
    }
}
