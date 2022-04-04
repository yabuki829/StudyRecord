//
//  RecordViewController.swift
//  StudyTimeManageApp
//
//  Created by Yabuki Shodai on 2021/12/13.
//

import UIKit
import GoogleMobileAds
class RecordViewController: UIViewController {
    
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var tableView: UITableView!
    
    var textField = UITextField()
    var categoryTextField: UITextField!
    
    let StudyTime = studyTimeClass()
    let alert = Alert()
    var recordViewCell:RecordViewCell!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAd()
        setStatusBarBackgroundColor(.link)
        tableView.delegate = self
        tableView.dataSource = self

        settingTableView()
    }
    @IBAction func backHome(_ sender: Any) {
        //前の画面に戻る
        navigationController?.popViewController(animated: true)

    }

    @IBAction func record(_ sender: Any) {
        let studyTime = recordViewCell.studyTime
        let category = recordViewCell.category
        let text     = recordViewCell.textView.text
        
        if studyTime == 0.0 {
            //alertを出す勉強時間を選択してください
            present(alert.enterStudyTime(), animated: true)
            return
        }
        else{
            if category == "選択してください" || category == "" {
                present(alert.enterCategory(), animated: true)
               return
            }
            else{
                StudyTime.save(studyTime: studyTime,comment: text ?? "", category: category)
                navigationController?.popViewController(animated: true)
            }
           
        }
       
        
    }
    func setAd(){
        let unitID = "ca-app-pub-9515239279115600/9215702391"
//        let testAd = "ca-app-pub-3940256099942544/2934735716"
        bannerView.adUnitID = unitID
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
     
    
}











extension RecordViewController:UITableViewDelegate,UITableViewDataSource{
    func settingTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
      let RecordViewCell = UINib(nibName: "RecordViewCell", bundle: nil )
     
      tableView.register(RecordViewCell, forCellReuseIdentifier: "RecordViewCell")
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordViewCell", for: indexPath) as! RecordViewCell
        cell.selectionStyle = .none
        cell.setting(toolbarWidth:view.frame.size.width, toolbarHeight:view.frame.size.height)
        
        recordViewCell = cell
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.height * 2 / 3
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

