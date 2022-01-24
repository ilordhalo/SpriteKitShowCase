//
//  HumanDeathState.swift
//  SpriteKitShowCase
//
//  Created by zhangjiahao.me on 2022/1/12.
//

import Foundation
import GameplayKit

class HumanDeathState: GKState {
    unowned var entity: GKEntity
    
    required init(entity: GKEntity) {
        self.entity = entity
    }
}
