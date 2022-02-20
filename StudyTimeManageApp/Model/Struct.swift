//
//  Struct.swift
//  StudyTimeManageApp
//
//  Created by Yabuki Shodai on 2021/12/14.
//

import Foundation


struct userRecord {
    let studyTime:Double
    let postID   :String
    let comment  :String
    let date     :Date
    let category :String
}


struct Record {
    let image    :String
    let username :String
    let postid   :String
    let userid   :String
    let studyTime:Double
    let comment  :String
    let date     :Date
    let category :String
}

struct Comment {
    let username :String
    let image    :String
    let userid   :String
    let commentid:String
    let postid   :String
    let comment  :String
    let date     :Date
}

struct Profile:Codable {
    var username :String
    var goal     :String
    var image    :String
    var userid   :String
}

struct studyTime {
    var total    :Double
    var month    :Double
    var day      :Double
}

//セルの順番に関する構造体
struct CellOrder {
    var pieChart :Int
    var Data     :Int
    var goal     :Int
    var BarChart :Int
    var until    :Int
    var predict  :Int
}
struct Time {
    var hour     :Int
    var minutes  :Int
}
struct Monthly:Codable {
    var year:Date
    var month:[Double]
}

struct License{
    let name:String
    let body:String
}
