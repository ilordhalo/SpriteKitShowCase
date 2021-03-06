//
//  HumanJumpingState.swift
//  SpriteKitShowCase
//
//  Created by zhangjiahao.me on 2022/1/12.
//

import Foundation
import GameplayKit

class HumanJumpingState: GKState {
    
    unowned var entity: GKEntity
    
    required init(entity: GKEntity) {
        self.entity = entity
    }
    
    // MARK: Components Getter
    
    var animationComponent: AnimationComponent {
        guard let animationComponent = entity.component(ofType: AnimationComponent.self) else {
            fatalError("HumanJumpingState's entity must have an AnimationComponent.")
        }
        return animationComponent
    }
    
    var renderComponent: RenderComponent {
        guard let renderComponent = entity.component(ofType: RenderComponent.self) else {
            fatalError("HumanJumpingState's entity must have an RenderComponent.")
        }
        return renderComponent
    }
    
    // MARK: GKState Life Cycle
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        
        animationComponent.removeAnimation()
        renderComponent.spriteNode.setTexture(texture: SKTexture(imageNamed: "human_jumping"), resize: true)
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        if stateClass == HumanJumpingState.self {
            return false
        }
        return true
    }
}
