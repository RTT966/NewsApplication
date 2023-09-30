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
        let art =  [
            Article(author: "Author1", title: "Title1", description: "Description1", url: "URL1", urlToImage: "ImageURL1", publishedAt: "Date1"),
            Article(author: "Author2", title: "Title2", description: "Description2", url: "URL2", urlToImage: "ImageURL2", publishedAt: "Date2"),
            Article(author: "Author3", title: "Title3", description: "Description3", url: "URL3", urlToImage: "ImageURL3", publishedAt: "Date3"),
            Article(author: "Author4", title: "Title4", description: "Description4", url: "URL4", urlToImage: "ImageURL4", publishedAt: "Date4"),
            Article(author: "Author5", title: "Title5", description: "Description5", url: "URL5", urlToImage: "ImageURL5", publishedAt: "Date5"),
            Article(author: "Author6", title: "Title6", description: "Description6", url: "URL6", urlToImage: "ImageURL6", publishedAt: "Date6"),
            Article(author: "Author7", title: "Title7", description: "Description7", url: "URL7", urlToImage: "ImageURL7", publishedAt: "Date7"),
            Article(author: "Author8", title: "Title8", description: "Description8", url: "URL8", urlToImage: "ImageURL8", publishedAt: "Date8"),
            Article(author: "Author9", title: "Title9", description: "Description9", url: "URL9", urlToImage: "ImageURL9", publishedAt: "Date9"),
            Article(author: "Author10", title: "Title10", description: "Description10", url: "URL10", urlToImage: "ImageURL10", publishedAt: "Date10"),
            Article(author: "Author11", title: "Title11", description: "Description11", url: "URL11", urlToImage: "ImageURL11", publishedAt: "Date11"),
            Article(author: "Author12", title: "Title12", description: "Description12", url: "URL12", urlToImage: "ImageURL12", publishedAt: "Date12"),
            Article(author: "Author13", title: "Title13", description: "Description13", url: "URL13", urlToImage: "ImageURL13", publishedAt: "Date13"),
            Article(author: "Author14", title: "Title14", description: "Description14", url: "URL14", urlToImage: "ImageURL14", publishedAt: "Date14"),
            Article(author: "Author15", title: "Title15", description: "Description15", url: "URL15", urlToImage: "ImageURL15", publishedAt: "Date15"),
            Article(author: "Author16", title: "Title16", description: "Description16", url: "URL16", urlToImage: "ImageURL16", publishedAt: "Date16"),
            Article(author: "Author17", title: "Title17", description: "Description17", url: "URL17", urlToImage: "ImageURL17", publishedAt: "Date17"),
            Article(author: "Author18", title: "Title18", description: "Description18", url: "URL18", urlToImage: "ImageURL18", publishedAt: "Date18"),
            Article(author: "Author19", title: "Title19", description: "Description19", url: "URL19", urlToImage: "ImageURL19", publishedAt: "Date19"),
            Article(author: "Author20", title: "Title20", description: "Description20", url: "URL20", urlToImage: "ImageURL20", publishedAt: "Date20")
        ]
        
        let news = converter.convertNews(articles: art)
        return news
        
    }
    
    
}
