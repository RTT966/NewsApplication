//
//  ShadowImageView.swift
//  TestNewsApiApp
//
//  Created by Рустам Т on 9/27/23.
//

import UIKit
import SnapKit

final class ShadowImageView: UIView {
    
    // MARK: Outlets
     let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let baseView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 2, height: 2)
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 6
        return view
    }()
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        baseView.layer.shadowPath = UIBezierPath(roundedRect: baseView.bounds, cornerRadius: 10).cgPath
        baseView.layer.shouldRasterize = true
        baseView.layer.rasterizationScale = UIScreen.main.scale
    }
    
    // MARK: Methods
    func setImage(image: UIImage?) {
        imageView.image = image
    }
    
    private func setupView() {
        baseView.addSubview(imageView)
        addSubview(baseView)
        
        setConstraints()
    }
    
    private func setConstraints() {
        baseView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(10)
            make.trailing.bottom.equalToSuperview().offset(-10)
        }
        
        imageView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(10)
            make.trailing.bottom.equalToSuperview().offset(-10)
        }
    }
}
