//
//  FavoriteNewsViewController.swift
//  NewsApp2.0
//
//  Created by Рустам Т on 9/29/23.
//

import UIKit
import RxSwift
import RxCocoa

class FavoriteNewsViewController: UIViewController {
    
    // MARK: Properies
    private let viewModel: HeadLinesViewModel
    private let disposeBag = DisposeBag()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(NewTableViewCell.self, forCellReuseIdentifier: NewTableViewCell.identifier)
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    private let deleteAllButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("🗑️", for: .normal)
        return button
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
        bindViewModel()
        setupViews()
    }
    
    // MARK: Methods
    private func bindViewModel() {
        let input = HeadLinesViewModel.Input(fetchNewTrigger: Observable.never(), fetchFavoriteNewTrigger: Observable.never(), deleteAllFavorites: deleteAllButton.rx.tap.asObservable(), paginationSubject: Observable.never())
        let output = viewModel.transform(input: input)
        
        output.favoriteNews
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
    
    private func setupViews() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: deleteAllButton)
        view.addSubview(tableView)
        view.backgroundColor = .white
        setConstraints()
    }
    
    private func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

