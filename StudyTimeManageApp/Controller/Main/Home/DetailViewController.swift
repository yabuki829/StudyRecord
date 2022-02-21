//
//  DetailViewController.swift
//  StudyTimeManageApp
//
//  Created by Yabuki Shodai on 2021/12/16.
//

import UIKit
import FirebaseFirestore

class DetailViewController: UIViewController {

    

    @IBOutlet weak var deleteOrReportbutton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    var record = Record(image: String(), username: String(), postid: String(), userid: String(), studyTime: Double(), comment: String(), date: Date(), category: String())
    let database = Database()
    let studyTime = studyTimeClass()
    var commentArray = [Comment]()
    var userName = String()
    var profileImage = String()
    var isGood = Bool()
    var goodCount = Int()
    var isReportButton = false
    var userNameArray = [String]()
    var profileImageArray = [String]()
    var userid = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        settingTableView()
        
        userid = UserDefaults.standard.object(forKey: "userid") as! String
        
        if record.userid != userid{
            isReportButton = true
        }
       
        getCommnet()
        getGood(postid: record.postid)
        getGoodCount(postid: record.postid)
      
    }
    override func viewWillAppear(_ animated: Bool) {
        setNavBarBackgroundColor()
    }
    func setNavBarBackgroundColor(){
        setStatusBarBackgroundColor(.systemGreen)
        self.navigationController?.navigationBar.barTintColor = .green
        self.navigationController?.navigationBar.tintColor = .link
        // ナビゲーションバーのテキストを変更する
        self.navigationController?.navigationBar.titleTextAttributes = [
        // 文字の色
            .foregroundColor: UIColor.black
        ]
    }


    @IBAction func deletePost(_ sender: Any) {
       
        if isReportButton == true{
           selectAlertofPost()
        }
        else{
            
            postDeleteAlert()
        }
        
    }
    
}


extension DetailViewController:UITableViewDelegate,UITableViewDataSource,tableViewUpDater{
    func move() {}
    
    func tapLike(isLike: Bool, index: Int, count: Int){}
    
    func sendtoProfile(userid: String, username: String) {
         let next = self.storyboard?.instantiateViewController(withIdentifier: "userpage") as! UserPageViewController
         next.userid = userid
         next.userName = username
         self.navigationController?.pushViewController(next, animated: true)
    }
    
