//
//  FriendStudyTimeViewController.swift
//  StudyTimeManageApp
//
//  Created by Yabuki Shodai on 2021/12/12.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class FriendSearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    let language = LanguageClass()
    var local = String()
    var profileArray = [Profile]()
    var  friendID = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusBarBackgroundColor(.systemRed)
        settingTableView()
        local = language.getlocation()
        if local == "ja"{
            textField.placeholder = "知り合いにfriendIDを教えてもらいましょう"
        }
        else{
            textField.placeholder = "Ask an acquaintance to tell you your friend ID."
        }
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
            if let a:[Profile] = UserDefaults.standard.codable(forKey: "friend"){
                profileArray = a 
                tableView.reloadData()
            }
        
    }
   
    @IBAction func getFriendID(_ sender: Any) {
        //アラートで自分のfriendIDを表示する
        alert()
    }
    @IBAction func search(_ sender: Any) {
        if textField.text?.isEmpty == false{
            searchFriend(id: textField.text!)
        }
        else{
        // 無効な値です invald Value 綴りあってるかわからん
        }
    }
    func settingTableView(){
        tableView.delegate = self
        tableView.dataSource = self
      
        tableView.rowHeight = UITableView.automaticDimension
        
        let UserProfileViewCell = UINib(nibName: "UserProfileViewCell", bundle: nil)
        tableView.register(UserProfileViewCell, forCellReuseIdentifier: "UserProfileViewCell")
        
    }
    func alert(){
        let id = UserDefaults.standard.object(forKey: "userid")
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
    
        present(alert, animated: true)
    }

    func searchFriend(id:String){
        let database = Firestore.firestore()
        database.collection("Users").document(id).getDocument{ (querySnapshot, err) in
            self.profileArray = []
            if let err = err {
                print(err)
                return
            } else {
                let data = querySnapshot!.data()
                if let username = data?["username"],
                   let goal = data!["goal"],
                   let image = data!["image"],
                   let userid = data!["userid"]{
                    let newData = Profile(username: username as! String, goal: goal as! String, image: image as! String, userid:userid as! String )
                    self.profileArray.append(newData)
                    self.friendID = id
                    if self.friendID.isEmpty {
                        print("相手のprofileが登録されていません")
                    }
                }
                self.tableView.reloadData()
            }
        }
    
    }
}


extension FriendSearchViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserProfileViewCell", for: indexPath) as! UserProfileViewCell
       
        cell.setSell(image: profileArray[indexPath.row].image, username: profileArray[indexPath.row].username , goal:  profileArray[indexPath.row].goal)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //遷移する
        let next = self.storyboard?.instantiateViewController(withIdentifier: "friendStudy") as! FriendStudyTimeViewController
        next.friendData = profileArray[indexPath.row]
        self.navigationController?.pushViewController(next, animated: true)
    }

}
