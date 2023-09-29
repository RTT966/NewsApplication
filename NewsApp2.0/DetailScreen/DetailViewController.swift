//
//  DetailViewController.swift
//  NewsApp2.0
//
//  Created by Рустам Т on 9/29/23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class DetailViewController: UIViewController {
    
    // MARK: Properties
    private let viewModel: DetailViewModel
    private let disposeBag = DisposeBag()
    
    // MARK: Outlets
    private let newImage = ShadowImageView()
    
    private let newTextView: UITextView = {
        let tView = UITextView()
        tView.textAlignment = .center
        tView.textColor = .black
        tView.font = .systemFont(ofSize: 20)
        tView.isScrollEnabled = false
        tView.isEditable = false
        return tView
    }()
    
    private let addToFavouriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("☆", for: .normal)
        button.setTitle("⭐", for: .selected)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.black, for: .selected)
        return button
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .thin)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .thin)
        return label
    }()
    
    private lazy var urlTextlabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .semibold)
        label.textColor = .blue
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true
        return label
    }()
    
    // MARK: Init
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setupViews()
    }
    
    // MARK: Methods
    private func bindViewModel() {
        let input = DetailViewModel.Input(changeStatusTriggered: addToFavouriteButton.rx.tap.asObservable())
        let output = viewModel.transform(input: input)
        
        output.selectedNew
            .drive(onNext: { [weak self] news in
                self?.authorLabel.text = news.author
                self?.dateLabel.text = news.date
                self?.addToFavouriteButton.isSelected = news.isFavourite
                self?.urlTextlabel.text = news.url
            })
        
            .disposed(by: disposeBag)
    }
    
    private func setupViews() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addToFavouriteButton)
        title = "News"
        view.backgroundColor = .white
        [
            newImage,
            newTextView,
            authorLabel,
            dateLabel,
            urlTextlabel
        ].forEach { view.addSubview($0) }
        
        setConstraints()
    }
    
    private func setConstraints() {
        newImage.snp.makeConstraints { make in
            make.height.equalTo(300)
            make.top.equalToSuperview().offset(100)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
        }
        
        newTextView.snp.makeConstraints { make in
            make.top.equalTo(newImage.snp.bottom)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
        }
        
        authorLabel.snp.makeConstraints { make in
            make.top.equalTo(newTextView.snp.bottom).offset(15)
            make.leading.equalTo(newTextView.snp.leading)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(authorLabel.snp.bottom).offset(10)
            make.leading.equalTo(authorLabel.snp.leading)
        }
        
        urlTextlabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.width.equalToSuperview()
        }
    }
}
