//
//  HeadLinesViewModel.swift
//  NewsApp2.0
//
//  Created by Рустам Т on 9/29/23.
//

import UIKit
import RxSwift
import RxCocoa

protocol ViewModelBase {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input)-> Output
}

final class HeadLinesViewModel {
    
    private let disposeBag = DisposeBag()
    private let favoriteSubject = PublishSubject<NewViewModel>()
    private let headlinesRelay = BehaviorRelay<[NewViewModel]>(value: [])
    
    
    private var headLines: Driver<[NewViewModel]> {
        return headlinesRelay.asDriver()
    }
    private let networkManager: NewsServiceType
    private let converter = NewsConverter()
    
    
    init(networkManager: NewsServiceType = NewsNetworkManager()) {
        self.networkManager = networkManager
    }
    
    private func updateFavoriteStatus(news: NewViewModel) {
        guard let index = headlinesRelay.value.firstIndex(where: {$0.id == news.id}) else { return }
        
        var updatedNews = headlinesRelay.value
        updatedNews[index].isFavourite = news.isFavourite
        headlinesRelay.accept(updatedNews)
    }
    
}

// MARK: - ViewModelBase
extension HeadLinesViewModel: ViewModelBase {
    struct Input {
        let fetchNewTrigger: Observable<Void>
        let favoriteNews: PublishSubject<NewViewModel>
    }
    
    struct Output {
        let news: Driver<[NewViewModel]>
    }
    
    func transform(input: Input) -> Output {
        
        input.fetchNewTrigger
            .flatMapLatest { [weak self] _ -> Observable<[NewViewModel]> in
                guard let self else { return .empty()}
                return self.networkManager.fetchTopHeadlines()
            }.subscribe(onNext: { [weak self] news in
                self?.headlinesRelay.accept(news)
            })
            .disposed(by: disposeBag)
        
        input.favoriteNews
            .subscribe(onNext: { [weak self] news in
                self?.updateFavoriteStatus(news: news)
            })
            .disposed(by: disposeBag)
        
        return Output(news: headLines)
    }
}
