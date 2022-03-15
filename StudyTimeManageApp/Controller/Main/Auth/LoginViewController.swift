//
//  LoginViewController.swift
//  StudyTimeManageApp
//
//  Created by Yabuki Shodai on 2022/02/25.
//

import UIKit
import IQKeyboardManagerSwift

class LoginViewController: UIViewController ,UITextFieldDelegate{

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
            numberLabel.text = "電話番号を入力してください。"
        }
        else if textField.text!.count <= 11{
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
        print("次へ")
        let number = "+81" + textField.text!.dropFirst()
        print(number)
        if textField.text?.count == 11 {
            
            AuthManager.shered.startAuth(phoneNumber: number ) {  result in
                if result == false{
                    print("エラーーーーーーーーーーー")
                    return
                }
                DispatchQueue.main.async {
                    let next = self.storyboard?.instantiateViewController(withIdentifier: "sms") as! SMSViewController
                    self.navigationController?.pushViewController(next, animated: true)
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
    }

}
