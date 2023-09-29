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
    
    private let converter = NewsConverter()
    
    func fetchTopHeadlines() -> Observable<[NewViewModel]> {
        let art = [Article(author: "Jack", title: "SOme1", description: "SOme", url: "SOme1", urlToImage: "SOM", publishedAt: "ehh"),Article(author: "Jack1", title: "SOme2", description: "SOme", url: "SOme", urlToImage: "SOM", publishedAt: "ehh"),Article(author: "Jack2", title: "SOme3", description: "SOme", url: "SOme", urlToImage: "SOM", publishedAt: "ehh"),Article(author: "Jack3", title: "SOme4", description: "SOme", url: "SOme", urlToImage: "SOM", publishedAt: "ehh")]
        let news = converter.convertNews(articles: art)
        return news 
        
    }
    
    
}
