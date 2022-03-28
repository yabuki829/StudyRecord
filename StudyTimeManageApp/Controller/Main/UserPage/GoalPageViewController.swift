//
//  GoalPageViewController.swift
//  StudyTimeManageApp
// イラスト Linustock 
//  Created by Yabuki Shodai on 2021/12/14.
//
//TODO 名前変更する　GoalPageViewController
import UIKit

class GoalPageViewController: UIViewController {


    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    var changeProfileCell:ChangeProfileCell!
    var isSelecting = false
    
    var selectImage = String()
    var username = String()
    var goal = String()
    
    let profileModel = studyTimeClass()
    public var imageArray = [
        "centertestgirl","centertestmen","girlkimono","menkimono","studyLady","studyLedy2","StudyMen","studyMen2","お願い女性1","お願い男1","読書男1","読書男2","読書女1","読書男2","男性","女性","男性2","女性2","分かれ道","お笑い","女子拳","かえる","女性勇者","男性勇者","龍","幽霊","神様","神様2"
        
    ]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingTableView()
        settingNavigation()
        
    }
    func settingNavigation(){
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    override func viewWillAppear(_ animated: Bool) {if isSelecting != true {
            print("False")
            selectImage = profileModel.getProfileImage()
            username = profileModel.getUserName()
            goal = profileModel.getGoal()
        }
        else{
            print("True")
            print(selectImage)
            print("リロードします")
            tableView.reloadData()
        }
    }
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        selectImage = changeProfileCell.imageString
        username = changeProfileCell.textField.text!
        goal = changeProfileCell.textView.text
        
        profileModel.saveProfile(username: username ?? "No Name", goal: goal, image:selectImage )
        self.dismiss(animated: true, completion: nil)
        
    }

    
}




extension GoalPageViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell  = tableView.dequeueReusableCell(withIdentifier: "ChangeProfileCell", for: indexPath) as! ChangeProfileCell
        cell.selectionStyle = .none
        cell.delegate = self
        cell.setCell(image: selectImage, username:username , goal: goal)
        changeProfileCell = cell
        return cell
         
    }
    func settingTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        let ChangeProfileCell = UINib(nibName: "ChangeProfileCell", bundle: nil )
        tableView.register(ChangeProfileCell, forCellReuseIdentifier: "ChangeProfileCell")
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.height * 2 / 3
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


extension GoalPageViewController:moveSelectImageViewProtcol{
    func move(name: String, goal: String, image: String) {
        performSegue(withIdentifier: "selectImage", sender: nil)
    }
    
}
