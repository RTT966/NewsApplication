//
//  HeadLinesViewModel.swift
//  NewsApp2.0
//
//  Created by Рустам Т on 9/29/23.
//

import UIKit
import RxSwift
import RxCocoa

final class HeadLinesViewModel {
    
    // MARK: Headlines News Screen
    private let headlinesRelay = BehaviorRelay<[NewViewModel]>(value: [])
    private let favoriteNewsRelay = BehaviorRelay<[NewViewModel]>(value: [])
    
    private var headLines: Driver<[NewViewModel]> {
        return headlinesRelay.asDriver()
    }
    
    // MARK: Favorite News Screen
    private var favoriteNewsDriver: Driver<[NewViewModel]> {
        return favoriteNewsRelay.asDriver()
    }
    
    // MARK: Properties
    private let disposeBag = DisposeBag()
    private let networkManager: NewsServiceType
    private let userDefaultsManager = UserDefaultsManager.shared
    
    // MARK: Init
    init(networkManager: NewsServiceType = NewsNetworkManager()) {
        self.networkManager = networkManager
    }
    
    // MARK: Methods
    private func checkFavoriteNews(news: [NewViewModel]) {
        let oldNews = favoriteNewsRelay.value
        let favoriteNews = news.filter { $0.isFavourite }
        favoriteNewsRelay.accept(favoriteNews)
        
    }
    
    private func deleteAll() {
        var favoriteNews = headlinesRelay.value
        for index in favoriteNews.indices {
            favoriteNews[index].isFavourite = false
        }
        
        headlinesRelay.accept(favoriteNews)
        checkFavoriteNews(news: favoriteNews)
    }
}

// MARK: - ViewModelBase
extension HeadLinesViewModel: ViewModelBase {
    struct Input {
        let fetchNewTrigger: Observable<Void>
        let fetchFavoriteNewTrigger: Observable<Void>
        let deleteAllFavorites: Observable<Void>
    }
    
    struct Output {
        let news: Driver<[NewViewModel]>
        let favoriteNews: Driver<[NewViewModel]>
    }
    
    func transform(input: Input) -> Output {
        
        input.deleteAllFavorites
            .subscribe(onNext: { [weak self] _ in
                self?.deleteAll()
                self?.userDefaultsManager.clearNewViewModel()
            })
            .disposed(by: disposeBag)
        
        input.fetchFavoriteNewTrigger
            .flatMapLatest { [weak self] _ -> Observable<[NewViewModel]?> in
                guard let self else { return .empty()}
                if let news = self.userDefaultsManager.loadNewViewModel() {
                    return .just(news)
                } else {
                    return .just([])
                }
            }
            .subscribe(onNext: { [weak self] news in
                guard let news else { return }
                self?.favoriteNewsRelay.accept(news)
            })
            .disposed(by: disposeBag)
        
        input.fetchNewTrigger
            .flatMapLatest { [weak self] _ -> Observable<[NewViewModel]> in
                guard let self else { return .empty()}
                return self.networkManager.fetchTopHeadlines()
            }.subscribe(onNext: { [weak self] news in
                self?.headlinesRelay.accept(news)
            })
            .disposed(by: disposeBag)
        
        return Output(news: headLines, favoriteNews: favoriteNewsDriver)
    }
}

//MARK: - SelectFavoriteNewDelegate
extension HeadLinesViewModel: SelectFavoriteNewDelegate {
    func updateFavoriteStatus(news: NewViewModel) {
        var allNews = headlinesRelay.value
        guard let index = allNews.firstIndex(where: { $0.title == news.title }) else { return }
        allNews[index] = news
        headlinesRelay.accept(allNews)
        checkFavoriteNews(news: allNews)
        UserDefaultsManager.shared.clearNewViewModel()
        UserDefaultsManager.shared.saveNewViewModel(favoriteNewsRelay.value)
    }
}
