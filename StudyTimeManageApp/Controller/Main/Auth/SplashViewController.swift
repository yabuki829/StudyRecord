//
//  SplashViewController.swift
//  StudyTimeManageApp
//
//  Created by Yabuki Shodai on 2022/01/16.
//

import UIKit
import Lottie
import FirebaseAuth
import AuthenticationServices

class SplashViewController: UIViewController {

    var animationView: AnimationView = {
        var view = AnimationView()
        view = AnimationView(name:"barchart")
        view.backgroundColor = .clear
        
        view.isUserInteractionEnabled = true
        view.contentMode = .scaleAspectFit
        view.loopMode = .loop
        view.play()
        return view
    }()
    
    let phoneLoginButton:UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("電話でログイン", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.systemGray4, for: .highlighted)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        return button
    }()
    
    let twitterLoginButton:UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Twiiterアカウントでログイン", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.backgroundColor = .systemTeal
        button.setTitleColor(.systemGray4, for: .highlighted)
        button.setTitleColor(.white, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        return button
    }()
    
    let appleLoginButton:ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        return button
    }()
    
    let googleLoginButton:UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Googleアカウントでログイン", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.backgroundColor = .white
        
        button.setTitleColor(.darkGray, for: .normal)
        button.setTitleColor(.systemGray4, for: .highlighted)
        
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.layer.borderWidth = 0.2
        return button
    }()

    
    let termButton:UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("利用規約", for: .normal)
        
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.systemGray4, for: .highlighted)
        
        button.layer.masksToBounds = true
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
//
        if Auth.auth().currentUser == nil || UserDefaults.standard.object(forKey: "userid") == nil {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.setNavigationBarHidden(false, animated: false)
            setNavBarColor()
            setupViews()
        }
       
    }
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil  && UserDefaults.standard.object(forKey: "userid") != nil {
            
            print("Homeに遷移します")
            performSegue(withIdentifier: "home", sender: nil)
        }
        
    }

    

    private func setupViews(){
        view.addSubview(animationView)
        view.addSubview(phoneLoginButton)
        view.addSubview(appleLoginButton)
        view.addSubview(googleLoginButton)
        view.addSubview(twitterLoginButton)
        view.addSubview(termButton)
        
        addAnimationviewConstraint()
        addButtonConstraint()
    }
    func addAnimationviewConstraint(){
        let guide = self.view.safeAreaLayoutGuide
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.topAnchor.constraint(equalTo:guide.topAnchor, constant: 0.0).isActive = true
        animationView.heightAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        animationView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
    }
    func addButtonConstraint(){
        let guide = self.view.safeAreaLayoutGuide
        
        phoneLoginButton.topAnchor.constraint(equalTo:animationView.bottomAnchor, constant: 0.0).isActive = true
        phoneLoginButton.leftAnchor.constraint(equalTo: guide.leftAnchor, constant: 80.0).isActive = true
        phoneLoginButton.rightAnchor.constraint(equalTo: guide.rightAnchor, constant:-80.0).isActive = true
        
        appleLoginButton.topAnchor.constraint(equalTo:phoneLoginButton.bottomAnchor, constant:8.0).isActive = true
        appleLoginButton.leftAnchor.constraint(equalTo: guide.leftAnchor, constant: 80.0).isActive = true
        appleLoginButton.rightAnchor.constraint(equalTo: guide.rightAnchor, constant:-80.0).isActive = true
        
        googleLoginButton.topAnchor.constraint(equalTo:appleLoginButton.bottomAnchor, constant: 8.0).isActive = true
        googleLoginButton.leftAnchor.constraint(equalTo: guide.leftAnchor, constant: 80.0).isActive = true
        googleLoginButton.rightAnchor.constraint(equalTo: guide.rightAnchor, constant:-80.0).isActive = true
        
        
        twitterLoginButton.topAnchor.constraint(equalTo:googleLoginButton.bottomAnchor, constant: 8.0).isActive = true
        twitterLoginButton.leftAnchor.constraint(equalTo: guide.leftAnchor, constant: 80.0).isActive = true
        twitterLoginButton.rightAnchor.constraint(equalTo: guide.rightAnchor, constant:-80.0).isActive = true
        
        
        termButton.topAnchor.constraint(equalTo:twitterLoginButton.bottomAnchor, constant: 32.0).isActive = true
        termButton.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        
        
    }
   
    @objc internal func onClickTerm(sender:UIButton){
        let url = URL(string: "https://studyrecordjp.herokuapp.com/next.html")
        UIApplication.shared.open(url!)
    }
    @objc internal func onClickLogin(sender: UIButton) {
         
        let next = self.storyboard?.instantiateViewController(withIdentifier: "phoneLogin") as! LoginViewController
        self.navigationController?.pushViewController(next, animated: true)
    }
    func setNavBarColor(){
        setStatusBarBackgroundColor(.link)
        self.navigationController?.navigationBar.barTintColor = .link
        self.navigationController?.navigationBar.largeTitleTextAttributes =  [
            // 文字の色
                .foregroundColor: UIColor.white
            ]
        // ナビゲーションバーのテキストを変更する
        self.navigationController?.navigationBar.titleTextAttributes = [
        // 文字の色
            .foregroundColor: UIColor.white
        ]
    }
}
    
