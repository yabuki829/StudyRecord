//
//  UserProfileViewCell.swift
//  StudyTimeManageApp
//
//  Created by Yabuki Shodai on 2021/12/22.
//

import UIKit

class UserProfileViewCell: UITableViewCell {

    
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var goalLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setSell(image:String,username:String,goal:String){
        profileImage.image = UIImage(named: image)
        usernameLabel.text = username
        goalLabel.text = goal
        
        profileImage.layer.cornerRadius = 35
        profileImage.clipsToBounds = true
        profileImage.layer.borderColor = UIColor.darkGray.cgColor
        profileImage.layer.borderWidth = 1
    }
    
}
