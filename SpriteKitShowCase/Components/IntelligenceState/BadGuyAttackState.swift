//
//  BadGuyAttackState.swift
//  SpriteKitShowCase
//
//  Created by zhangjiahao.me on 2022/2/9.
//

import Foundation
import GameplayKit

class BadGuyAttackState: GKState {
    unowned var entity: GKEntity
    
    required init(entity: GKEntity) {
        self.entity = entity
    }
    
    // MARK: Components Getter
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        
        print("hunt")
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        if stateClass == BadGuyAttackState.self {
            return false
        }
        return true
    }
}
