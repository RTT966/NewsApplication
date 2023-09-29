//
//  TabBarController.swift
//  TestNewsApiApp
//
//  Created by Рустам Т on 9/28/23.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }
    
    private func setupTabs() {
        let viewModel = HeadLinesViewModel()
        let homeVC = createNav(with: "News", image: UIImage(systemName: "newspaper"), vc: HeadLinesViewController(viewModel: viewModel))
        let favouriteVC = createNav(with: "Favourite", image: UIImage(systemName: "star.fill"), vc: FavoriteNewsViewController(viewModel: viewModel))
        
        self.setViewControllers([homeVC, favouriteVC], animated: true)
    }
    
    private func createNav(with title: String, image: UIImage?, vc: UIViewController)-> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image
        return nav
    }
}
