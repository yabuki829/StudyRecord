//
//  HomeViewController.swift
//  StudyTimeManageApp
//
//  Created by Yabuki Shodai on 2021/12/15.
//

import UIKit
import FirebaseFirestore
import PKHUD
import XLPagerTabStrip

class HomeViewController: UIViewController,IndicatorInfoProvider {

    var itemInfo: IndicatorInfo = "Home"
    @IBOutlet weak var tableView: UITableView!
    let refreshControl = UIRefreshControl()
    let database = Firestore.firestore()
    var recordArray:[Record] = []
    var adCount = 0
    
    var isFinish:Bool = false {
        didSet{
            print("取得完了")
            PKHUD.sharedHUD.hide(afterDelay: 0)
            tableView.reloadData()
        }
    }
    
    
  
    var isGood = Bool()
    var goodCountArray = [Int]()
    var goodArray = [Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        settingTableView()
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(HomeViewController.refresh(sender:)), for: .valueChanged)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setStatusBarBackgroundColor(.green)
        if itemInfo.title == "新 着"{
            print("新着")
            getRecord()
        }
        else{
            getRecordFilteringCategory()
        }
    }
    @objc func refresh(sender: UIRefreshControl) {
            // ここが引っ張られるたびに呼び出される
            // 通信終了後、endRefreshingを実行することでロードインジケーター（くるくる）が終了
        if itemInfo.title == "新 着"{
            getRecord()
        }
        else{
            getRecordFilteringCategory()
        }
        refreshControl.endRefreshing()
    }
    //必須
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }


    
    
}




extension HomeViewController:UITableViewDelegate,UITableViewDataSource,tableViewUpDater{
    func move() {}
    
    func tapLike(isLike: Bool, index: Int, count: Int) {}
    
