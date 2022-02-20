//
//  ShowLicenseViewController.swift
//  StudyTimeManageApp
//
//  Created by Yabuki Shodai on 2022/02/20.
//

import UIKit

class ShowLicenseViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    var i = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = licenseArray[i].name
        textView.text = licenseArray[i].body
    }

}
