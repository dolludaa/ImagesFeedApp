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
    addSeparatorLine()
  }

  private func generateTabBar() {
    viewControllers = [
      generateNavigationVC(
        viewController: ImagesFeedViewControllerAssembly().create(),
        title: "Images",
        imageName: "photo.stack"
      ),
      generateNavigationVC(
        viewController: FavoritesViewControllerAssembly().create(),
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

  private func addSeparatorLine() {
    let appearance = UITabBarAppearance()
    appearance.configureWithDefaultBackground()

    appearance.shadowColor = UIColor.gray.withAlphaComponent(0.3)
    appearance.shadowImage = UIImage()

    tabBar.scrollEdgeAppearance = appearance
  }
}
