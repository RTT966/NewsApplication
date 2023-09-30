//
//  ViewController.swift
//  NewsApp2.0
//
//  Created by Рустам Т on 9/29/23.
//

import UIKit
import RxSwift

final class HeadLinesViewController: UIViewController {
    
    // MARK: Properties
    let paginagionSubject = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    private let viewModel: HeadLinesViewModel
    
    // MARK: TableView
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(NewTableViewCell.self, forCellReuseIdentifier: NewTableViewCell.identifier)
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    // MARK: Init
    init(viewModel: HeadLinesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
    }
    
    // MARK: Methods
    private func setupViews() {
        view.addSubview(tableView)
        view.backgroundColor = .white
        setConstraints()
        tableView.delegate = self
    }
    
    private func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Что-то пошло не так.", message: "",  preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(action)
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
    
    private func bindViewModel() {
        let input = HeadLinesViewModel.Input(fetchNewTrigger: Observable.just(()), fetchFavoriteNewTrigger: Observable.just(()), deleteAllFavorites: Observable.never(), paginationSubject: paginagionSubject.skip(1))
        let output = viewModel.transform(input: input)
        
        output.error
            .subscribe(onNext: { [weak self] _ in
                self?.showAlert()
            })
            .disposed(by: disposeBag)
        
        output.news
            .drive(tableView.rx.items(cellIdentifier: NewTableViewCell.identifier, cellType: NewTableViewCell.self)) { _, news, cell in
                cell.configure(with: news)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(NewViewModel.self)
            .subscribe(onNext: { [weak self] news in
                let vm = DetailViewModel(selectedNew: news)
                vm.delegate = self?.viewModel
                let vc = DetailViewController(viewModel: vm)
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] index in
                self?.tableView.deselectRow(at: index, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UIScrollViewDelegate & UITableViewDelegate
extension HeadLinesViewController: UIScrollViewDelegate, UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollViewHeight = scrollView.frame.size.height
        let contentHeight = scrollView.contentSize.height
        let yOffset = scrollView.contentOffset.y
        
        if yOffset + scrollViewHeight + 200 >= contentHeight {
            paginagionSubject.onNext(())
        }
    }
}
