//
//  ViewController.swift
//  StudyTimeManageApp
//
//  Created by Yabuki Shodai on 2022/04/12.
//

import UIKit
import FirebaseFirestore

class BarChartViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var weekDataArray = [studyWeekData]()
    var isFinish:Bool = false {
        didSet{
            tableView.reloadData()
            isFinish = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getData()
        setNavBarBackgroundColor()
        // Do any additional setup after loading the view.
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
    func getData(){
        print("取得します")
        let database = Firestore.firestore()
        let userid   = UserDefaults.standard.object(forKey: "userid")
        weekDataArray = []
        database.collection("Users").document(userid as! String).collection("StudyTime").order(by: "start", descending: true).getDocuments{
            (querySnapshot, err) in
            if err != nil {
                return
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    if let weekData = data["week"],
                       let lastTimestamp   = data["last"],
                       let startTimestamp     = data["start"]{
                        let lastDate:Date = (lastTimestamp as AnyObject).dateValue()
                        let startDate:Date = (startTimestamp as AnyObject).dateValue()
                        let newData = studyWeekData(week: weekData as! [Double], last: lastDate, start: startDate)
                        self.weekDataArray.append(newData)
                    }
                }
            }
            self.isFinish = true
        }
       
    }
}



extension BarChartViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(weekDataArray.count)
        return weekDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = convertDateToString(date: weekDataArray[indexPath.row].start) + "〜" + convertDateToString(date: weekDataArray[indexPath.row].last)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "barDetail") as! BarChartDetailViewController
        next.path = indexPath.row
        next.weekDataArray = weekDataArray
        self.navigationController?.pushViewController(next, animated: true)
    }
    func convertDateToString(date:Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
            
        dateFormatter.timeStyle = .none
        
        // カレンダー設定（グレゴリオ暦固定）
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        // 変換
        let str = dateFormatter.string(from: date)
        // 結果表示
        return str
    }
}
