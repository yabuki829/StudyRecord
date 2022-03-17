//
//  MenuViewController.swift
//  StudyTimeManageApp
//
//  Created by Yabuki Shodai on 2021/12/14.
//

import UIKit

class MenuViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var items = ["Menu","勉強データの削除","ログアウト","利用規約","プライバシーポリシー","使用しているイラスト","お問い合わせ"]
    
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
            performSegue(withIdentifier: "acount", sender: nil)
        }
        else if indexPath.row == 2{
            //ログアウト
           logoutAlert()
        }
        else if indexPath.row == 3{
            //利用規約の表示
            
            let url = URL(string: "https://studyrecordjp.herokuapp.com/next.html")
            UIApplication.shared.open(url!)
        }
        else if indexPath.row == 4{
            //プライバシーポリシー
            
            let url = URL(string: "https://studyrecordjp.herokuapp.com/index.html")
            UIApplication.shared.open(url!)
        }
        else if indexPath.row == 5{
            let url = URL(string: "https://www.linustock.com/")
            UIApplication.shared.open(url!)
        }
        else if indexPath.row == 6{
            let url = URL(string: "https://twitter.com/apptodojp")
            UIApplication.shared.open(url!)
        }

        
    }
    func logoutAlert(){
        let alert = UIAlertController(title: "ログアウトしますか？" , message:"" ,preferredStyle: .alert)
           
        let selectAction = UIAlertAction(title: "ログアウト", style: .default, handler: { _ in
            let vc = AuthManager.shered.logout()
            self.present(vc, animated: true, completion: nil)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alert.addAction(selectAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
}
