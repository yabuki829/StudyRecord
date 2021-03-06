//
//  Alert.swift
//  StudyTimeManageApp
//
//  Created by Yabuki Shodai on 2022/03/15.
//


//ViewControllerをきれいにするために表示するだけのAlertを集めてる

import Foundation
import UIKit

class Alert{
    func showFriendID() -> UIAlertController{
        
        let id = UserDefaults.standard.object(forKey: "friendid")
        let alert = UIAlertController(title: "your FriendID" , message:id as? String, preferredStyle: .alert)

        let selectAction = UIAlertAction(title: "Copy", style: .default, handler: { _ in
            let pasteboard = UIPasteboard.general
            pasteboard.string = id as? String

              let generator = UISelectionFeedbackGenerator()
              generator.prepare()
              generator.selectionChanged()
           
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alert.addAction(selectAction)
        alert.addAction(cancelAction)
        return alert
    
    }
    func errorFriendID() -> UIAlertController{
        let alert = UIAlertController(title: "適切なFriendIDを入力してください" , message:"", preferredStyle: .alert)

        let ok = UIAlertAction(title: "OK", style: .default)
      
        alert.addAction(ok)
        return alert
    }
    func enterStudyTime() -> UIAlertController {
        let alert = UIAlertController(title: "勉強時間を入力してください" , message:"", preferredStyle: .alert)

        let ok = UIAlertAction(title: "OK", style: .default)
      
        alert.addAction(ok)
        return alert
    }
    
    func enterCategory() -> UIAlertController{
        let alert = UIAlertController(title: "カテゴリを選択してください" , message:"", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default)
      
        alert.addAction(ok)
        return alert
    }
    
    
}
