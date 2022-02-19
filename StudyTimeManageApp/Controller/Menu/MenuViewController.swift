//
//  MenuViewController.swift
//  StudyTimeManageApp
//
//  Created by Yabuki Shodai on 2021/12/14.
//

import UIKit

class MenuViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var items = ["Menu","利用規約","プライバシーポリシー","お問い合わせ","勉強データの削除"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .black
        // Do any additional setup after loading the view.
    }
   

}

extension MenuViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .black
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 1{
            //利用規約の表示
            performSegue(withIdentifier: "termsofservice", sender: nil)
        }
        else if indexPath.row == 2{
            //プライバシーポリシー
            performSegue(withIdentifier: "privacypolicy", sender: nil)
        }
        else if indexPath.row == 3{
            let url = URL(string: "https://twitter.com/apptodojp")
            UIApplication.shared.open(url!)
        }
        else if indexPath.row == 4{
            //データの削除
//           studyTimeDeleteAlert()
            performSegue(withIdentifier: "acount", sender: nil)
        }
        
    }
    
}


extension MenuViewController{
   
}
