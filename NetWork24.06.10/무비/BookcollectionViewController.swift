//
//  BookcollectionViewController.swift
//  NetWork24.06.10
//
//  Created by 이윤지 on 6/11/24.
//


import UIKit
import SnapKit

class BookCollectionViewController: UIViewController {

    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    //static func 으로 쓰거나 lazy var collectionView로
    func collectionViewLayout() -> UICollectionViewLayout{
        let layout = UICollectionViewFlowLayout()
        let sectionSpacing: CGFloat = 20
        let cellSpaing: CGFloat = 16
        let width = UIScreen.main.bounds.width - (sectionSpacing * 2) - (cellSpaing * 2)
        layout.itemSize = CGSize(width: width/3, height: width/3)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = cellSpaing//아이템 사이 간격
        layout.minimumInteritemSpacing = cellSpaing// 아이템 위아래 사이 간격
        layout.sectionInset = UIEdgeInsets(top: CGFloat(sectionSpacing), left: CGFloat(sectionSpacing), bottom: CGFloat(sectionSpacing), right: CGFloat(sectionSpacing))//전체컬렉션의 패딩
        return layout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        view.addSubview(collectionView)
        collectionView.backgroundColor = .green
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(BookCollectionViewCell.self, forCellWithReuseIdentifier: BookCollectionViewCell.identifier)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
            
        }
    }

}

extension BookCollectionViewController:UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookCollectionViewCell.identifier, for: indexPath) as! BookCollectionViewCell
        
        return cell
    }

}
