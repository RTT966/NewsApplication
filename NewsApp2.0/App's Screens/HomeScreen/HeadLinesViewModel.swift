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
    private let errorSubject = PublishSubject<Error>()
    
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
    private let userDefaultsManager: UserDefaultsService
    
    // MARK: Init
    init(networkManager: NewsServiceType = NewsNetworkManager(), userDefaultsManager: UserDefaultsService = UserDefaultsManager()) {
        self.networkManager = networkManager
        self.userDefaultsManager = userDefaultsManager
    }
    
    private func checkFavoriteNews(news: NewViewModel) {
        var favoriteNews = favoriteNewsRelay.value
        if news.isFavourite{
            guard !favoriteNews.contains(news) else { return }
            favoriteNews.append(news)
            favoriteNewsRelay.accept(favoriteNews)
        } else if !news.isFavourite {
            guard let index = favoriteNews.firstIndex(where: { $0.title == news.title}) else { return }
            favoriteNews.remove(at: index)
            favoriteNewsRelay.accept(favoriteNews)
        }
        
        favoriteNewsRelay
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] updatedNews in
                self?.userDefaultsManager.clearNewViewModel()
                self?.userDefaultsManager.saveNewViewModel(updatedNews)
            })
            .disposed(by: disposeBag)
    }
    
    private func deleteAll() {
        var favoriteNews = headlinesRelay.value
        for index in favoriteNews.indices {
            favoriteNews[index].isFavourite = false
        }
        
        headlinesRelay.accept(favoriteNews)
        let emptyArray: [NewViewModel] = []
        favoriteNewsRelay.accept(emptyArray)
        userDefaultsManager.clearNewViewModel()
    }
    
    private func newArt() {
        networkManager.fetchTopHeadlines()
            .subscribe(onNext: { [weak self] article in
                guard let self else { return }
                var oldArt = self.headlinesRelay.value
                oldArt.append(contentsOf: article)
                self.headlinesRelay.accept(oldArt)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - ViewModelBase
extension HeadLinesViewModel: ViewModelBase {
    struct Input {
        let fetchNewTrigger: Observable<Void>
        let fetchFavoriteNewTrigger: Observable<Void>
        let deleteAllFavorites: Observable<Void>
        let paginationSubject: Observable<Void>
    }
    
    struct Output {
        let news: Driver<[NewViewModel]>
        let favoriteNews: Driver<[NewViewModel]>
        let error: Observable<Error>
    }
    
    func transform(input: Input) -> Output {
        
        input.paginationSubject
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.newArt()
            },onError: { error in
                self.errorSubject.onNext(error)
            })
            .disposed(by: disposeBag)
        
        input.deleteAllFavorites
            .subscribe(onNext: { [weak self] _ in
                self?.deleteAll()
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
            }, onError: { error in
                self.errorSubject.onNext(error)
            })
            .disposed(by: disposeBag)
        
        return Output(news: headLines, favoriteNews: favoriteNewsDriver, error: errorSubject)
    }
}

//MARK: - SelectFavoriteNewDelegate
extension HeadLinesViewModel: SelectFavoriteNewDelegate {
    func updateFavoriteStatus(news: NewViewModel) {
        var allNews = headlinesRelay.value
        guard let index = allNews.firstIndex(where: { $0.title == news.title }) else { return }
        allNews[index] = news
        headlinesRelay.accept(allNews)
        checkFavoriteNews(news: news)
    }
}
