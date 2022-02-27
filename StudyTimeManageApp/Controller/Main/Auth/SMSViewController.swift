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
        IQKeyboardManager.shared.shouldResignOnTouchOutside = false
        textField.becomeFirstResponder()
        textField.delegate = self
        textField.isHidden = true
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
       
        if Int(textField.text!.count) == 0{
            print("呼ばれてます")
            numberLabel.textAlignment = .right
            numberLabel.font = UIFont.systemFont(ofSize: 17.0)
            numberLabel.text = "認証番号を入力してください。"
        }
        else if textField.text!.count <= 5 && textField.text?.count != 6{
            numberLabel.textAlignment = .center
            numberLabel.font = UIFont.systemFont(ofSize: 30.0)
            numberLabel.text = textField.text!
        }
        else if textField.text!.count == 6{
            numberLabel.text = textField.text!
//            認証をする
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
        label.text = "認証コードを入力してください"
        self.navigationItem.titleView = label
    }

}
