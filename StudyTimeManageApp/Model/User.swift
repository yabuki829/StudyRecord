//
//  User.swift
//  StudyTimeManageApp
//
//  Created by Yabuki Shodai on 2022/03/15.
//

import Foundation


class UserModel{
    
    func getTodayGoal() -> String{
        if let goal = UserDefaults.standard.object(forKey: "todayGoal"){
            return goal as! String
        }
        return ""
    }
    func getHowMany() -> howDays{
        if let howmany:howDays = UserDefaults.standard.codable(forKey: "until"){
            return howmany
        }
        return howDays(date:Date(), title: "")
    }
   
 
       
}

