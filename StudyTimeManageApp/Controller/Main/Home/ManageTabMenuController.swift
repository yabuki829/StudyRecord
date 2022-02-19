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
        let EVC   = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainHome") as! HomeViewController
        let FVC   = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainHome") as! HomeViewController
        let GVC   = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainHome") as! HomeViewController
        let HVC   = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainHome") as! HomeViewController
        let IVC   = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainHome") as! HomeViewController
        let JVC   = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainHome") as! HomeViewController
        let KVC   = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainHome") as! HomeViewController
        let LVC   = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainHome") as! HomeViewController
        let MVC   = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainHome") as! HomeViewController
        let NVC   = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainHome") as! HomeViewController

        newVC.itemInfo = "新 着"
        AVC.itemInfo = "受験勉強"
        BVC.itemInfo = "資格取得 "
        CVC.itemInfo = "スキルアップ"
        DVC.itemInfo = "趣 味"
        EVC.itemInfo = "法律/政治系"
        FVC.itemInfo = "経済/経営/商学系"
        GVC.itemInfo = "社会/メディア系"
        HVC.itemInfo = "外国語系"
        IVC.itemInfo = "文学/人文学/心理学系"
        JVC.itemInfo = "教育/福祉系"
        KVC.itemInfo = "芸術系"
        LVC.itemInfo = "教養系"
        MVC.itemInfo = "理/工学系"
        NVC.itemInfo =  "医学/歯科学/薬学系"
        
        
        
        
        
        
        let childViewControllers:[UIViewController] = [newVC, AVC,BVC,CVC,DVC,EVC,FVC,GVC,HVC,IVC,JVC,KVC,LVC,MVC,NVC]
        return childViewControllers
    }
}
