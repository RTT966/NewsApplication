//
//  NetworkManager.swift
//  NewsApp2.0
//
//  Created by Рустам Т on 9/29/23.
//

import UIKit
import RxSwift

protocol NewsServiceType {
    func fetchTopHeadlines() -> Observable<[NewViewModel]>
}

final class NewsNetworkManager: NewsServiceType {
    
    private var currentPage = 0
    private let converter = NewsConverter()
    
    private func getTopNews()-> Observable <[Article]> {
        let urlString = Consts.baseURL + Consts.topHeadlinesPath + Consts.pageNumber + String(currentPage) + Consts.apiKey
        guard let url = URL(string: urlString), currentPage < 5 else { return .empty() }
        let request = URLRequest(url: url)
        
        return URLSession.shared
            .rx
            .data(request: request)
            .map({ data in
                try! JSONDecoder().decode(NewsResponse.self, from: data)})
            .map(\.articles)
    }
    
    func fetchTopHeadlines() -> Observable<[NewViewModel]> {
        currentPage += 1
        return getTopNews()
            .flatMap { articles in
                return self.converter.convertNews(articles: articles)
            }
    }
    
    
}

extension NewsNetworkManager {
    enum Consts {
        static let apiKey = "&apiKey=f15712c08c2e41919d550959b51ce8a1"
        static let baseURL = "https://newsapi.org/v2/"
        static let topHeadlinesPath = "top-headlines?country=US"
        static let pageNumber = "&page="
    }
}
