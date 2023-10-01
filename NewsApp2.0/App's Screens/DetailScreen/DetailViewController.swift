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
    
    private let scrollView: UIScrollView = UIScrollView()
    
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
        scrollView.delegate = self
    }
    
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        super.viewWillTransition(to: size, with: coordinator)
//
//        coordinator.animate(alongsideTransition: { [weak self] _ in
//            self?.updateLayoutForOrientation(size: size)
//        }, completion: nil)
//    }
//
//    private func updateLayoutForOrientation(size: CGSize) {
//        scrollView.snp.remakeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//    }
    
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
        
        scrollView.contentSize = .init(width: self.view.frame.width, height: view.frame.height * 1.5)
        view.addSubview(scrollView)
        
        [
            newImage,
            newTextView,
            authorLabel,
            dateLabel,
            urlTextView
        ].forEach { scrollView.addSubview($0) }
        
        setConstraints()
    }
    
    private func setConstraints() {
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        newImage.snp.makeConstraints { make in
            make.height.equalTo(300)
            make.width.equalToSuperview().multipliedBy(0.95)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(25)
        }
        
        newTextView.snp.makeConstraints { make in
            make.top.equalTo(newImage.snp.bottom).offset(20)
            make.centerX.equalTo(newImage.snp.centerX)
            make.width.equalToSuperview().multipliedBy(0.85)
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
            make.height.equalTo(100)
            make.width.equalToSuperview().multipliedBy(0.95)
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
