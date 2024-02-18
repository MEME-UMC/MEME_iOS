//
//  PortfolioAPI.swift
//  MEME
//
//  Created by 황채웅 on 2/10/24.
//

import Foundation
import Moya

enum PortfolioAPI{
    case createPortfolio(
        artistId : Int,
        category : PortfolioCategories,
        makeup_name : String,
        price : Int,
        info : String,
        portfolio_img_src : [String]
        
    )
    case getAllPortfolio(
        artistId : Int,
        page : Int
    )
    case editPortfolio(
        artistId : Int,
        portfolioId : Int,
        category : PortfolioCategories,
        makeup_name : String,
        price : Int,
        info : String,
        isBlock: Bool,
        portfolio_img_src : [String]
    )
}

extension PortfolioAPI: MemeAPI{
    var domain: MemeDomain {
        return .portfolio
    }
    
    var urlPath: String {
        switch self{
        case .createPortfolio:
            return ""
        case .getAllPortfolio(let artistId, let page):
            return "/\(artistId)"
        case .editPortfolio:
            return ""
        }
    }
    
    var error: [Int : NetworkError]? {
        return .none
    }
    
    var headerType: HTTPHeaderFields {
        switch self{
            
        case .createPortfolio, .getAllPortfolio, .editPortfolio:
            return .hasAccessToken
        }
    }
    
    var method: Moya.Method {
        switch self{
        case .createPortfolio:
            return .post
        case .getAllPortfolio:
            return .get
        case .editPortfolio:
            return .patch
        }
    }
    
    var task: Moya.Task {
        switch self{
        case .createPortfolio(
            artistId: let artistId,
            category: let category,
            makeup_name: let makeup_name,
            price: let price,
            info: let info,
            portfolio_img_src: let portfolio_img_src
        ):
            let parameters: [String: Any] = [
                "artistId": artistId,
                "category": category.rawValue,
                "makeupName": makeup_name,
                "price": price,
                "info": info,
                "portfolioImgSrc": portfolio_img_src
            ]
            //쿼리 파라미터가 아니기 때문에 JSONEncoding.default -> 바디에 담을 데이터
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        
        case .getAllPortfolio(
            artistId: let artistId,
            page: let page
        ):
            let parameters: [String:Any] = [
                "page": page
            ]
            //쿼리 파라미터이기 때문에 URLEncoding.default를 해서 URL 뒤에 붙도록 한다. ex) portfolio/?page=1
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
            
        case .editPortfolio(
            artistId: let artistId,
            portfolioId: let portfolioId,
            category: let category,
            makeup_name: let makeup_name,
            price: let price,
            info: let info,
            isBlock: let isBlock,
            portfolio_img_src: let portfolio_img_src
        ):
            let parameters: [String:Any] = [
                "artist_id": artistId,
                "portfolio_id": portfolioId,
                "category": category,
                "makeup_name": makeup_name,
                "price": price,
                "info": info,
                "isBlock": isBlock,
                "portfolio_img_src": portfolio_img_src
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }
    
    
}
