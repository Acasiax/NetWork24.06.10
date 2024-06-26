//
//  BookViewController.swift
//  NetWork24.06.10
//
//  Created by 이윤지 on 6/10/24.
//

import UIKit
import Alamofire
import SnapKit
import Kingfisher
//페이지네이션
//1. 스크롤이 끝날 쯤에 다음 페이지를 요청 (pace += 1 후 kakaobookfetchdata)
//2/ 이전 내용은 어떻게 확인하자?
//3. 다른 검색어를 입력할 때는? == page 1
// - 교체가 아니라 append로 되고 있는 문제 발생
// - 1페이지부터 검색 되도록 설정
 // - 상단으로 스크롤을 이동
//4. 배열을 언제 제거해줄 지?
//5. 마지막 페이지 처리
// 서버의 데이터가 바뀌면 사용자가 실시간으로 글을 추가할 때 중복 추가되는 문제가 발생할 수 있음


//struct Market: Decodable {
//    let market: String
//    let koreanName: String
//    let englishName: String
//    
//    enum CodingKeys: String, CodingKey {
//        case market
//        case koreanName = "korean_name"
//        case englishName = "english_name"
//    }
//}



class BookViewController: UIViewController {

    let searchBar = UISearchBar()
    let tableView = UITableView()
    
    var list = KakaoBook(documents: [], meta: Meta(is_end: false, pageable_count: 0, total_count: 0))

    var page = 1
    var isEnd = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
       // KakaoBookfetchData(query: searchBar.text!)
    }
    
    
    func configureView(){
        print(#function)
        view.backgroundColor = .white
        view.addSubview(searchBar)
        view.addSubview(tableView)
        tableView.backgroundColor = .brown
        tableView.rowHeight = 120
        
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        tableView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(searchBar.snp.bottom)
        }
        
        searchBar.delegate = self
        tableView.prefetchDataSource = self
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BookTableViewCell.self, forCellReuseIdentifier: BookTableViewCell.id)
        
        
    }

    func KakaoBookfetchData(query: String) {
        print(#function)
        
       // let query = ""
        let url = "\(APIURL.KakaoBookURL) + \(query) + &page\(page) + &size=10"
        print(#function, url)
        let header: HTTPHeaders = ["Authorization": APIKey.kakaoAuthorization] //파라미터랑은 무관, 파라미터를 제이슨으로 바꿔주지는 않음. 제이슨한테 보내는 타입의 형식만 보내는(알려주는) 것임
       
        AF.request(url, method: .get, headers: header).responseString { response in
            print("응답되는지 일단 확인📍\(response)")
        }
        
        AF.request(url, method: .get, headers: header).responseDecodable(of: KakaoBook.self) { response in
            
            print("STAUS 상태코드: \(response.response?.statusCode ?? 0)")
            
            switch response.result {
            case .success(let value):
                dump(value)
                
                self.isEnd = value.meta.is_end
                
                if self.page == 1{
                    self.list = value
                    
                }else{
                    self.list.documents.append(contentsOf: value.documents)
                }
                self.tableView.reloadData()
                
                //페이지가 1번일 때 새롭게 검색할 때 스크롤을 위로 상단으로 거게 싶을 때
                if self.page == 1 {
                    self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
                }
                
            case .failure(let error):
                print("⚡️실패했다 원인은?: \(error)")
            }
        }
    }
    
    
  
}


extension BookViewController: UISearchBarDelegate {
    
    //이거 애플에서 제공해주는 함수 이름? 사용자 정의 함수 아님
    
    //무조건 통신이 들어가지 않고,
    //빈칸, 최소 1자 이상, 같은 글자 등에 대한 처리가 필요할 수 있음.
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("클릭")
        page = 1 //첫페이지로 검색되도록 설정
        KakaoBookfetchData(query: searchBar.text!)
    }
    
    
}

    extension BookViewController: UITableViewDataSourcePrefetching {
        // cellForRowAt이 호출되기 전에 미리 호출됨
        // 즉, 셀이 화면에 보이기 직전에 필요한 리소스를 미리 다운받는 기능
        // 호출 시점은 애플이 알아서 결정!
        func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
            // indexPaths가 잘못 정의되어 있었음
            print("🧯Prefetch \(indexPaths)")
            for item in indexPaths {
                
                if list.documents.count - 2 == item.row && isEnd == false {
                    page += 1 //클라이언트 쪽에서 직접 핸들링
                    KakaoBookfetchData(query: searchBar.text!)
                    
                }
                
                
            }
            
        }

        func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
            // prefetch 작업을 취소하는 코드 작성
            print("🫧Cancel prefetching for \(indexPaths)")
         
        }
    }


extension BookViewController:UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.documents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BookTableViewCell.id, for: indexPath) as! BookTableViewCell
        let data = list.documents[indexPath.row]
        cell.titleLabel.text = data.title
        cell.overviewLabel.text = data.contents
        let url = URL(string: data.thumbnail)
        cell.thumbnailImageView.kf.setImage(with: url)
        return cell
    }
}
   


extension BookViewController {
    // 1. url
    // 2. query string
    // 3. http header - authorization
    // 4. request
    // 5. response  6. (ex. responseSting)으로 응답 되는 지 먼저 확인
    // 7. struct
    // 8. http status code
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
        // - 🌱실패 했을 때 nil이 제이슨에서 오는데, 거기에 구조체에 못들어가기 때문에 디코딩 구조체 오류가 뜨는 것. 오류가 뜨는 이유는 성공 했을 때에 사용할 성공 전용 디코딩 구조체(식판)이라서
        // 2. '성공'이 프린트 될까 '실패'가 프린트 될까?
        // 3. '성공'과 '실패'의 기준이 무엇인가?
        // 2번&3번 답 - 🌱상태코드를 기준으로 판별된다.
        
        //.validate(statusCode: 200..<300) //응답을 하기 전에 위에 코드에 위치해서 200..<300까지를 성공으로 간주한다는 코드임 -> 근데 이미 Alamofire에 내장되어 있어서 안 써도 되는 것임. Alamofire가 인식을 못할 때 혹은 더 명확하게 제시해줘야 할 때 사용한다.
        AF.request(url, method: .post, headers: header).responseDecodable(of: Book.self) { response in
            
            print("STAUS 상태코드: \(response.response?.statusCode ?? 0)")
            
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

// 🐻+보너스+ .validate(statusCode: 200..<500) 상태코드를 그러면 500으로 상태코드 성공 범위를 설정해주면 실패한 데이터도 성공으로 바뀌느냐?
// -> 그렇지 않는다. 왜냐면 상태코드를 설정해줘도, 디코딩 구조체(식판)에 맞지 않기 때문
// 성공 실패가 나는 이유는 크게 2가지 - 디코딩 구조체(식판)에 맞지 않을 때 or 상태코드가 실패로 나눠질 때





//페이지네이션
// 1. 테이블뷰 willdisplay cell (메서드)
//2. scrollview offset
//3. tableview prefetching(프리패칭)

//컬렉션뷰
// 가로,세로 스크롤이 가능
//여러 행/ 열
 
