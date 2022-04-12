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
    let database = Firestore.firestore()
    
    //TODO- recordArrayをカテゴリーの数だけ作成する
    var recordArray:[Record] = []
    var newArray:[Record] = []
    var skilArray:[Record] = []
    var hobbyArray:[Record] = []
    var bookArray:[Record] = []
    var examArray:[Record] = []
    var qualArray:[Record] = []
    
    var adCount:Int = 0
    var isFinish:Bool = false {
        didSet{
            PKHUD.sharedHUD.hide()
            tableView.reloadData()
            isFinish = false
        }
    }
    var isAD = true
    
    
  
    var isGood = Bool()
    var goodCountArray = [Int]()
    var goodArray = [Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingTableView()
        setNavBarBackgroundColor()
        if itemInfo.title == "新 着"{
            print("新着")
            getRecord()
        }
        else{
            getRecordFilteringCategory()
        }
        
      
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
       setNavBarBackgroundColor()
        if itemInfo.title == "スキルアップ"{
            recordArray = skilArray
           
        }
        else if itemInfo.title == "受験勉強"{
            recordArray = examArray
        }
        else if itemInfo.title == "資格取得"{
            recordArray = qualArray
        }
        else if itemInfo.title == "趣味"{
            recordArray = hobbyArray
        } else if itemInfo.title == "読書"{
            recordArray = bookArray
        }
        else{
            print("新着")
            recordArray = newArray
        }
        
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
        if isAD{
            return recordArray.count + (recordArray.count / 11)
        }
        else{
            return recordArray.count
        }
        
                
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(indexPath.row,"番目")
        
        if isAD {
            if indexPath.row % 10 == 0 && indexPath.row != 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "AdTableViewCell", for: indexPath) as! AdTableViewCell
                return cell
            }
            else{
                adCount = Int(indexPath.row / 10)
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
        else{
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
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
    }
    @objc func refresh() {
        

        if itemInfo.title == "新 着"{
            print("新着")
            getRecord()
        }
        else{
            getRecordFilteringCategory()
        }
        tableView.refreshControl?.endRefreshing()    //これを呼び出すとくるくるが止まる
    }
    func tableView(_ tableView: UITableView,heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row % 10 == 0 && indexPath.row != 0{
            return 120
        }
        else{
            return UITableView.automaticDimension
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        tableView.deselectRow(at: indexPath, animated: true)
       
       
        if indexPath.row % 10 == 0 && indexPath.row != 0{
          
            print("広告です")
            print(indexPath.row)
        }
        else{
            print(indexPath.row)
            let next = self.storyboard?.instantiateViewController(withIdentifier: "detail") as! DetailViewController
            let adCount = Int(indexPath.row / 10)
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
            recordArray.removeAll()
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
                                
                            newArray.append(newDate)
                        }
                       
                    }
                    else{
                        print("新着エラー")
                    }
                    
                    
                }
                recordArray = newArray
                self.isFinish = true
            }
        }
    }
    func getRecordFilteringCategory(){
        let database = Firestore.firestore()
        let category:String = String(itemInfo.title!)
       
        switch category {
            case "スキルアップ":
                skilArray.removeAll()
            case "受験勉強":
                examArray.removeAll()
            case "資格取得":
                qualArray.removeAll()
            case "趣味":
                hobbyArray.removeAll()
            case "読書":
                bookArray.removeAll()
            default:
                break
        }
        
        database.collection("Records").whereField("category", isEqualTo: category).order(by:"date", descending: true).limit(to: 50).getDocuments{[self] (querySnapshot, err) in
            
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
                            
                            
                            switch category as! String {
                                case "スキルアップ":
                                    skilArray.append(newDate)
                                case "受験勉強":
                                    examArray.append(newDate)
                                case "資格取得":
                                    qualArray.append(newDate)
                                case "趣味":
                                    hobbyArray.append(newDate)
                                case "読書":
                                    bookArray.append(newDate)
                                default:
                                    break
                            }
                            
                        }
                       
                        
                    }
                    else{
                        print("カテゴリーエラー")
                    }
                    
                }
               
                switch category {
                    case "スキルアップ":
                        recordArray = skilArray
                    case "受験勉強":
                        recordArray = examArray
                    case "資格取得":
                        recordArray = qualArray
                    case "趣味":
                        recordArray = hobbyArray
                    case "読書":
                        recordArray = bookArray
                    default:
                        break
                }
                self.isFinish = true
            }
        }
    }
}