    func sendtoProfile(userid: String,username: String) {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "userpage") as! UserPageViewController
        next.userid = userid
        next.userName = username
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    func updateTableView() {
        tableView.reloadData()
        print("Reload")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return recordArray.count + recordArray.count / 10
                
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 11 || indexPath.row == 22 || indexPath.row == 33 || indexPath.row == 44 || indexPath.row == 55 || indexPath.row == 66 || indexPath.row == 77 || indexPath.row == 88 || indexPath.row == 99 || indexPath.row == 110 {
            //広告の表示
            let cell = tableView.dequeueReusableCell(withIdentifier: "AdTableViewCell", for: indexPath) as! AdTableViewCell
            
            return cell
        }
        else{
            if indexPath.row / 11  == 0{
                adCount = 0
                let cell = tableView.dequeueReusableCell(withIdentifier: "UserRecordCell", for: indexPath) as! UserRecordCell
                cell.memoLabel.text = nil
                cell.textLabel?.text = nil
                cell.profileImage.image = nil
                cell.dateLabel.text = nil
                    cell.setHomeCell(userid:   self.recordArray[indexPath.row].userid,
                                     username: self.recordArray[indexPath.row].username,
                                     studyTime:self.recordArray[indexPath.row].studyTime,
                                     comment:  self.recordArray[indexPath.row].comment,
                                     date:     self.recordArray[indexPath.row].date,
                                     postid:   self.recordArray[indexPath.row].postid,
                                     image:    self.recordArray[indexPath.row].image)
                
              
                return cell
                //レコードの表示
            }
            else if indexPath.row / 11 == 1{
                adCount = 1
                print("投稿")
                print(adCount)
                let cell = tableView.dequeueReusableCell(withIdentifier: "UserRecordCell", for: indexPath) as! UserRecordCell
                cell.memoLabel.text = nil
                cell.textLabel?.text = nil
                cell.profileImage.image = nil
                cell.dateLabel.text = nil
                    cell.setHomeCell(userid:   self.recordArray[indexPath.row - adCount].userid,
                                     username: self.recordArray[indexPath.row - adCount].username,
                                     studyTime:self.recordArray[indexPath.row - adCount].studyTime,
                                     comment:  self.recordArray[indexPath.row - adCount].comment,
                                     date:     self.recordArray[indexPath.row - adCount].date,
                                     postid:   self.recordArray[indexPath.row - adCount].postid,
                                     image:    self.recordArray[indexPath.row - adCount].image)
                
              
                return cell
            }
            else if indexPath.row / 11 == 2{
                adCount = 2
                let cell = tableView.dequeueReusableCell(withIdentifier: "UserRecordCell", for: indexPath) as! UserRecordCell
                cell.memoLabel.text = nil
                cell.textLabel?.text = nil
                cell.profileImage.image = nil
                cell.dateLabel.text = nil
                    cell.setHomeCell(userid:   self.recordArray[indexPath.row - adCount].userid,
                                     username: self.recordArray[indexPath.row - adCount].username,
                                     studyTime:self.recordArray[indexPath.row - adCount].studyTime,
                                     comment:  self.recordArray[indexPath.row - adCount].comment,
                                     date:     self.recordArray[indexPath.row - adCount].date,
                                     postid:   self.recordArray[indexPath.row - adCount].postid,
                                     image:    self.recordArray[indexPath.row - adCount].image)
                
              
                return cell
            }
            else if indexPath.row / 11 == 3{
                adCount = 3
                let cell = tableView.dequeueReusableCell(withIdentifier: "UserRecordCell", for: indexPath) as! UserRecordCell
                cell.memoLabel.text = nil
                cell.textLabel?.text = nil
                cell.profileImage.image = nil
                cell.dateLabel.text = nil
                    cell.setHomeCell(userid:   self.recordArray[indexPath.row - adCount].userid,
                                     username: self.recordArray[indexPath.row - adCount].username,
                                     studyTime:self.recordArray[indexPath.row - adCount].studyTime,
                                     comment:  self.recordArray[indexPath.row - adCount].comment,
                                     date:     self.recordArray[indexPath.row - adCount].date,
                                     postid:   self.recordArray[indexPath.row - adCount].postid,
                                     image:    self.recordArray[indexPath.row - adCount].image)
                
              
                return cell
            }
            else if indexPath.row / 11 == 4{
                adCount = 4
                let cell = tableView.dequeueReusableCell(withIdentifier: "UserRecordCell", for: indexPath) as! UserRecordCell
                cell.memoLabel.text = nil
                cell.textLabel?.text = nil
                cell.profileImage.image = nil
                cell.dateLabel.text = nil
                    cell.setHomeCell(userid:   self.recordArray[indexPath.row - adCount].userid,
                                     username: self.recordArray[indexPath.row - adCount].username,
                                     studyTime:self.recordArray[indexPath.row - adCount].studyTime,
                                     comment:  self.recordArray[indexPath.row - adCount].comment,
                                     date:     self.recordArray[indexPath.row - adCount].date,
                                     postid:   self.recordArray[indexPath.row - adCount].postid,
                                     image:    self.recordArray[indexPath.row - adCount].image)
                
              
                return cell
            }
            else if indexPath.row / 11 == 5{
                adCount = 5
                let cell = tableView.dequeueReusableCell(withIdentifier: "UserRecordCell", for: indexPath) as! UserRecordCell
                cell.memoLabel.text = nil
                cell.textLabel?.text = nil
                cell.profileImage.image = nil
                cell.dateLabel.text = nil
                    cell.setHomeCell(userid:   self.recordArray[indexPath.row - adCount].userid,
                                     username: self.recordArray[indexPath.row - adCount].username,
                                     studyTime:self.recordArray[indexPath.row - adCount].studyTime,
                                     comment:  self.recordArray[indexPath.row - adCount].comment,
                                     date:     self.recordArray[indexPath.row - adCount].date,
                                     postid:   self.recordArray[indexPath.row - adCount].postid,
                                     image:    self.recordArray[indexPath.row - adCount].image)
                
              
                return cell
            }
            else if indexPath.row / 11 == 6{
                adCount = 6
                let cell = tableView.dequeueReusableCell(withIdentifier: "UserRecordCell", for: indexPath) as! UserRecordCell
                cell.memoLabel.text = nil
                cell.textLabel?.text = nil
                cell.profileImage.image = nil
                cell.dateLabel.text = nil
                    cell.setHomeCell(userid:   self.recordArray[indexPath.row - adCount].userid,
                                     username: self.recordArray[indexPath.row - adCount].username,
                                     studyTime:self.recordArray[indexPath.row - adCount].studyTime,
                                     comment:  self.recordArray[indexPath.row - adCount].comment,
                                     date:     self.recordArray[indexPath.row - adCount].date,
                                     postid:   self.recordArray[indexPath.row - adCount].postid,
                                     image:    self.recordArray[indexPath.row - adCount].image)
                
              
                return cell
            }
            else if indexPath.row / 11 == 7{
                adCount = 7
                let cell = tableView.dequeueReusableCell(withIdentifier: "UserRecordCell", for: indexPath) as! UserRecordCell
                cell.memoLabel.text = nil
                cell.textLabel?.text = nil
                cell.profileImage.image = nil
                cell.dateLabel.text = nil
                    cell.setHomeCell(userid:   self.recordArray[indexPath.row - adCount].userid,
                                     username: self.recordArray[indexPath.row - adCount].username,
                                     studyTime:self.recordArray[indexPath.row - adCount].studyTime,
                                     comment:  self.recordArray[indexPath.row - adCount].comment,
                                     date:     self.recordArray[indexPath.row - adCount].date,
                                     postid:   self.recordArray[indexPath.row - adCount].postid,
                                     image:    self.recordArray[indexPath.row - adCount].image)
                
              
                return cell
            }
            else if indexPath.row / 11 == 8{
                adCount = 8
                let cell = tableView.dequeueReusableCell(withIdentifier: "UserRecordCell", for: indexPath) as! UserRecordCell
                cell.memoLabel.text = nil
                cell.textLabel?.text = nil
                cell.profileImage.image = nil
                cell.dateLabel.text = nil
                    cell.setHomeCell(userid:   self.recordArray[indexPath.row - adCount].userid,
                                     username: self.recordArray[indexPath.row - adCount].username,
                                     studyTime:self.recordArray[indexPath.row - adCount].studyTime,
                                     comment:  self.recordArray[indexPath.row - adCount].comment,
                                     date:     self.recordArray[indexPath.row - adCount].date,
                                     postid:   self.recordArray[indexPath.row - adCount].postid,
                                     image:    self.recordArray[indexPath.row - adCount].image)
                
              
                return cell
            }
            else if indexPath.row / 11 == 9{
                adCount = 9
                let cell = tableView.dequeueReusableCell(withIdentifier: "UserRecordCell", for: indexPath) as! UserRecordCell
                cell.memoLabel.text = nil
                cell.textLabel?.text = nil
                cell.profileImage.image = nil
                cell.dateLabel.text = nil
                    cell.setHomeCell(userid:   self.recordArray[indexPath.row - adCount].userid,
                                     username: self.recordArray[indexPath.row - adCount].username,
                                     studyTime:self.recordArray[indexPath.row - adCount].studyTime,
                                     comment:  self.recordArray[indexPath.row - adCount].comment,
                                     date:     self.recordArray[indexPath.row - adCount].date,
                                     postid:   self.recordArray[indexPath.row - adCount].postid,
                                     image:    self.recordArray[indexPath.row - adCount].image)
                
              
                return cell
            }
            else if indexPath.row / 11 == 10{
                adCount = 10
                let cell = tableView.dequeueReusableCell(withIdentifier: "UserRecordCell", for: indexPath) as! UserRecordCell
                cell.memoLabel.text = nil
                cell.textLabel?.text = nil
                cell.profileImage.image = nil
                cell.dateLabel.text = nil
                    cell.setHomeCell(userid:   self.recordArray[indexPath.row - adCount].userid,
                                     username: self.recordArray[indexPath.row - adCount].username,
                                     studyTime:self.recordArray[indexPath.row - adCount].studyTime,
                                     comment:  self.recordArray[indexPath.row - adCount].comment,
                                     date:     self.recordArray[indexPath.row - adCount].date,
                                     postid:   self.recordArray[indexPath.row - adCount].postid,
                                     image:    self.recordArray[indexPath.row - adCount].image)
                
              
                return cell
            }
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "UserRecordCell", for: indexPath) as! UserRecordCell
                return cell
            }
        }
        
        
    }
    
  
    func settingTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        
        let RecordCell = UINib(nibName: "UserRecordCell", bundle: nil )
        tableView.register(RecordCell, forCellReuseIdentifier: "UserRecordCell")
        
        let AdTableViewCell = UINib(nibName: "AdTableViewCell", bundle: nil )
        tableView.register(AdTableViewCell, forCellReuseIdentifier: "AdTableViewCell")
        
    }
    func tableView(_ tableView: UITableView,heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "detail") as! DetailViewController
        tableView.deselectRow(at: indexPath, animated: true)
      
       
        if     indexPath.row == 11 || indexPath.row == 22
            || indexPath.row == 33 || indexPath.row == 44
            || indexPath.row == 55 || indexPath.row == 66
            || indexPath.row == 77 || indexPath.row == 88
            || indexPath.row == 99 || indexPath.row == 110{
            
            print("広告です")
        }
        else{
            if indexPath.row / 11  == 0 {
                print(indexPath.row,"が選択されましたA")
                next.record = recordArray[indexPath.row - 0]
                self.navigationController?.pushViewController(next, animated: true)
            }
            else if indexPath.row / 11  == 1 {
                print(indexPath.row,"が選択されましたB")
                next.record = recordArray[indexPath.row - 1]
                self.navigationController?.pushViewController(next, animated: true)
            }
            else if indexPath.row / 11  == 2 {
                print(indexPath.row,"が選択されましたC")
                next.record = recordArray[indexPath.row - 2]
                self.navigationController?.pushViewController(next, animated: true)
            }
            else if indexPath.row / 11  == 3 {
                next.record = recordArray[indexPath.row - 3]
                self.navigationController?.pushViewController(next, animated: true)
            }
            else if indexPath.row / 11  == 4 {
                next.record = recordArray[indexPath.row - 4]
                self.navigationController?.pushViewController(next, animated: true)
            }
            else if indexPath.row / 11  == 5 {
                next.record = recordArray[indexPath.row - 5]
                self.navigationController?.pushViewController(next, animated: true)
            }
            else if indexPath.row / 11  == 6 {
                next.record = recordArray[indexPath.row - 6]
                self.navigationController?.pushViewController(next, animated: true)
            }
            else if indexPath.row / 11  == 7 {
                next.record = recordArray[indexPath.row - 7]
                self.navigationController?.pushViewController(next, animated: true)
            }
            else if indexPath.row / 11  == 8 {
                next.record = recordArray[indexPath.row - 8]
                self.navigationController?.pushViewController(next, animated: true)
            }
            else if indexPath.row / 11  == 9 {
                next.record = recordArray[indexPath.row - 9]
                self.navigationController?.pushViewController(next, animated: true)
            }
            else if indexPath.row / 11  == 10 {
                next.record = recordArray[indexPath.row - 10]
                self.navigationController?.pushViewController(next, animated: true)
            }
        }

        
        
       
       
            
       
        
        
        
    }
    
}





