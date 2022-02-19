//
//  Language.swift
//  StudyTimeManageApp
//
//  Created by Yabuki Shodai on 2022/01/05.
//

import Foundation

class LanguageClass{
    
    func getlocation() -> String{
        let locale = Locale.current
        let localeId = locale.identifier
        let locationString = localeId.components(separatedBy: "_")
        return locationString[0]
    }
}
