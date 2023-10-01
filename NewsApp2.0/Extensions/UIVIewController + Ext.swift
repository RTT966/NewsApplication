//
//  Ext + UIVIewController.swift
//  NewsApp2.0
//
//  Created by Рустам Т on 10/1/23.
//

import UIKit

extension UIViewController {
    func showErrorAlert() {
        let alert = UIAlertController(title: "Проверьте интернет соединение", message: "",  preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(action)
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
}

