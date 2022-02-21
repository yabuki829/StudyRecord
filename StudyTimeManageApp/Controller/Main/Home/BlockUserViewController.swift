//
//  BlockUserViewController.swift
//  StudyTimeManageApp
//
//  Created by Yabuki Shodai on 2022/02/21.
//

import UIKit

class BlockUserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var blockArray = [blockUser]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        let studyTime = studyTimeClass()
        blockArray = studyTime.getBlockUser()
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(blockArray.count)
        return blockArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = blockArray[indexPath.row].username
        cell.detailTextLabel?.text = blockArray[indexPath.row].userid
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool{
          return true
      }

      func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
          if editingStyle == UITableViewCell.EditingStyle.delete {
            blockArray.remove(at: indexPath.row)
            UserDefaults.standard.setCodable(blockArray, forKey: "blockuser")
              tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
          }
    
      }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "解除する"
    }
}
