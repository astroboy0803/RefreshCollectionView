//
//  RefreshCollectionEnums.swift
//  RefreshCollectionView
//
//  Created by 黃宇新 on 2020/7/4.
//  Copyright © 2020 i9400506. All rights reserved.
//

import Foundation

enum Selection: Int, CaseIterable {
    case one = 1
    case two = 2
    case three = 3
    
    func getTitle() -> String {
        switch self {
        case .one:
            return "Page 1"
        case .two:
            return "Page 2"
        case .three:
            return "Page 3"
        }
    }
}
