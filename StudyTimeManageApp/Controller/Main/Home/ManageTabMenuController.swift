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
        settings.style.buttonBarItemBackgroundColor = .link
           //セルの文字色
        settings.style.buttonBarItemTitleColor = UIColor.white
           //セレクトバーの色
        settings.style.selectedBarBackgroundColor = .black
        
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 12)
        
        settings.style.selectedBarHeight = 3
        settings.style.buttonBarMinimumInteritemSpacing = 0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
//        settings.style.button
        
        super.viewDidLoad()
        setNavBarBackgroundColor()
//        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        //管理されるViewControllerを返す処理

        
        //ToDo　自分で選択できるようにする
        let newVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainHome") as! HomeViewController
        let AVC   = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainHome") as! HomeViewController
        let BVC   = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainHome") as! HomeViewController
        let CVC   = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainHome") as! HomeViewController
        let DVC   = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainHome") as! HomeViewController
        let EVC   = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainHome") as! HomeViewController
        
      
        newVC.itemInfo = "新 着"
        AVC.itemInfo = "スキルアップ"
        BVC.itemInfo = "受験勉強"
        CVC.itemInfo = "資格取得"
        DVC.itemInfo = "趣味"
        EVC.itemInfo = "読書"
       
        
        let childViewControllers:[UIViewController] = [newVC, AVC,BVC,CVC,DVC,EVC]
        return childViewControllers
    }
    @IBAction func tapMenuButton(_ sender: Any) {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "blockuser") as! BlockUserViewController
        self.navigationController?.pushViewController(next, animated: true)
    }
    @IBAction func post(_ sender: Any) {
        //投稿画面に遷移する
        let next = self.storyboard?.instantiateViewController(withIdentifier: "record") as! RecordViewController
        self.navigationController?.pushViewController(next, animated: true)
        
    }
    func setNavBarBackgroundColor(){
        setStatusBarBackgroundColor(.link)
        self.navigationController?.navigationBar.barTintColor = .link
        self.navigationController?.navigationBar.tintColor = .white
        // ナビゲーションバーのテキストを変更する
        self.navigationController?.navigationBar.titleTextAttributes = [
        // 文字の色
            .foregroundColor: UIColor.white
        ]
    }
}
