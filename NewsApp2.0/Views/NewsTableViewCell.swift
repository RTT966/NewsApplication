//
//  NewTableViewCell.swift
//  TestNewsApiApp
//
//  Created by Рустам Т on 9/27/23.
//

import UIKit
import SnapKit

final class NewTableViewCell: UITableViewCell {
    
    // MARK: Properties
    static let identifier = "NewTableViewCell"
    
    private let newImage = ShadowImageView()
    
    private let authorNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .thin)
        label.numberOfLines = 0
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .thin)
        return label
    }()
    
    private let titleLable: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func prepareForReuse() {
        titleLable.text = nil
        authorNameLabel.text = nil
        dateLabel.text = nil
        newImage.setImage(image: nil)
    }
    
    // MARK: Methods
    func configure(with viewModel: NewViewModel) {
        titleLable.text = viewModel.title
        dateLabel.text = viewModel.date
        authorNameLabel.text = viewModel.author
        //УСТАНОВКА КАРТИНКИ
        //        NewsNetworkManager.shared.getImage(urlStr: viewModel.urlImage) { [weak self] data in
        //            guard let data = data else { return }
        //            DispatchQueue.main.async {
        //                self?.newImage.setImage(image: UIImage(data: data))
        //            }
        //        }
    }
    
    private func setupView() {
        [
            titleLable,
            newImage,
            dateLabel,
            authorNameLabel
        ].forEach { addSubview($0)}
        setupConstraints()
    }
    
    private func setupConstraints() {
        newImage.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(180)
        }
        
        titleLable.snp.makeConstraints { make in
            make.top.equalTo(authorNameLabel.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
        }
        
        authorNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLable.snp.leading)
            make.width.equalToSuperview()
            make.top.equalTo(newImage.snp.bottom).offset(10)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLable.snp.bottom).offset(10 )
            make.trailing.equalTo(titleLable.snp.trailing)
            make.bottom.equalToSuperview().offset(-15)
        }
    }
}
