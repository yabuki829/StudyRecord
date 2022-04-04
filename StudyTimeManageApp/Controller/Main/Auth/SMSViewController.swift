//
//  SMSViewController.swift
//  StudyTimeManageApp
//
//  Created by Yabuki Shodai on 2022/02/25.
//

import UIKit
import IQKeyboardManagerSwift

class SMSViewController: UIViewController ,UITextFieldDelegate{

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var numberLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBarColor()
        navigationController?.navigationBar.prefersLargeTitles = true
        setTextField()
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
       
        if Int(textField.text!.count) == 0{
            print("呼ばれてます")
            numberLabel.textAlignment = .left
            numberLabel.font = UIFont.systemFont(ofSize: 17.0)
            numberLabel.text = "6桁の認証番号を入力してください。"
        }
        else if textField.text!.count <= 6{
            numberLabel.textAlignment = .center
            numberLabel.font = UIFont.systemFont(ofSize: 30.0)
            numberLabel.text = textField.text!
        }
        
       
        
    }
    
    func setTextField(){
        textField.isHidden = true
        textField.delegate = self
        textField.becomeFirstResponder()
        IQKeyboardManager.shared.shouldResignOnTouchOutside = false
        
        let enter = UIButton(frame: CGRect(x: 10, y: 5, width: self.view.bounds.width - 20 , height: 45))
            // Make a bar on the keyboard.
             let keyboardBar = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 55))
             keyboardBar.backgroundColor = UIColor.white
                enter.backgroundColor = UIColor.systemGreen
                enter.layer.cornerRadius = 20
                enter.setTitle("次へ", for: UIControl.State.normal)
                enter.setTitleColor(UIColor.white, for: UIControl.State.normal)
                enter.addTarget(self, action: #selector(tapNext), for: UIControl.Event.touchUpInside)

                // Make a cancel button.
              
                // Set the buttons.
                keyboardBar.addSubview(enter)
                

                // Set the bar.
                textField.inputAccessoryView = keyboardBar
    }
    @objc func tapNext(_ sender: UIButton){
          // タップした時の処理
      
            if textField.text?.count == 6 {
                
                let code = textField.text
                AuthManager.shered.vertifycode(smCode: code!) { ( result ) in
                    if result == false{
                        return
                    }
                    DispatchQueue.main.async {
                        print("Homeに遷移します")
                        self.performSegue(withIdentifier: "home", sender: nil)
                    }
                }
                
            }
        }
    func setNavBarColor(){
        setStatusBarBackgroundColor(.link)
        self.navigationController?.navigationBar.barTintColor = .white
        
        self.navigationController?.navigationBar.largeTitleTextAttributes =  [
            // 文字の色
                .foregroundColor: UIColor.white
            ]
        let label = UILabel()
        label.backgroundColor = .clear
        label.numberOfLines = 2
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        label.textAlignment = .center
        label.textColor = .white
        label.text = "認証番号"
        self.navigationItem.titleView = label
    }

}
