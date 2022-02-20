//
//  ManageTabMenuController.swift
//  StudyTimeManageApp
//
//  Created by Yabuki Shodai on 2022/01/19.
//

import UIKit
import XLPagerTabStrip
class ManageTabMenuController: ButtonBarPagerTabStripViewController {

    override func viewDidLoad() {
        
           //ボタンの色
        settings.style.buttonBarItemBackgroundColor = .green
           //セルの文字色
        settings.style.buttonBarItemTitleColor = UIColor.black
           //セレクトバーの色
        settings.style.selectedBarBackgroundColor = .black
        
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 12)
        
        settings.style.selectedBarHeight = 3
        settings.style.buttonBarMinimumInteritemSpacing = 0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
//        settings.style.button
        
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = .green
//        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        //管理されるViewControllerを返す処理

        let newVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainHome") as! HomeViewController
        let AVC   = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainHome") as! HomeViewController
        let BVC   = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainHome") as! HomeViewController
        let CVC   = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainHome") as! HomeViewController
        let DVC   = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainHome") as! HomeViewController

        newVC.itemInfo = "新 着"
        AVC.itemInfo = "スキルアップ"
        BVC.itemInfo = "受験勉強"
        CVC.itemInfo = "資格取得"
        DVC.itemInfo = "趣 味"
       
        
        let childViewControllers:[UIViewController] = [newVC, AVC,BVC,CVC,DVC]
        return childViewControllers
    }
}