    func updateTableView() {
        tableView.reloadData()
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentArray.count + 2
   
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailViewCell", for: indexPath) as! DetailViewCell
            cell.setDetailCell(userid: record.userid,
                               username: record.username,
                               studyTime: record.studyTime,
                               comment: record.comment,
                               date: record.date,
                               postid: record.postid,
                               isgood: isGood,
                               count: goodCount,
                               image: record.image,
                               commentCount: commentArray.count,
                               category: record.category)
            cell.delegate = self
            return cell
        }
        else if indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextfieldViewCell", for: indexPath) as! TextfieldViewCell
            cell.setData(postid: record.postid)
            return cell
        }
        else{
          
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommnentCell", for: indexPath) as! CommnentCell
           
                cell.setCell(username:  self.commentArray[indexPath.row - 2].username,
                             comment:  self.commentArray[indexPath.row - 2].comment,
                             date:     self.commentArray[indexPath.row - 2].date,
                             image: self.commentArray[indexPath.row - 2].image)
                       
              
            return cell
        }
      
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
        if indexPath.row == 0{
            return UITableView.automaticDimension
        }
        else if indexPath.row == 1{
            return 40
        }
        else{
            tableView.estimatedRowHeight = 80
            return UITableView.automaticDimension
            
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
       
        
        if indexPath.row > 1{
            if userid == commentArray[indexPath.row - 2].userid{
                deleteCommentAlert(postID: commentArray[indexPath.row - 2].postid, commentID: commentArray[indexPath.row - 2].commentid)
        
            }else{
                selectAlertofComment(commment: commentArray[indexPath.row - 2].comment, postID: commentArray[indexPath.row - 2].postid, commentID: commentArray[indexPath.row - 2].commentid, reportedid: commentArray[indexPath.row - 2].userid, username: commentArray[indexPath.row - 2].username)
            }
        }
       
        
        
       
    }

    func postDeleteAlert(){
        let alert = UIAlertController(title: "投稿を削除しますか?", message: "", preferredStyle: .alert)
        let selectAction = UIAlertAction(title: "Delete", style: .default, handler: { [self] _  in
            studyTime.deleteStudyTime(deleteTime: record.studyTime)
            database.deletePost(userid: userid, postid: record.postid)
            navigationController?.popViewController(animated: true)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(selectAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    func deleteCommentAlert(postID:String,commentID:String){
        
        let alert = UIAlertController(title: "削除しますか?", message: "", preferredStyle: .actionSheet)
        let selectAction = UIAlertAction(title: "Delete", style: .default, handler: { _ in
            
            self.database.deleteComment(postID: postID,commentID: commentID)
            
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(selectAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    func selectAlertofComment(commment:String,postID:String,commentID:String,reportedid:String,username:String){
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        let blockAction = UIAlertAction(title: "\(username) さんをブロックする", style: .default, handler: { _ in
            self.blockAlert(userid: reportedid, username: username)
        })
        let reportAction = UIAlertAction(title: "\(username) さんを通報する", style: .default, handler: { _ in
            self.alertCommentReport(commment: commment, postID: postID, commentID: commentID, reportedid: reportedid)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(blockAction)
        alert.addAction(reportAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    func selectAlertofPost(){
        let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        let blockAction = UIAlertAction(title: "\(record.username) さんをブロックする", style: .default, handler: { [self] _ in
            blockAlert(userid: record.userid, username: record.username)
        })
        let reportAction = UIAlertAction(title: "\(record.username) さんを通報する", style: .default, handler: { [self] _ in
            userReportAlert()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(blockAction)
        alert.addAction(reportAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    //ブロック
    func blockAlert(userid:String,username:String){
        let alert = UIAlertController(title: "\(username)さんをブロック", message: "\(username)さんはあなたにメッセージを送信することができなくなります。", preferredStyle: .alert)

        let OKAction = UIAlertAction(title: "ブロック", style: .default, handler: { _ in
            var blockuser = self.studyTime.getBlockUser()
            print(blockuser)
            
            blockuser.append(blockUser(username: username, userid: userid))
            UserDefaults.standard.setCodable(blockuser, forKey: "blockuser")
            if self.record.userid == userid{
                self.navigationController?.popViewController(animated: true)
            }
            else{
                self.getCommnet()
            }
          
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(OKAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
       
    }
    
    func userReportAlert(){
        let myAlert: UIAlertController = UIAlertController(title: "Report", message: "通報内容を選択してください", preferredStyle: .alert)
        
     
        let alertA = UIAlertAction(title: "嫌がらせ/差別/誹謗中傷", style: .default) { [self] action in
            let report = "嫌がらせ・差別・誹謗中傷"
            database.reportUser(report: report, reportedID: record.userid, postID: record.postid, memo: record.comment, username: record.username)
            OKAlert(title: "Thanks for Reports.", message: "報告が完了しました")
        
          
            
        }

        let alertC = UIAlertAction(title: "内容が事実と著しく異なる", style: .default) { [self] action in
            let report = "内容が著しく事実と異なる"
            database.reportUser(report: report, reportedID: record.userid, postID: record.postid, memo: record.comment, username: record.username)
            OKAlert(title: "Thanks for Reports.", message: "報告が完了しました")
            print(report)
        }
        let alertD = UIAlertAction(title: "性的表現/わいせつな表現", style: .default) { [self] action in
           
            let report = "性的表現"
            database.reportUser(report: report, reportedID: record.userid, postID: record.postid, memo: record.comment, username: record.username)
            OKAlert(title: "Thanks for Reports.", message: "報告が完了しました")
        }
        let alertE = UIAlertAction(title: "その他不適切", style: .default) { [self] action in
            
            let report = "不適切な投稿"
            database.reportUser(report: report, reportedID: record.userid, postID: record.postid, memo: record.comment, username: record.username)
            OKAlert(title: "Thanks for Reports.", message: "報告が完了しました")
        }
        let cancelAlert = UIAlertAction(title: "キャンセル", style: .cancel) { action in
            print("キャンセル")
        }

        // OKのActionを追加する.
        myAlert.addAction(alertA)
        myAlert.addAction(alertC)
        myAlert.addAction(alertD)
        myAlert.addAction(alertE)
        myAlert.addAction(cancelAlert)
        

        // UIAlertを発動する.
        present(myAlert, animated: true, completion: nil)
    }
    func alertCommentReport(commment:String,postID:String,commentID:String,reportedid:String){
            
            let myAlert: UIAlertController = UIAlertController(title: "Report", message: "通報内容を選択してください", preferredStyle: .alert)
            
         
            let alertA = UIAlertAction(title: "嫌がらせ/差別/誹謗中傷", style: .default) { [self] action in
                let report = "嫌がらせ・差別・誹謗中傷"
                database.report(report: report, reportedID: reportedid, postID:postID, comment: commment)
                OKAlert(title: "Thanks for Reports.", message: "報告が完了しました")
            
              
                
            }

            let alertC = UIAlertAction(title: "内容が事実と著しく異なる", style: .default) { [self] action in
                let report = "内容が著しく事実と異なる"
                database.report(report: report, reportedID: reportedid, postID:postID, comment: commment)
                OKAlert(title: "Thanks for Reports.", message: "報告が完了しました")
                print(report)
            }
            let alertD = UIAlertAction(title: "性的表現/わいせつな表現", style: .default) { [self] action in
               
                let report = "性的表現"
                database.report(report:report, reportedID: reportedid, postID:postID, comment: commment)
                OKAlert(title: "Thanks for Reports.", message: "報告が完了しました")
            }
            let alertE = UIAlertAction(title: "その他不適切", style: .default) { [self] action in
                
                let report = "不適切な投稿"
                database.report(report:report, reportedID: reportedid, postID:postID, comment: commment)
                OKAlert(title: "Thanks for Reports.", message: "報告が完了しました")
            }
            let cancelAlert = UIAlertAction(title: "キャンセル", style: .cancel) { action in
                print("キャンセル")
            }

            // OKのActionを追加する.
            myAlert.addAction(alertA)
            myAlert.addAction(alertC)
            myAlert.addAction(alertD)
            myAlert.addAction(alertE)
            myAlert.addAction(cancelAlert)
            

            // UIAlertを発動する.
            present(myAlert, animated: true, completion: nil)
    }
    func OKAlert(title:String,message:String){
        let myAlert: UIAlertController = UIAlertController(title:title, message: message, preferredStyle: .alert)
        let oklAlert = UIAlertAction(title: "OK", style: .cancel)
        myAlert.addAction(oklAlert)
        present(myAlert, animated: true, completion: nil)
    }
    

    func settingTableView(){
        tableView.delegate = self
        tableView.dataSource = self
       
        let DetailViewCell = UINib(nibName: "DetailViewCell", bundle: nil )
        tableView.register(DetailViewCell, forCellReuseIdentifier: "DetailViewCell")
        
        let CommnentCell = UINib(nibName: "CommnentCell", bundle: nil )
        tableView.register(CommnentCell, forCellReuseIdentifier: "CommnentCell")
        
        let TextfieldViewCell = UINib(nibName: "TextfieldViewCell", bundle: nil)
        tableView.register(TextfieldViewCell, forCellReuseIdentifier: "TextfieldViewCell")
        
    }
    
}











extension DetailViewController{
    func getCommnet(){
        let database = Firestore.firestore()

        database.collection("Comments").document(record.postid).collection("Comment").order(by: "date", descending: false).addSnapshotListener { (snapShot, error) in
            self.commentArray = []
            if let error = error{
                print(error)
                return
            }
            else{
                for document in snapShot!.documents {
                    
                    let data = document.data()
                    
                    if let userid    = data["userid"],
                       let commentid = data["commentid"],
                       let postid    = data["postid"],
                       let comment   = data["comment"],
                       let username  = data["username"],
                       let image     = data["image"],
                       let timestamp = data["date"]{
                        
                        let date:Date = (timestamp as AnyObject).dateValue()
                        let blockuserArray = self.studyTime.getBlockUser()
                        var isFlag = true
                        for i in 0..<blockuserArray.count{
                            if userid as! String == blockuserArray[i].userid{
                                isFlag = false
                                break
                            }
                        }
                        if isFlag{
                            let newData = Comment(username: username as! String, image: image as! String, userid: userid as! String, commentid: commentid as! String, postid: postid as! String, comment: comment as! String, date: date)
                            self.commentArray.append(newData)
                        }
                    }
                    else{
                        print("間違いがあります")
                    }
                
                }
                self.tableView.reloadData()
            }
        }
    }
    func getGood(postid:String){
        let database = Firestore.firestore()
        let userid = UserDefaults.standard.object(forKey: "userid")
        database.collection("Good").document(postid).collection("good").document(userid! as! String).getDocument { (snapShot, error) in
            if let err = error {
                print(err)
                return
            } else {
                let data = snapShot!.data()
                if let good = data?["isGood"]{
                    self.isGood = good as! Bool
                }
                else{
                    self.isGood = false
                }
            }
        }
    }
    func getGoodCount(postid:String){
        let database = Firestore.firestore()
        database.collection("Good").document(postid).collection("good").getDocuments{ (snapShot, error) in
            if let err = error {
                print(err)
                return
            } else {
                let count = snapShot?.count
                self.goodCount = count!
            }
            self.tableView.reloadData()
        }
    }
    
   
}



@IBDesignable class CustomLabel: UILabel {
    
    @IBInspectable var topPadding: CGFloat = 10
    @IBInspectable var bottomPadding: CGFloat = 10
    @IBInspectable var leftPadding: CGFloat = 5
    @IBInspectable var rightPadding: CGFloat = 5
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: UIEdgeInsets.init(top: topPadding, left: leftPadding, bottom: bottomPadding, right: rightPadding)))
    }
    
    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.height += (topPadding + bottomPadding)
        size.width += (leftPadding + rightPadding)
        return size
    }
}
