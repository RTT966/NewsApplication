//
//  Modell.swift
//  NewsAppTest
//
//  Created by Рустам Т on 9/26/23.
//

import Foundation
import RxSwift

// MARK: - Welcome
struct NewsResponse: Decodable {
    let articles: [Article]
}

// MARK: - Article
struct Article: Codable, Hashable{
    let author: String?
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
}




