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
    
    // MARK: Components Getter
    
    var animationComponent: AnimationComponent {
        guard let animationComponent = entity.component(ofType: AnimationComponent.self) else {
            fatalError("HumanRunningState's entity must have an AnimationComponent.")
        }
        return animationComponent
    }
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        
        animationComponent.requestedAnimationIdentifier = AnimationIdentifier.humanRun
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        if stateClass == HumanRunningState.self {
            return false
        }
        return true
    }
}