extension HomeViewController{
    
    func getRecord(){
      
        if recordArray.count == 0{
            HUD.flash(.progress, delay: 5)
        }
        print("取得します")
        database.collection("Records").order(by:"date", descending: true).limit(to: 50).getDocuments{[self] (querySnapshot, err) in
            self.recordArray = []
            if err != nil {
                return
            } else {
                for document in querySnapshot!.documents {
                    
                    let data = document.data()
                    
                    if let studyTime = data["studytime"],
                       let comment   = data["comment"],
                       let userID    = data["userid"],
                       let timestamp = data["date"],
                       let username  = data["username"],
                       let postid    = data["postid"],
                       let image     = data["image"],
                       let category  = data["category"]{
                        let date:Date = (timestamp as AnyObject).dateValue()
                        
                        let study = studyTimeClass()
                        let blockuserArray = study.getBlockUser()
                        var isFlag = true
                        for i in 0..<blockuserArray.count{
                            if userID as! String == blockuserArray[i].userid{
                                isFlag = false
                                break
                            }
                        }
                        if isFlag{
                            let newDate = Record(image: image as! String, username: username as! String, postid: postid as! String, userid: userID  as! String, studyTime: studyTime  as! Double, comment: comment as! String, date: date, category: category as! String)
                                
                                recordArray.append(newDate)
                        }
                       
                    }
                    else{
                        print("新着エラー")
                    }
                    
                    
                }
                self.isFinish = true
            }
        }
    }
    func getRecordFilteringCategory(){
        let database = Firestore.firestore()
        let category = String(itemInfo.title!)
        print("-------------")
        print("カテゴリー")
        print(category)
        print("-------------")
        self.recordArray = []
        database.collection("Records").whereField("category", isEqualTo: category).limit(to: 40).getDocuments{[self] (querySnapshot, err) in
            self.recordArray = []
            if let err = err {
                print(err)
                return
            } else {
                for document in querySnapshot!.documents {
                    
                    let data = document.data()
                    if let studyTime = data["studytime"],
                       let comment   = data["comment"],
                       let userID    = data["userid"],
                       let timestamp = data["date"],
                       let username  = data["username"],
                       let postid    = data["postid"],
                       let image     = data["image"],
                       let category  = data["category"]{
                        let date:Date = (timestamp as AnyObject).dateValue()
                        
                        let study = studyTimeClass()
                        let blockuserArray = study.getBlockUser()
                        var isFlag = true
                        for i in 0..<blockuserArray.count{
                            if userID as! String == blockuserArray[i].userid{
                                isFlag = false
                                break
                            }
                        }
                        if isFlag{
                            let newDate = Record(image: image as! String, username: username as! String, postid: postid as! String, userid: userID  as! String, studyTime: studyTime  as! Double, comment: comment as! String, date: date, category: category as! String)
                                
                                recordArray.append(newDate)
                        }
                       
                        
                    }
                    else{
                        print("カテゴリーエラー")
                    }
                    
                    
                }
                self.isFinish = true
            }
        }
    }
}

