//
//  HumanRunningState.swift
//  SpriteKitShowCase
//
//  Created by zhangjiahao.me on 2022/1/12.
//

import Foundation
import GameplayKit

class HumanRunningState: GKState {
    unowned var entity: GKEntity
    
    required init(entity: GKEntity) {
        self.entity = entity
    }
    
    override func didEnter(from previousState: GKState?) {
        
    }
}
