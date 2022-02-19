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
        let now  = dateModel.convertStringToDate1(dateString: "2022年01月08日13時00分")
        let past = dateModel.convertStringToDate1(dateString: "2022年01月10日19時00分")
       
       
       
        let result = dateModel.checkDate(now:now , past:past )
        XCTAssertEqual(result,answer)
    }
    func testPattern2(){
        let dateModel = DateModel()
        let answer = ["日が違う","月が同じ","年が同じ","週が同じ"]
        let now  = dateModel.convertStringToDate1(dateString: "2022年01月08日12時00分")
        let past = dateModel.convertStringToDate1(dateString: "2022年01月09日22時00分")
        
        let result = dateModel.checkDate(now: now, past: past)
        //yyyyMMdd -> 20211215
        XCTAssertEqual(result,answer)
    }
    func testPattern3(){
        let dateModel = DateModel()
        let answer = ["日が違う","月が違う","年が同じ","週が同じ"]
        let now  = dateModel.convertStringToDate1(dateString: "2022年01月31日11時00分")
        let past = dateModel.convertStringToDate1(dateString: "2022年02月01日12時00分")
       
        let result = dateModel.checkDate(now: now, past: past)
        //yyyyMMdd -> 20211215
        XCTAssertEqual(result,answer)
    }
    func testPattern4(){
        let dateModel = DateModel()
        let answer = ["日が違う","月が違う","年が同じ","週が違う"]
        let now  = dateModel.convertStringToDate1(dateString: "2022年01月31日23時00分")
        let past = dateModel.convertStringToDate1(dateString: "2022年02月10日11時00分")
       
        let result = dateModel.checkDate(now: now, past: past)
        //yyyyMMdd -> 20211215
        XCTAssertEqual(result,answer)
    }
    func testPattern5(){
        let dateModel = DateModel()
        let answer = ["日が違う","月が違う","年が違う","週が違う"]
        let now  = dateModel.convertStringToDate1(dateString: "2022年02月10日11時00分")
        let past = dateModel.convertStringToDate1(dateString: "2023年02月10日22時00分")
       
        let result = dateModel.checkDate(now: now, past: past)
        //yyyyMMdd -> 20211215
        XCTAssertEqual(result,answer)
    }
    func testPattern6(){
        let dateModel = DateModel()
        let answer = ["日が違う","月が違う","年が同じ","週が違う"]
        let now  = dateModel.convertStringToDate1(dateString: "2022年01月30日22時00分")
        let past = dateModel.convertStringToDate1(dateString: "2022年02月10日08時00分")
       
        let result = dateModel.checkDate(now: now, past: past)
        //yyyyMMdd -> 20211215
        XCTAssertEqual(result,answer)
    }
    func testPattern7(){
        let dateModel = DateModel()
        let answer = ["日が違う","月が同じ","年が同じ","週が違う"]
        let now  = dateModel.convertStringToDate1(dateString: "2022年02月01日08時00分")
        let past = dateModel.convertStringToDate1(dateString: "2022年02月28日22時00分")
       
        let result = dateModel.checkDate(now: now, past: past)
        //yyyyMMdd -> 20211215
        XCTAssertEqual(result,answer)
    }
    func testPattern8(){
        let dateModel = DateModel()
        let answer = ["日が違う","月が同じ","年が同じ","週が違う"]
        let now  = dateModel.convertStringToDate1(dateString: "2022年03月03日08時00分")
        let past = dateModel.convertStringToDate1(dateString: "2022年03月08日11時00分")
       
        let result = dateModel.checkDate(now: now, past: past)
        //yyyyMMdd -> 20211215
        XCTAssertEqual(result,answer)
    }
    func testPattern9(){
        let dateModel = DateModel()
        let answer = ["日が違う","月が違う","年が同じ","週が同じ"]
        let now  = dateModel.convertStringToDate1(dateString: "2022年02月28日21時00分")
        let past = dateModel.convertStringToDate1(dateString: "2022年03月05日11時00分")
       
        let result = dateModel.checkDate(now: now, past: past)
        //yyyyMMdd -> 20211215
        XCTAssertEqual(result,answer)
    }
    
    func testPattern10(){
        let dateModel = DateModel()
        let answer = ["日が違う","月が違う","年が同じ","週が違う"]
       
        let now  = dateModel.convertStringToDate1(dateString: "2022年01月08日21時00分")
        let past = dateModel.convertStringToDate1(dateString: "2022年12月25日11時00分")
       
        let result = dateModel.checkDate(now: now, past: past)
        //yyyyMMdd -> 20211215
        XCTAssertEqual(result,answer)
    }
    
    
    
    
}
