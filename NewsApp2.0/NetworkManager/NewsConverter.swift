//
//  NewsConverter.swift
//  NewsApp2.0
//
//  Created by Рустам Т on 9/29/23.
//

import Foundation
import RxSwift

class NewsConverter {
    func convertNews(articles: [Article])->Observable<[NewViewModel]> {
            let news = articles
                .filter { $0.title != "[Removed]"}
                .compactMap { NewViewModel(new: $0)}
        return Observable.just(news)
        }
}
