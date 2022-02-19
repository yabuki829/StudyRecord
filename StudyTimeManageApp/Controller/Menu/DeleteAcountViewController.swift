//
//  DeleteAcountViewController.swift
//  StudyTimeManageApp
//
//  Created by Yabuki Shodai on 2022/02/03.
//

import UIKit

class DeleteAcountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    

    @IBOutlet weak var tableView: UITableView!
    var item = ["勉強時間を削除","アカウントを削除"]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return item.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = item[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            studyTimeDeleteAlert()
        }
        else if indexPath.row == 1{
            acountDeleteAlert()
        }
    }
    func acountDeleteAlert(){
        //アカウントを削除しますがよろしいですか？
        let alert = UIAlertController(title: "削除", message: "アカウントを削除する", preferredStyle: .alert)
        let selectAction = UIAlertAction(title: "削除", style: .default, handler: { _ in
            self.moreAlert(type: "A")
        })
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)

        alert.addAction(selectAction)
        alert.addAction(cancelAction)

        present(alert, animated: true)
    }
    func studyTimeDeleteAlert(){
        //今までの勉強時間の削除をしますがよろしいですか？
            let alert = UIAlertController(title: "削除", message: "今までの勉強時間を削除する", preferredStyle: .alert)
            let selectAction = UIAlertAction(title: "削除", style: .default, handler: { _ in
                self.moreAlert(type: "B")
               
            })
            let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)

            alert.addAction(selectAction)
            alert.addAction(cancelAction)

            present(alert, animated: true)
    }
    func moreAlert(type:String){
        let alert = UIAlertController(title: "削除", message: "本当によろしいですか？", preferredStyle: .alert)
        let selectAction = UIAlertAction(title: "削除", style: .default, handler: { _ in
            if type == "A"{
                self.acountDelete()
            }
            else if
                type == "B"{
                self.studyTimeDelete()
            }
           
        })
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)

        alert.addAction(selectAction)
        alert.addAction(cancelAction)

        present(alert, animated: true)
    }
    func acountDelete(){
        let database = Database()
        database.deleteAcount()
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let secondViewController = storyboard.instantiateViewController(withIdentifier: "login") as! SplashViewController
        secondViewController.modalPresentationStyle = .fullScreen
        self.present(secondViewController, animated: true, completion: nil)
        
    }
    func studyTimeDelete(){
        let studyTime = studyTimeClass()
        //勉強時間/ day, month, total , week を削除
        studyTime.deleteWeekData()
        studyTime.deleteDayData()
        studyTime.deleteMonthData()
        studyTime.deleteTotalData()
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let secondViewController = storyboard.instantiateViewController(withIdentifier: "home") as! TabbarController
        self.present(secondViewController, animated: true, completion: nil)
        
    }
    

}
