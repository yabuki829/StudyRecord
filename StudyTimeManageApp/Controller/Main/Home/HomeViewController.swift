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
        print(recordArray.count + (recordArray.count / 10))
        return recordArray.count + (recordArray.count / 10) - 1
                
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(indexPath.row)
        
        if indexPath.row % 11 == 0 && indexPath.row != 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AdTableViewCell", for: indexPath) as! AdTableViewCell
            
            return cell
        }
        else{
            
            let adCount = Int(indexPath.row / 11)
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
        if indexPath.row % 11 == 0 && indexPath.row != 0{
            return 120
        }
        else{
            return UITableView.automaticDimension
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        tableView.deselectRow(at: indexPath, animated: true)
      
       
        if indexPath.row % 11 == 0 && indexPath.row != 0{
          
            print("広告です")
            print(indexPath.row)
        }
        else{
            let next = self.storyboard?.instantiateViewController(withIdentifier: "detail") as! DetailViewController
            let adCount = Int(indexPath.row / 11)
            print(indexPath.row,"が選択されましたA")
            next.record = recordArray[indexPath.row - adCount]
            self.navigationController?.pushViewController(next, animated: true)
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
        database.collection("Records").whereField("category", isEqualTo: category).limit(to: 25).getDocuments{[self] (querySnapshot, err) in
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



//ca-app-pub-9515239279115600~5575856198

//ca-app-pub-9515239279115600/2695553740
