//
//  ShowLicenseViewController.swift
//  StudyTimeManageApp
//
//  Created by Yabuki Shodai on 2022/02/20.
//

import UIKit

class SelectLicenseViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
   

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return licenseArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = licenseArray[indexPath.row].name
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let next = self.storyboard?.instantiateViewController(withIdentifier: "showLicense") as! ShowLicenseViewController
        next.i = indexPath.row
        self.navigationController?.pushViewController(next, animated: true)
        
        
    }
    
}
