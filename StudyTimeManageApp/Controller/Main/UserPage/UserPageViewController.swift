//
//  UserPageViewController.swift
//  StudyTimeManageApp
//
//  Created by Yabuki Shodai on 2021/12/14.
//

import UIKit
import PKHUD
import FirebaseFirestore

class UserPageViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var changeProfileButton: UIBarButtonItem!
    var userid = String()
    let database = Firestore.firestore()
    var recordArray:[userRecord] = [] {
        didSet{
            PKHUD.sharedHUD.hide(afterDelay: 0)
        }
    }
    var userName = String()
    let profileModel = studyTimeClass()
    var profileData = Profile(username: "No Name", goal: "goal", image:"", userid: "" )

    override func viewDidLoad() {
        super.viewDidLoad()
        if userid.isEmpty {
            
            let id = UserDefaults.standard.object(forKey: "userid")
            userid = id as! String
            print(userid)
            navigationItem.title = "Profile."
            profileData = Profile(username:profileModel.getUserName() , goal: profileModel.getGoal(), image: profileModel.getProfileImage(), userid: userid)
            
        }else{
            
            navigationItem.title = userName
            changeProfileButton.isEnabled = false
            changeProfileButton.tintColor = .clear
            getProfile(useid: userid)
            // profileDataをdatabaseから取得する
        }
        settingTableView()
       
        settingTableView()
        
        tableView.layer.borderColor = UIColor.systemGray3.cgColor
        tableView.layer.cornerRadius = 1
        tableView.layer.borderWidth = 1
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = .white
        print("呼ばれてます1")
        getData(userid:userid)
        profileData = Profile(username:profileModel.getUserName() , goal: profileModel.getGoal(), image: profileModel.getProfileImage(), userid: userid)
        tableView.reloadData()
    }

  
}

extension UserPageViewController:UITableViewDelegate,UITableViewDataSource,tableViewUpDater{
    func move() {}
    
    func tapLike(isLike: Bool, index: Int, count: Int) {}
    
    func sendtoProfile(userid: String, username: String) {}
    
    func updateTableView() {
        tableView.reloadData()
        print("Reload")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserProfileViewCell", for: indexPath) as! UserProfileViewCell
            
            cell.setSell(image: profileData.image, username: profileData.username, goal:profileData.goal )
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserRecordCell", for: indexPath) as! UserRecordCell
            cell.memoLabel.text = nil
            
            cell.setHomeCell(userid: userid,
                             username: profileData.username,
                             studyTime: recordArray[indexPath.row - 1].studyTime,
                             comment: recordArray[indexPath.row - 1].comment,
                             date: recordArray[indexPath.row - 1].date,
                             postid: recordArray[indexPath.row - 1].postID,
                             image: profileData.image)
            cell.delegate = self
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return  UITableView.automaticDimension
    }
    func settingTableView(){
        tableView.delegate = self
        tableView.dataSource = self
      
        tableView.rowHeight = UITableView.automaticDimension
        
        let RecordCell = UINib(nibName: "UserRecordCell", bundle: nil )
        tableView.register(RecordCell, forCellReuseIdentifier: "UserRecordCell")
        
        let UserProfileViewCell = UINib(nibName: "UserProfileViewCell", bundle: nil)
        tableView.register(UserProfileViewCell, forCellReuseIdentifier: "UserProfileViewCell")
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
  
            return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        if indexPath.row > 0{
            
            //詳細画面に遷移する
            print("詳細画面に遷移する")
            
            tableView.deselectRow(at: indexPath, animated: true)
            print("詳細画面に遷移します")
            let next = self.storyboard?.instantiateViewController(withIdentifier: "detail") as! DetailViewController
            next.record = Record(image: profileData.image, username: profileData.username,
                                 postid: recordArray[indexPath.row - 1].postID,
                                 userid: userid,
                                 studyTime: recordArray[indexPath.row - 1].studyTime,
                                 comment: recordArray[indexPath.row - 1 ].comment,
                                 date: recordArray[indexPath.row - 1].date,
                                 category: recordArray[indexPath.row - 1].category)
            
            self.navigationController?.pushViewController(next, animated: true)
        }
    }
    
}


extension UserPageViewController{
    
    func getData(userid:String){
        HUD.flash(.progress, delay: 2)
        print(userid)
        database.collection("Users").document(userid).collection("Record").order(by:"date", descending: true).getDocuments{[self] (querySnapshot, err) in
            
            self.recordArray = []
            if let err = err {
                print("エラー111\(err)")
                return
            } else {
                for document in querySnapshot!.documents {
                    
                    let data = document.data()
                    print("ここまでOK2")
                    if let studyTime = data["studytime"],
                       let comment   = data["comment"],
                       let postID    = data["postID"],
                       let timestamp = data["date"],
                       let category = data["category"]{
                        
                        let date:Date = (timestamp as AnyObject).dateValue()
                        let newData = userRecord(studyTime: studyTime as! Double, postID: postID as! String, comment: comment as! String, date: date , category:category as! String )
                        
                        recordArray.append(newData)
                        
                    }
                    else{
                        print("何かが足りてない")
                    }
                    
                
                }
                print(recordArray)
                tableView.reloadData()
            }
        }
    }
    func getProfile(useid:String){
        database.collection("Users").document(userid).getDocument{(querySnapshot, err) in
            let data = querySnapshot?.data()
            if let username = data?["username"],
               let image    = data?["image"],
               let goal     = data?["goal"]{
                self.profileData = Profile(username: username as! String, goal: goal as! String , image: image as! String, userid: self.userid)
            }
        }
        
    }
    
}