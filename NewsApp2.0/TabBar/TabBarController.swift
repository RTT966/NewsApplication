//
//  TabBarController.swift
//  TestNewsApiApp
//
//  Created by Рустам Т on 9/28/23.
//

import UIKit

final class TabBarController: UITabBarController {
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }
    
    // MARK: Methods
    private func setupTabs() {
        let viewModel = HeadLinesViewModel()
        let homeVC = createNav(with: Consts.homeVCTitle, image: Consts.homeVCImage, vc: HeadLinesViewController(viewModel: viewModel))
        let favouriteVC = createNav(with: Consts.favoriteVCTitle, image: Consts.favoriteVCImage, vc: FavoriteNewsViewController(viewModel: viewModel))
        
        self.setViewControllers([homeVC, favouriteVC], animated: true)
    }
    
    private func createNav(with title: String, image: UIImage?, vc: UIViewController)-> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem.title = title
        navigationItem.title = title
        vc.title = title
        nav.tabBarItem.image = image
        return nav
    }
}

// MARK: - Consts
private extension TabBarController {
    enum Consts {
        static let homeVCTitle = "News"
        static let homeVCImage = UIImage(systemName: "newspaper")
        static let favoriteVCTitle = "Favorite"
        static let favoriteVCImage = UIImage(systemName: "star.fill")
    }
}
