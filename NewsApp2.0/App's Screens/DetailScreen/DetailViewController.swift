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
import SafariServices
import Kingfisher

final class DetailViewController: UIViewController {
    
    // MARK: Properties
    private let viewModel: DetailViewModel
    private let disposeBag = DisposeBag()
    private let scrollView = UIScrollView()
    
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

    private let urlTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isSelectable = true
        textView.font = .systemFont(ofSize: 15, weight: .semibold)
        textView.dataDetectorTypes = .link
        textView.linkTextAttributes = [ .foregroundColor: UIColor.blue,
                                        .underlineColor: NSUnderlineStyle.single.rawValue]
        return textView
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
        print("hello pes")
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
                self?.newTextView.text = news.description
                self?.addToFavouriteButton.isSelected = news.isFavourite
                self?.urlTextView.text = news.url
                self?.newImage.setImage(url: news.urlImage)
            })
            .disposed(by: disposeBag)
    }

    private func setupViews() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addToFavouriteButton)
        title = "News"
        view.backgroundColor = .white
        urlTextView.delegate = self
        
        [
            newImage,
            newTextView,
            authorLabel,
            dateLabel,
            urlTextView
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
    
        urlTextView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(100)
        }
    }
}

    // MARK: - UITextViewDelegate
extension DetailViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        let safariVC = SFSafariViewController(url: URL)
        safariVC.modalPresentationStyle = .formSheet
        present(safariVC, animated: true)
        return false
    }
}
