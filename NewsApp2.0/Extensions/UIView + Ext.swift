//
//  UIView + Ext.swift
//  NewsApp2.0
//
//  Created by Рустам Т on 10/1/23.
//

import UIKit
import SnapKit
import RxSwift

//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        super.viewWillTransition(to: size, with: coordinator)
//        coordinator.animate(alongsideTransition: { [weak self] _ in
//            self?.updateLayoutForOrientation(size: size)
//        }, completion: nil)
//    }
//
//    private func updateLayoutForOrientation(size: CGSize) {
//        newImage.snp.remakeConstraints { make in
//            make.height.equalTo(100)
//            make.width.equalToSuperview().multipliedBy(0.65)
//            make.top.equalToSuperview().offset(100)
//            make.centerX.equalToSuperview()
//        }
//    }
    
//
//
//    private func updateLayoutForOrientation(size: CGSize) {
//
//        newImage.translatesAutoresizingMaskIntoConstraints = false
//
//        let isLandscape = size.width > size.height
//
//        newImage.snp.remakeConstraints { make in
//            make.height.equalTo(isLandscape ? size.height * 0.6 : 300)
//            make.top.equalToSuperview().offset(isLandscape ? 20 : 100)
//            make.leading.equalToSuperview().offset(isLandscape ? 20 : 15)
//            make.trailing.equalToSuperview().offset(isLandscape ? -20 : -15)
//        }
//
//        newTextView.snp.remakeConstraints { make in
//            make.top.equalTo(newImage.snp.bottom)
//            make.leading.equalToSuperview().offset(15)
//            make.trailing.equalToSuperview().offset(-15)
//        }
//
//        authorLabel.snp.remakeConstraints { make in
//            make.top.equalTo(newTextView.snp.bottom).offset(isLandscape ? 10 : 15)
//            make.leading.equalTo(newTextView.snp.leading)
//        }
//
//        dateLabel.snp.remakeConstraints { make in
//            make.top.equalTo(authorLabel.snp.bottom).offset(isLandscape ? 5 : 10)
//            make.leading.equalTo(authorLabel.snp.leading)
//        }
//
//        urlTextView.snp.remakeConstraints { make in
//            make.top.equalTo(dateLabel.snp.bottom).offset(isLandscape ? 5 : 10)
//            make.leading.equalToSuperview()
//            make.trailing.equalToSuperview()
//            make.height.equalTo(100)
//        }
//    }

extension UIView {
    func startLoadingIndicator(tag: Int = 123, style: UIActivityIndicatorView.Style = .medium) {
        if let indicator = self.viewWithTag(tag) as? UIActivityIndicatorView {
            indicator.startAnimating()
        } else {
            let indicator = UIActivityIndicatorView(style: style)
            indicator.translatesAutoresizingMaskIntoConstraints = false
            indicator.startAnimating()
            indicator.tag = tag
            
            self.addSubview(indicator)
            
            indicator.snp.makeConstraints { make in
                make.centerX.centerY.equalToSuperview()
            }
        }
    }
    
    func stopLoadingIndicator(tag: Int = 123) {
        if let indicator = self.viewWithTag(tag) as? UIActivityIndicatorView {
            indicator.stopAnimating()
            indicator.removeFromSuperview()
        }
    }
}

extension Reactive where Base: UIView {
    var isLoading: Binder<Bool> {
        return Binder(self.base) { view, isLoading in
            if isLoading {
                view.startLoadingIndicator()
            } else {
                view.stopLoadingIndicator()
            }
        }
    }
}
