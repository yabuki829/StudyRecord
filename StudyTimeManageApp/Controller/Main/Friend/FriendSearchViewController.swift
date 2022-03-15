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

    @IBOutlet weak var searchField: UISearchBar!
    let language = LanguageClass()
    let alert = Alert()
    var local = String()
    var profileArray = [Profile]()
    var friendID:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusBarBackgroundColor(.systemRed)
        settingTableView()
        searchField.delegate = self
        searchField.backgroundColor = .red
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
            if let a:[Profile] = UserDefaults.standard.codable(forKey: "friend"){
                profileArray = a 
                tableView.reloadData()
            }
        
    }
   
    @IBAction func getFriendID(_ sender: Any) {
        present(alert.showFriendID(), animated: true)
    }
    func settingTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableView.automaticDimension
        
        let UserProfileViewCell = UINib(nibName: "UserProfileViewCell", bundle: nil)
        tableView.register(UserProfileViewCell, forCellReuseIdentifier: "UserProfileViewCell")
        
    }
    func searchFriendID(id:String){
        let database = Firestore.firestore()
        print(id,"が入ってます")
        database.collection("UserID").document(id).getDocument{ (querySnapshot, err) in
            self.friendID = ""
            if let err = err {
                print("エラーです")
                print(err)
                
                return
            } else {
                let data = querySnapshot!.data()
                if let ID = data!["userID"]{
                    print("FriendIDが見つかりました")
                    self.friendID = ID as! String
                }
               
            }
            self.searchFriend(id:self.friendID)
        }
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

extension FriendSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            view.endEditing(true)
        
        if searchBar.text!.count > 20{
            print("探します")
            print(searchBar.text!)
            print(searchBar.text!.count)
                searchFriendID(id: searchBar.text!)
            }
       }


}
