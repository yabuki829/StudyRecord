//
//  TabbarController.swift
//  StudyTimeManageApp
//
//  Created by Yabuki Shodai on 2022/01/21.
//

import UIKit

class TabbarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        UITabBar.appearance().tintColor = UIColor.link
        // Do any additional setup after loading the view.
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        tabBar.tintColor = UIColor.link

    }

}
