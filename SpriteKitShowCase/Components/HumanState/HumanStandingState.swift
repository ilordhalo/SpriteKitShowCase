//
//  HumanStandingState.swift
//  SpriteKitShowCase
//
//  Created by zhangjiahao.me on 2022/1/12.
//

import Foundation
import GameplayKit

class HumanStandingState: GKState {
    unowned var entity: GKEntity
    
    required init(entity: GKEntity) {
        self.entity = entity
    }
    
    // MARK: Components Getter
    
    var animationComponent: AnimationComponent {
        guard let animationComponent = entity.component(ofType: AnimationComponent.self) else {
            fatalError("HumanStandingState's entity must have an AnimationComponent.")
        }
        return animationComponent
    }
    
    var renderComponent: RenderComponent {
        guard let renderComponent = entity.component(ofType: RenderComponent.self) else {
            fatalError("HumanStandingState's entity must have an RenderComponent.")
        }
        return renderComponent
    }
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        
        animationComponent.removeAnimation()
        renderComponent.spriteNode.setTexture(texture: SKTexture(imageNamed: "human"), resize: true)
    }
}
