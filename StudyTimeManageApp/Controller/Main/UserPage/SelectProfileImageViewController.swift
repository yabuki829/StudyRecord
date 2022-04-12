//
//  SelectProfileImageViewController.swift
//  StudyTimeManageApp
//
//  Created by Yabuki Shodai on 2022/03/28.
//

import UIKit

class SelectProfileImageViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var profileImage: UIImageView!
    var delegate : moveSelectImageViewProtcol?
    
    var selectImage = String()
    var tentativeUserName = String()
    var tentativeGoal     = String()
    let profileModel = studyTimeClass()
    public let imageArray = [
        "centertestgirl","centertestmen","girlkimono","menkimono","studyLady","studyLedy2","StudyMen","studyMen2","お願い女性1","お願い男1","読書男1","読書男2","読書女1","読書男2","男性","女性","男性2","女性2","分かれ道","お笑い","女子拳","かえる","女性勇者","男性勇者","龍","神様","神様2"
        
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        settingNavigation()
        profileImage.image = UIImage(named: profileModel.getProfileImage())
        profileImage.layer.borderColor = UIColor.darkGray.cgColor
        profileImage.layer.borderWidth = 1
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func back(_ sender: Any) {
        print("前の画面に戻ります")
        self.navigationController?.popViewController(animated: true)
//        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func desideImage(_ sender: Any) {
        //遷移時に画像を保持して遷移
        let nav = self.navigationController
        // 一つ前のViewControllerを取得する
        let VC = nav?.viewControllers[(nav?.viewControllers.count)!-2] as! GoalPageViewController
        // 値を渡す
        VC.selectImage = selectImage
        VC.isSelecting = true
        
        if let nameandgoal = UserDefaults.standard.array(forKey: "A"){
            VC.username = nameandgoal[0] as! String
            VC.goal = nameandgoal[1] as! String
            UserDefaults.standard.removeObject(forKey: "A")
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    func settingNavigation(){
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
  
    
}


extension SelectProfileImageViewController :UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let image = cell.viewWithTag(1) as! UIImageView
        image.image = UIImage(named: imageArray[indexPath.row])
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: imageArray[indexPath.row])

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectImage = imageArray[indexPath.row]
        profileImage.image = UIImage(named: selectImage)
        profileImage.contentMode = .scaleAspectFill
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let contentSize = view.frame.size.width / 3
        // 正方形で返すためにwidth,heightを同じにする
        return CGSize(width: contentSize, height: contentSize)
    }
    
    func settingCollectionView(){
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.estimatedItemSize = .init(width: 5, height: 5)
    }
    
}

