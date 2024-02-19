//
//  ArtistData.swift
//  MEME
//
//  Created by 황채웅 on 1/26/24.
//

//예약관리탭
var resMakeUpNameArray : [String] = ["메이크업1","메이크업2","메이크업3"]
var resModelNameArray : [String] = ["모델1","모델2","모델3"]
var resDateArray : [String] = ["2024.01.01 월","2024.01.02 화","2024.01.03 수"]
var todayDate : String = "2024.01.26 금"
var onComingArray : [Bool] = [false,false,true]

// 홈뷰컨 구성 요소
// 예약 전적 유무
var isReservation : Bool = true
// 포트폴리오 카테고리
var portfolioCategories = PortfolioCategories.allCases

//프로필 포트폴리오 구성요소
var portfolioMakeupTagArray : [String] = ["데일리 메이크업1", "기본 메이크업2", "특수 메이크업3","데일리 메이크업1", "기본 메이크업2", "특수 메이크업3","데일리 메이크업1", "기본 메이크업2", "특수 메이크업3"]
var portfolioMakeupNameArray : [String] = ["메이크업명1","메이크업명2","메이크업명3","메이크업명1","메이크업명2","메이크업명3","메이크업명1","메이크업명2","메이크업명3"]
var portfolioPriceArray : [String] = ["가격1","가격2","가격3","가격1","가격2","가격3","가격1","가격2","가격3"]
var portfolioImageArray : [String] = ["eximage","eximage","eximage","eximage","eximage","eximage","eximage","eximage","eximage"]
var profilemakeupTagArray : [String] = ["데일리 메이크업","배우 메이크업","배우 메이크업","데일리 메이크업","배우 메이크업","배우 메이크업","데일리 메이크업","배우 메이크업","배우 메이크업"]

struct ReservationDummyData {
    var resMakeupName: String
    var resDate: String
}

struct PortfolioCategoryData {
    let name: String
    let category: PortfolioCategories
}
var portfolioIdx: Int = -1

struct PortfolioComponent {
}
