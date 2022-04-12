//
//  FriendStudyTimeViewController.swift
//  StudyTimeManageApp

//     イラスト：Loose Drawing, open doodles ,linustock
//  Created by Yabuki Shodai on 2021/12/21.
//

import UIKit
import FirebaseFirestore

class FriendStudyTimeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var likeButton: UIBarButtonItem!
    
    let database = Firestore.firestore()
    var friendData = Profile(username: "", goal: "", image: "", userid: "")
    var friendStudyData = studyTime(total: 0, month: 0, day: 0)
    var followFrinendArray = [Profile]()
    var recordArray = [userRecord]()
    var isLike = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingTableView()
        followFrinendArray = getFriend()
        setNavBarBackgroundColor()
        isFollow()
        getTotal()
        getData(userid: friendData.userid)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        setNavBarBackgroundColor()
    }
    @IBAction func like(_ sender: Any) {
        isLike = !isLike
        follow()
    }
    func setNavBarBackgroundColor(){
        setStatusBarBackgroundColor(.link)
        self.navigationController?.navigationBar.barTintColor = .link
        self.navigationController?.navigationBar.tintColor = .white
        // ナビゲーションバーのテキストを変更する
        self.navigationController?.navigationBar.titleTextAttributes = [
        // 文字の色
            .foregroundColor: UIColor.white
        ]
    }
    func follow(){
        if isLike {
            likeButton.image = UIImage(systemName: "star.fill")
            followFrinendArray.append(friendData)
            UserDefaults.standard.setCodable(followFrinendArray, forKey: "friend")
        }
        else{
            likeButton.image = UIImage(systemName: "star")
            
            for i in 0..<followFrinendArray.count{
                if followFrinendArray[i].username == friendData.username && followFrinendArray[i].goal == friendData.goal{
                    followFrinendArray.remove(at: i)
                    UserDefaults.standard.setCodable(followFrinendArray, forKey: "friend")
                }
            }
           
            
            //frienddataを配列で削除する
        }
    }
    func isFollow(){
        for i in 0..<followFrinendArray.count{
            if followFrinendArray[i].username == friendData.username && followFrinendArray[i].goal == friendData.goal{
                likeButton.image = UIImage(systemName: "star.fill")
                isLike = true
            }
        }
    }
    func getFriend() -> [Profile]{
        if let a:[Profile] = UserDefaults.standard.codable(forKey: "friend"){
            followFrinendArray = a
        }
        return followFrinendArray
    }
    func settingTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        
        let PieChartCell = UINib(nibName: "PieChartCell", bundle: nil )
        tableView.register(PieChartCell, forCellReuseIdentifier: "PieChartCell")
        
        let DataViewCell = UINib(nibName: "DataViewCell", bundle: nil )
        tableView.register(DataViewCell, forCellReuseIdentifier: "DataViewCell")
        
        let RecordCell = UINib(nibName: "UserRecordCell", bundle: nil )
        tableView.register(RecordCell, forCellReuseIdentifier: "UserRecordCell")
    }
    func getStudyTime(){
        
    }
    
    
    func getTotal(){
        
        database.collection("Users").document(friendData.userid).collection("Total").document("Time").getDocument{ (querySnapshot, err) in
            if let err = err {
                print(err)
                return
            } else {
                print("ここまでOK")
                let data = querySnapshot!.data()
                print("ここまでOK2")
                if let total = data?["total"],
                   let month = data?["month"],
                   let day   = data?["today"]{
                    print("ここまでOK3")
                    let newData =
                        studyTime(total: total as! Double, month: month as! Double, day: day as! Double )
                    
                    self.friendStudyData = newData
                
                   
                }
                self.tableView.reloadData()
            }
        }
    }
    func getData(userid:String){
        database.collection("Users").document(userid).collection("Record").order(by:"date", descending: true).getDocuments{[self] (querySnapshot, err) in
            
            self.recordArray = []
            if let err = err {
                print("エラー\(err)")
                return
            } else {
                for document in querySnapshot!.documents {
                    
                    let data = document.data()
                    print("ここまでOK2")
                    if let studyTime = data["studytime"],
                       let comment   = data["comment"],
                       let postID    = data["postID"],
                       let timestamp = data["date"],
                       let category  = data["category"]{
                        
                        let date:Date = (timestamp as AnyObject).dateValue()
                        let newData = userRecord(studyTime: studyTime as! Double, postID: postID as! String, comment: comment as! String, date: date, category: category as! String)
                        recordArray.append(newData)
                        
                    }
                    else{
                        print("エラー")
                    }
                    
                
                }
                tableView.reloadData()
            }
        }
    }
}


extension FriendStudyTimeViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3 + recordArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PieChartCell", for: indexPath) as! PieChartCell
            cell.setCell(total:friendStudyData.total , time: 10000)
            return cell
        }
        else if indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "DataViewCell", for: indexPath) as! DataViewCell
            cell.setCell(day: friendStudyData.day, month: friendStudyData.month, total: friendStudyData.total, color: "link")
            return cell
        }
        else if indexPath.row  == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "goalCell", for: indexPath)
            let goalLabel = cell.viewWithTag(1) as! UILabel
            goalLabel.text = friendData.goal
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserRecordCell", for: indexPath) as! UserRecordCell
            cell.setHomeCell(userid: friendData.userid,
                             username: friendData.username,
                             studyTime: recordArray[indexPath.row - 3].studyTime,
                             comment: recordArray[indexPath.row - 3].comment,
                             date: recordArray[indexPath.row - 3 ].date,
                             postid: recordArray[indexPath.row - 3].postID,
                             image: friendData.image)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 180
        }
        else if indexPath.row == 1{
            return 80
        }
        else {
            return  UITableView.automaticDimension
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0{
            
        }
        else if indexPath.row == 1{
        }
        else if indexPath.row >= 3{
            let next = self.storyboard?.instantiateViewController(withIdentifier: "detail") as! DetailViewController
            next.record = Record(image: friendData.image, username: friendData.username,
                                 postid: recordArray[indexPath.row - 3].postID,
                                 userid: friendData.userid,
                                 studyTime: recordArray[indexPath.row - 3].studyTime,
                                 comment: recordArray[indexPath.row - 3 ].comment,
                                 date: recordArray[indexPath.row - 3].date,
                                 category: recordArray[indexPath.row - 3].category)
            self.navigationController?.pushViewController(next, animated: true)
        }
        
    }
    
}
