//
//  ViewController.swift
//  NewsApp2.0
//
//  Created by Рустам Т on 9/29/23.
//

import UIKit
import RxSwift

final class HeadLinesViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(NewTableViewCell.self, forCellReuseIdentifier: NewTableViewCell.identifier)
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    private let disposeBag = DisposeBag()
    private let viewModel: HeadLinesViewModel
    
    
    init(viewModel: HeadLinesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
    }
    
    private func setupViews() {
        title = "News"
        view.addSubview(tableView)
        view.backgroundColor = .white
        setConstraints()
    }
    
    private func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func bindViewModel() {
        let input = HeadLinesViewModel.Input(fetchNewTrigger: Observable.just(()), fetchFavoriteNewTrigger: Observable.just(()), deleteAllFavorites: Observable.never())
        let output = viewModel.transform(input: input)
        
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
