//
//  DetailViewModel.swift
//  NewsApp2.0
//
//  Created by Рустам Т on 9/29/23.
//

import UIKit
import RxSwift
import RxCocoa

protocol SelectFavoriteNewDelegate: AnyObject {
    func updateFavoriteStatus(news: NewViewModel)
}

class DetailViewModel {
    
    // MARK: Properties
    private var selectedNew: NewViewModel
    weak var delegate: SelectFavoriteNewDelegate?
    private let disposeBag = DisposeBag()
    
    // MARK: Init
    init(selectedNew: NewViewModel) {
        self.selectedNew = selectedNew
    }
}

    //MARK: - ViewModelBase
extension DetailViewModel: ViewModelBase {
    
    struct Input {
        let changeStatusTriggered: Observable<Void>
    }
    
    struct Output {
        let selectedNew: Driver<NewViewModel>
    }
    
    func transform(input: Input) -> Output {
        let selectedNewRelay = BehaviorRelay<NewViewModel>(value: selectedNew)
        
        input.changeStatusTriggered
            .do(onNext: { [weak self] _ in
                guard let self else { return }
                selectedNew.isFavourite.toggle()
                print(selectedNew.isFavourite)
                self.delegate?.updateFavoriteStatus(news: self.selectedNew)
                selectedNewRelay.accept(selectedNew)
            })
                .subscribe()
                .disposed(by: disposeBag)
                let newsDr = selectedNewRelay.asDriver()
        
        return Output(selectedNew: newsDr)
    }
}
