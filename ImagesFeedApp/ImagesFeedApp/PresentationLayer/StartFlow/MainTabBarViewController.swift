//
//  MainTabBarViewController.swift
//  ImagesFeedApp
//
//  Created by Людмила Долонтаева on 6/13/23.
//

import UIKit

final class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        generateTabBar()
        setTabBarTintColor()
        addSeparatorLine()
    }

    private func generateTabBar() {
        viewControllers = [
            generateNavigationVC(
                viewController: ImagesFeedViewController(),
                title: "Images",
                imageName: "photo.stack"
            ),
            generateNavigationVC(
                viewController: FavoritesViewController(),
                title: "Favorites",
                imageName: "star"
            )
        ]
    }

    private func generateNavigationVC(
        viewController: UIViewController,
        title: String,
        imageName: String) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: viewController)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = UIImage(systemName: imageName)
        return navigationVC
    }

    private func setTabBarTintColor() {
//        tabBar.tintColor = AppColor.primaryGreenColor.color
//        tabBar.backgroundColor = AppColor.primaryDarkGrayColor.color
//        tabBar.unselectedItemTintColor = UIColor.darkGray
    }

    private func addSeparatorLine() {
        let separatorLine = UIView(frame: CGRect(x: 0, y: 0, width: tabBar.frame.width, height: 0.17))
        separatorLine.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
        tabBar.addSubview(separatorLine)
    }
}
