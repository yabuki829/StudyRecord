//
//  StudyTimeManageAppTests.swift
//  StudyTimeManageAppTests
//
//  Created by Yabuki Shodai on 2021/12/09.
//

import XCTest
@testable import StudyTimeManageApp

class StudyTimeManageAppTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }


    func testPerformanceExample() throws {
        // This is an example of a performance test case.
    }
  
    func testPattern1(){
        let dateModel = DateModel()
        let answer = ["日が違う","月が同じ","年が同じ","週が違う"]
        let now  = convertStringToDate(dateString: "20220108")
        let past = convertStringToDate(dateString: "20220110")
       
        let result = dateModel.checkDate(now: now, past: past)
        XCTAssertEqual(result,answer)
    }
    func testPattern2(){
        let dateModel = DateModel()
        let answer = ["日が違う","月が同じ","年が同じ","週が同じ"]
        let now  = convertStringToDate(dateString: "20220108")
        let past = convertStringToDate(dateString: "20220109")
        
        let result = dateModel.checkDate(now: now, past: past)
        //yyyyMMdd -> 20211215
        XCTAssertEqual(result,answer)
    }
    func testPattern3(){
        let dateModel = DateModel()
        let answer = ["日が違う","月が違う","年が同じ","週が同じ"]
        let now  = convertStringToDate(dateString: "20220131")
        let past = convertStringToDate(dateString: "20220201")
       
        let result = dateModel.checkDate(now: now, past: past)
        //yyyyMMdd -> 20211215
        XCTAssertEqual(result,answer)
    }
    func testPattern4(){
        let dateModel = DateModel()
        let answer = ["日が違う","月が違う","年が同じ","週が違う"]
        let now  = convertStringToDate(dateString: "20220131")
        let past = convertStringToDate(dateString: "20220210")
       
        let result = dateModel.checkDate(now: now, past: past)
        //yyyyMMdd -> 20211215
        XCTAssertEqual(result,answer)
    }
    func testPattern5(){
        let dateModel = DateModel()
        let answer = ["日が違う","月が違う","年が違う","週が違う"]
        let now  = convertStringToDate(dateString: "20220210")
        let past = convertStringToDate(dateString: "20230210")
       
        let result = dateModel.checkDate(now: now, past: past)
        //yyyyMMdd -> 20211215
        XCTAssertEqual(result,answer)
    }
    func testPattern6(){
        let dateModel = DateModel()
        let answer = ["日が違う","月が違う","年が同じ","週が違う"]
        let now  = convertStringToDate(dateString: "20220130")
        let past = convertStringToDate(dateString: "20220210")
       
        let result = dateModel.checkDate(now: now, past: past)
        //yyyyMMdd -> 20211215
        XCTAssertEqual(result,answer)
    }
    func testPattern7(){
        let dateModel = DateModel()
        let answer = ["日が違う","月が同じ","年が同じ","週が違う"]
        let now  = convertStringToDate(dateString: "20220201")
        let past = convertStringToDate(dateString: "20220228")
       
        let result = dateModel.checkDate(now: now, past: past)
        //yyyyMMdd -> 20211215
        XCTAssertEqual(result,answer)
    }
    func testPattern8(){
        let dateModel = DateModel()
        let answer = ["日が違う","月が同じ","年が同じ","週が違う"]
        let now  = convertStringToDate(dateString: "20220303")
        let past = convertStringToDate(dateString: "20220308")
       
        let result = dateModel.checkDate(now: now, past: past)
        //yyyyMMdd -> 20211215
        XCTAssertEqual(result,answer)
    }
    func testPattern9(){
        let dateModel = DateModel()
        let answer = ["日が違う","月が違う","年が同じ","週が同じ"]
        let now  = convertStringToDate(dateString: "20220228")
        let past = convertStringToDate(dateString: "20220305")
       
        let result = dateModel.checkDate(now: now, past: past)
        //yyyyMMdd -> 20211215
        XCTAssertEqual(result,answer)
    }
    
    func testPattern10(){
        let dateModel = DateModel()
        let answer = ["日が違う","月が違う","年が同じ","週が違う"]
        let now  = convertStringToDate(dateString: "20220108")
        let past = convertStringToDate(dateString: "20221225")
       
        let result = dateModel.checkDate(now: now, past: past)
        //yyyyMMdd -> 20211215
        XCTAssertEqual(result,answer)
    }
    
    
    func convertStringToDate(dateString:String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        dateFormatter.locale = Locale.current
        dateFormatter.calendar = .current
        
        // 変換
        let date = dateFormatter.date(from: dateString)
        // 結果表示
        return date!
    }
    
}
