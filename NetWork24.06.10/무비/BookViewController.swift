//
//  BookViewController.swift
//  NetWork24.06.10
//
//  Created by 이윤지 on 6/10/24.
//

import UIKit
import Alamofire

struct Market: Decodable {
    let market: String
    let koreanName: String
    let englishName: String
    
    enum CodingKeys: String, CodingKey {
        case market
        case koreanName = "korean_name"
        case englishName = "english_name"
    }
}



class BookViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
      //  callResquest()
        callRequestKoGPT()
    }
    
    func configureView() {
        print(#function)
        view.backgroundColor = .white
    }
    
    // 1. url
    // 2. query string
    // 3. http header - authorization
    // 4. request
    // 5. response (ex. responseSting)으로 응답 되는 지 먼저 확인
    func callResquest() {
        print(#function)
        
        let url = APIURL.naverBookURL + "query=%EA%B8%8D%EC%A0%95&display=5&start=6"
        //let url = "https://openapi.naver.com/v1/search/book.json?query=%EA%B8%8D%EC%A0%95&display=5&start=6"
        
        let header: HTTPHeaders = ["X-Naver-Client-Id" : APIKey.naverClientID,
                      "X-Naver-Client-Secret" :  APIKey.naverClientSecret]
        
        AF.request(url, method: .get, headers: header).responseString { response in
            print("응답되는지 일단 확인📍\(response)")
        }
        
        
        AF.request(url, method: .get, headers: header).responseDecodable(of: Book.self) { response in
                switch response.result {
                case .success(let value):
                    print("🥳JSON성공했다: \(value)")
                case .failure(let error):
                    print(error)
                }
            }
            
        }
    
    func callRequestKoGPT() {
        print(#function)
        
        let url = APIURL.KoGPTURL
        //let url = "https://openapi.naver.com/v1/search/book.json?query=%EA%B8%8D%EC%A0%95&display=5&start=6"
        
        let header: HTTPHeaders = ["Authorization": APIKey.kakaoAuthorization,
                                   "Content-Type": APIKey.kakaoContent_Type] //파라미터랑은 무관, 파라미터를 제이슨으로 바꿔주지는 않음. 제이슨한테 보내는 타입의 형식만 보내는(알려주는) 것임
        
        let parameter: Parameters = ["prompt" : "안녕하세요. 저는 이불꽁꽁조아 입니다.", "max_tokens" : 50]
        
        // parameters가 encoding될때 URLEncoding.httpBody로 들어갈 건지 URLEncoding.queryString으로 들어갈 건지 결정을 못해서 애매하게 parameters 라고 되어 있는 것이다.
        //🌟encoding: JSONEncoding.default🌟 -> Content-Type"이 제이슨이기 때문에(인솜미아- 바디에서도 제이슨으로 형태 바꿈) 이렇게 해준다!
        AF.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: header).responseString { response in
            print("응답되는지 일단 확인📍\(response)")
        }
        
        // 1. 디코딩 구조체 오류가 아닌데 왜 식판 오류 문구가 뜰까?(쿼리는 지워봤음)
        // - 실패 했을 때 nil이 제이슨에서 오는데, 거기에 구조체에 못들어가기 때문에 디코딩 구조체 오류가 뜨는 것. 오류가 뜨는 이유는 성공 했을 때에 사용할 성공 전용 디코딩 구조체(식판)이라서
        // 2. '성공'이 프린트 될까 '실패'가 프린트 될까?
        // 3. '성공'과 '실패'의 기준이 무엇인가?
        AF.request(url, method: .post, headers: header).responseDecodable(of: Book.self) { response in
                switch response.result {
                case .success(let value):
                    print("🥳JSON성공했다: \(value)")
                case .failure(let error):
                    print("⚡️실패했다 원인은?: \(error)")
                }
            }
        
    }


}


//get 가지고 오고 -> queryString url 1.중요,사적  2. 보내야하는 데이터의 양
//post 보내는 거
