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
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
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
        print("object was deleted")
    }
    
    private func newArt() {
        let art =  [
            Article(author: "Author1", title: "Title100", description: "Description1", url: "URL1", urlToImage: "ImageURL1", publishedAt: "Date1"),
            Article(author: "Author2", title: "Title200", description: "Description2", url: "URL2", urlToImage: "ImageURL2", publishedAt: "Date2"),
            Article(author: "Author3", title: "Title300", description: "Description3", url: "URL3", urlToImage: "ImageURL3", publishedAt: "Date3"),
            Article(author: "Author4", title: "Title400", description: "Description4", url: "URL4", urlToImage: "ImageURL4", publishedAt: "Date4"),
            Article(author: "Author5", title: "Title500", description: "Description5", url: "URL5", urlToImage: "ImageURL5", publishedAt: "Date5"),
            Article(author: "Author6", title: "Title600", description: "Description6", url: "URL6", urlToImage: "ImageURL6", publishedAt: "Date6"),
            Article(author: "Author7", title: "Title700", description: "Description7", url: "URL7", urlToImage: "ImageURL7", publishedAt: "Date7"),
            Article(author: "Author8", title: "Title800", description: "Description8", url: "URL8", urlToImage: "ImageURL8", publishedAt: "Date8"),
            Article(author: "Author9", title: "Title900", description: "Description9", url: "URL9", urlToImage: "ImageURL9", publishedAt: "Date9"),
            Article(author: "Author10", title: "Title1000", description: "Description10", url: "URL10", urlToImage: "ImageURL10", publishedAt: "Date10"),
            Article(author: "Author11", title: "Title1100", description: "Description11", url: "URL11", urlToImage: "ImageURL11", publishedAt: "Date11"),
            Article(author: "Author12", title: "Title1200", description: "Description12", url: "URL12", urlToImage: "ImageURL12", publishedAt: "Date12"),
            Article(author: "Author13", title: "Title1300", description: "Description13", url: "URL13", urlToImage: "ImageURL13", publishedAt: "Date13"),
            Article(author: "Author14", title: "Title1400", description: "Description14", url: "URL14", urlToImage: "ImageURL14", publishedAt: "Date14"),
            Article(author: "Author15", title: "Title15", description: "Description15", url: "URL15", urlToImage: "ImageURL15", publishedAt: "Date15"),
            Article(author: "Author16", title: "Title16", description: "Description16", url: "URL16", urlToImage: "ImageURL16", publishedAt: "Date16"),
            Article(author: "Author17", title: "Title17", description: "Description17", url: "URL17", urlToImage: "ImageURL17", publishedAt: "Date17"),
            Article(author: "Author18", title: "Title18", description: "Description18", url: "URL18", urlToImage: "ImageURL18", publishedAt: "Date18"),
            Article(author: "Author19", title: "Title19", description: "Description19", url: "URL19", urlToImage: "ImageURL19", publishedAt: "Date19"),
            Article(author: "Author20", title: "Title20", description: "Description20", url: "URL20", urlToImage: "ImageURL20", publishedAt: "Date20")
        ]
        
        let newArt = art.map { NewViewModel(new: $0)}
        var oldArt = headlinesRelay.value
        oldArt.append(contentsOf: newArt)
        headlinesRelay.accept(oldArt)
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
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
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
