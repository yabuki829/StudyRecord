//
//  LoginViewController.swift
//  StudyTimeManageApp
//
//  Created by Yabuki Shodai on 2022/02/25.
//

import UIKit
import IQKeyboardManagerSwift
import FirebaseAuth

class LoginViewController: UIViewController ,UITextFieldDelegate{

    @IBOutlet weak var textField: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBarColor()
//        navigationController
    }
    override func viewWillAppear(_ animated: Bool) {
        textField.becomeFirstResponder()
    }
  
    @IBAction func tapNext(_ sender: Any) {
        let number = "+81" + textField.text!.dropFirst()
        print(number)
        if textField.text!.count >= 10 {
            print(number)
            AuthManager.shered.startAuth(phoneNumber: number ) {  result in
                if result == false{
                  
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
