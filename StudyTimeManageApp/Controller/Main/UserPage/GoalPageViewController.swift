//
//  GoalPageViewController.swift
//  StudyTimeManageApp
// イラスト Linustock 
//  Created by Yabuki Shodai on 2021/12/14.
//

import UIKit

class GoalPageViewController: UIViewController,UITextViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var textView: PlaceTextView!
    @IBOutlet weak var profileImage: UIImageView!
    var selectImage = String()
    let profileModel = studyTimeClass()
    public var imageArray = [
           
           
        "centertestgirl","centertestmen","girlkimono","menkimono","studyLady","studyLedy2","studyMen","studyMen2","お願い女性1","お願い男1","読書男1","読書男2","読書女1","読書男2","男性","女性","男性2","女性2","分かれ道","お笑い","女子拳","かえる","女性勇者","男性勇者","龍","幽霊","神様","神様2"
        
    ]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.text = profileModel.getUserName()
        let goal = profileModel.getGoal()
        if goal.isEmpty {
            textView.placeHolder = "Goal.. Less than 120 characters "
        }
        else{
            textView.text = goal
        }
        textView.text = profileModel.getGoal()
        selectImage = profileModel.getProfileImage()
        profileImage.image = UIImage(named: selectImage)
        setting()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        
        if textField.text?.isEmpty == true  {
            textField.text = "No Name"
            return
        }
        else{
            
            if textField.text!.count > 20 || textView.text.count > 120{
                return
            }
            let goalModel = studyTimeClass()
            
            goalModel.saveProfile(username: textField.text ?? "No Name", goal: textView.text, image:selectImage )
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    func setting(){
        
        textView.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.layer.borderWidth = 1
        collectionView.layer.borderColor = UIColor.darkGray.cgColor
        profileImage.layer.borderWidth = 1
        profileImage.layer.borderColor = UIColor.darkGray.cgColor
        profileImage.layer.cornerRadius = 50
        profileImage.clipsToBounds = true
    }
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty {
            self.textView.placeHolder = "Goal.. Less than 120 characters "
        }
    }
    
}


extension GoalPageViewController:UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let image = cell.viewWithTag(1) as! UIImageView
        image.image = UIImage(named: imageArray[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectImage = imageArray[indexPath.row]
        profileImage.image = UIImage(named: selectImage)
        profileImage.contentMode = .scaleAspectFill
    }
    
    
}
