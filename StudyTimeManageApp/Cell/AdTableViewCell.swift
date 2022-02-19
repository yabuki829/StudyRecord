//
//  AdTableViewCell.swift
//  StudyTimeManageApp
//
//  Created by Yabuki Shodai on 2022/01/24.
//

import UIKit
import NendAd
class AdTableViewCell: UITableViewCell, NADViewDelegate {

    @IBOutlet weak var nadView: NADView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addAD()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func addAD(){
        //本番広告
//        nadView.setNendID(1051277, apiKey: "7e404556384d43c010a245f5a311c34ee9c9da44")
        //テスト広告
        nadView.setNendID(70998, apiKey: "25eb32adddc4f7311c3ec7b28eac3b72bbca5656")
        
        nadView.delegate = self
        nadView.load()
    }
    func nadViewDidFinishLoad(_ adView: NADView!) {
        print("ロード完了")
    }
    func nadViewDidReceiveAd(_ adView: NADView!) {
        print("受信をしました")
    }
    func nadViewDidFail(toReceiveAd adView: NADView!) {
        // エラーごとに処理を分岐する場合
        let error: NSError = adView.error as NSError

        switch (error.code) {
        case NADViewErrorCode.NADVIEW_AD_SIZE_TOO_LARGE.rawValue:
            // 広告サイズがディスプレイサイズよりも大きい
            print("広告サイズがディスプレイサイズよりも大きい")
            break
        case NADViewErrorCode.NADVIEW_INVALID_RESPONSE_TYPE.rawValue:
            // 不明な広告ビュータイプ
            print(" 不明な広告ビュータイプ")
            break
        case NADViewErrorCode.NADVIEW_FAILED_AD_REQUEST.rawValue:
            // 広告取得失敗
            print("広告取得失敗")
            break
        case NADViewErrorCode.NADVIEW_FAILED_AD_DOWNLOAD.rawValue:
            // 広告画像の取得失敗
            print(" 広告画像の取得失敗")
            break
        case NADViewErrorCode.NADVIEW_AD_SIZE_DIFFERENCES.rawValue:
            // リクエストしたサイズと取得したサイズが異なる
            print(" リクエストしたサイズと取得したサイズが異なる")
            break
        default:
            print("その他")
            break
        }
    }
}
