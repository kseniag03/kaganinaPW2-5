//
//  News.swift
//  kaganinaPW5
//

import Foundation

struct News: Codable {
    struct Article: Codable {
        let title: String
        let description: String?
        let urlToImage: String?
    }
    let articles: [Article]
}
