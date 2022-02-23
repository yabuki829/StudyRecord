//
//  SplashViewController.swift
//  StudyTimeManageApp
//
//  Created by Yabuki Shodai on 2022/01/16.
//

import UIKit
import Lottie

class SplashViewController: UIViewController {
   
    var animationView: AnimationView!
    let loginButton = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        if UserDefaults.standard.object(forKey: "userid") == nil{
            addAnimationView()
            setLoginButtonAndTermButton()
        }
       
    }
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.object(forKey: "userid") != nil{
            print("Homeに遷移します")
            performSegue(withIdentifier: "home", sender: nil)
        }
        
    }

    func addAnimationView() {

            //アニメーションファイルの指定
            animationView = AnimationView(name:  "boy")

            //アニメーションの位置指定（画面中央）
            animationView.frame = CGRect(x: 0, y: -20, width: self.view.bounds.width, height: self.view.bounds.height)
            animationView.backgroundColor = .clear
            animationView.isUserInteractionEnabled = true
            //アニメーションのアスペクト比を指定＆ループで開始
            animationView.contentMode = .scaleAspectFit
            animationView.loopMode = .loop
            animationView.play()
            //ViewControllerに配置
            view.addSubview(animationView)
        }
    
    func setLoginButtonAndTermButton(){
     
        let bWidth: CGFloat = 200
        let bHeight: CGFloat = 50
        
        // ボタンのX,Y座標.
        let posX: CGFloat = self.view.frame.width/2 - bWidth/2
        let posY: CGFloat = self.view.frame.height/2 + bHeight * 2
        
        loginButton.frame = CGRect(x: posX, y: posY, width: bWidth, height: bHeight)
        loginButton.backgroundColor = .darkGray
        loginButton.tintColor = .white
        loginButton.setTitle("始める", for: .normal)
        loginButton.setTitleColor(UIColor.white, for: .normal)
        loginButton.layer.masksToBounds = true

        loginButton.layer.cornerRadius = 10
        loginButton.tag = 1

        loginButton.addTarget(self, action: #selector(SplashViewController.onClickLogin(sender:)), for: .touchUpInside)
        self.view.addSubview(loginButton)
        
        let termButton = UIButton()
        let termWidth:CGFloat = 200
        let termHeight:CGFloat = 20
        let termX:CGFloat = self.view.frame.width/2 - termWidth/2
        let termY:CGFloat = self.view.frame.height/2 + bHeight * 3 + termHeight * 2
        termButton.frame = CGRect(x: termX, y: termY, width: termWidth, height: termHeight)
        termButton.setTitle("利用規約", for: .normal)
        termButton.setTitleColor(UIColor.darkGray, for: .normal)
        termButton.addTarget(self, action: #selector(SplashViewController.onClickTerm(sender:)), for: .touchUpInside)
        self.view.addSubview(termButton)
    }
    @objc internal func onClickTerm(sender:UIButton){
        let anotherStoryboard:UIStoryboard = UIStoryboard(name: "Menu", bundle: nil)
         
        //生成するViewControllerを指定
        let VC = anotherStoryboard.instantiateViewController(withIdentifier: "term")
        //表示
        self.present(VC, animated: true, completion: nil)
    }
    @objc internal func onClickLogin(sender: UIButton) {
        alert()
    }
    func alert(){
        let alert = UIAlertController(title: "利用規約確認しましたか？", message: "", preferredStyle: .alert)
        let selectAction = UIAlertAction(title: "確認しました", style: .default, handler: { _ in
            let database = Database()
            database.registerUser()
            self.performSegue(withIdentifier: "home", sender: nil)
           
        })
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)

        alert.addAction(selectAction)
        alert.addAction(cancelAction)

        present(alert, animated: true)
    }
}
