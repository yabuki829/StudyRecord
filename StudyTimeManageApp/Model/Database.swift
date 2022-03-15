//
//  Database.swift
//  10000hours
//
//  Created by Yabuki Shodai on 2021/12/05.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct StudyTime {
    var day:Double
    var month:Double
    var total:Double
}


class Database{
    static let shered = Database()
    let database = Firestore.firestore()
    var studyTime = StudyTime(day: 0.0, month: 0.0, total: 0.0)
    var dateModel = DateModel()
   
    func postGoal(goal:String,username:String,image:String){
        let userID = Auth.auth().currentUser!.uid
        database.collection("Users").document(userID).setData(
            ["username":username,"goal":goal,"image":image,"userid":userID]
        )
    }
    func tapGood(postID:String){
        database.collection("Good").document(postID).collection("good").document(Auth.auth().currentUser!.uid).setData(
            ["isGood":true]
        )
           
    }
    func saveMonthlyStudyTime(postDate:Date){
        print("セーブしました.===========================")
        let studyClass = studyTimeClass()
        let data = studyClass.getMonthlyStudyTime()
        
        let userid = UserDefaults.standard.object(forKey: "userid")
        print(data.month)
        
        let year = dateModel.convertDateToString(date: data.year, format: "yyyy年" )
        
        database.collection("Users").document(userid as! String).collection("MonthStudyTime").document(year).setData(
            ["year":postDate,"month":data.month]
        )
    }
  
    func postData(today:Double,month:Double,total:Double){
        //Today, Month, Total
//        今日の勉強時間　今月の勉強時間　総勉強時間　を記録する
        let userid = UserDefaults.standard.object(forKey: "userid")
        database.collection("Users").document(userid as! String).collection("Total").document("Time").setData(
            ["today":today,"month":month,"total":total]
        )
    }
    
    func postRecord(todayStudyTime:Double,comment:String,image:String,category:String,postDate:Date){

        let userName = UserDefaults.standard.object(forKey: "username") ?? "No Name"
        
        let postID = UUID().uuidString
        let userid = UserDefaults.standard.object(forKey: "userid")
        
        database.collection("Records").document(postID).setData(
            ["userid":userid as! String,
             "username":userName,"studytime":todayStudyTime,"date":Timestamp(date: postDate),"comment":comment,"postid":postID,"image":image,"category":category]
        )
        
        
//        profilepageの個人記録表示
        database.collection("Users").document(userid as! String).collection("Record").document(postID).setData(
            ["postID":postID,"studytime":todayStudyTime,"date":Timestamp(date: postDate),"comment":comment,"category":category]
        )
        
    }
    
    func postComment(comment:String,postID:String){
        
        let commentID = UUID().uuidString
        let profile = studyTimeClass()
        let username = profile.getUserName()
        let image    = profile.getProfileImage()
        let userid = UserDefaults.standard.object(forKey: "userid")
        database.collection("Comments").document(postID).collection("Comment").document(commentID).setData(
            ["username":username,"image":image,"postid":postID,"userid":userid as Any ,"commentid":commentID,"comment":comment,"date":Timestamp(date: Date())]
        )
    }
    
    
    func getStudyTimeData(){
        database.collection("Users").document(Auth.auth().currentUser!.uid).collection("Total").document("Time").getDocument{ [self] (querySnapshot, err) in
            if let err = err {
                print("エラー\(err)")
            } else {
                let data = querySnapshot!.data()
                if let day = data!["today"],
                   let month = data!["month"],  
                   let total = data!["total"]{
                    
                    studyTime = StudyTime(day:day as! Double, month: month as! Double, total: total as! Double)
                    
                }
            }
            
        }
    }
    
    func deleteComment(postID:String,commentID:String){
        database.collection("Comments").document(postID).collection("Comment").document(commentID).delete()
    }
    
    func deletePost(userid:String,postid:String){
        database.collection("Records").document(postid).delete()
        database.collection("Users").document(userid).collection("Record").document(postid).delete()
      
    }
    
    //reportedID 通報された人のid
    func report(report:String,reportedID:String,postID:String,comment:String){
        let userid = UserDefaults.standard.object(forKey: "userid")
        
        database.collection("Reports").document(postID).collection("comment").document(userid as! String).setData(
            ["report":report,"reporterID":userid as Any,"reportedID":reportedID,"comment":comment,"postID":postID]
        )
    }
    
    func reportUser(report:String,reportedID:String,postID:String,memo:String,username:String){
        let userid = UserDefaults.standard.object(forKey: "userid")
        database.collection("Reports").document(postID).collection("user").document(userid as! String).setData(
            ["report":report,"reporterID":userid as Any,"reportedID":reportedID,"postID":postID,"memo":memo,"username":username]
        )
    }
    func postFriendID(id:String){
        let userid = UserDefaults.standard.object(forKey: "userid")
        database.collection("UserID").document(id).setData(
            ["userID":userid]
        )
    }
}
