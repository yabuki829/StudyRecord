//
//  Math.swift
//  10000hours
//
//  Created by Yabuki Shodai on 2021/12/01.
//

import Foundation
struct divide {
    let integer:Double
    let decimal:Double
}
struct sexagesimal{
    let hour:Int
    let minutes:Int
}
class Math{
    func generator(_ length: Int) -> String {
        let string = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString = ""
        for _ in 0 ..< length {
            randomString += String(string.randomElement()!)
        }
        return randomString
    }



}
