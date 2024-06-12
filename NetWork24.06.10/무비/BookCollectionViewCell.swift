//
//  BoolCollectionViewCell.swift
//  NetWork24.06.10
//
//  Created by 이윤지 on 6/11/24.
//

import UIKit

class BookCollectionViewCell: UICollectionViewCell {
    static let identifier = "BookCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // 셀 초기화 코드
        backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
