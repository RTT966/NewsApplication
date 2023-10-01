//
//  UIView + Ext.swift
//  NewsApp2.0
//
//  Created by Рустам Т on 10/1/23.
//

import UIKit
import SnapKit
import RxSwift

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
