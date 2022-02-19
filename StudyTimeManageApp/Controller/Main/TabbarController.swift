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
        
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.title == "10000hours"{
            tabBar.tintColor = UIColor.link
          
        }
        else if item.title == "Home"{
            tabBar.tintColor = UIColor.systemGreen
            
        }
        else if item.title == "Rival"{
            tabBar.tintColor = UIColor.systemRed
        }
        else{
            tabBar.tintColor = UIColor.darkGray
        }

    }

}
