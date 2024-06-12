//
//  KakaoBook.swift
//  NetWork24.06.10
//
//  Created by 이윤지 on 6/11/24.
//

//카카오 책

import Foundation

struct KakaoBook: Decodable {
    var documents: [BookDetail] //🌟var로 수정하는 이유
    let meta: Meta
}

struct Meta:Decodable{
    let is_end: Bool
    let pageable_count: Int
    let total_count: Int
}

struct BookDetail : Decodable{
    let contents: String
    let title: String
    let url:String //웹링크
    let thumbnail:String //이미지
    let authors:[String]

}
