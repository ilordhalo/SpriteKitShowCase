//
//  HurtComponent.swift
//  SpriteKitShowCase
//
//  Created by 张家豪 on 2022/2/11.
//

import Foundation
import GameplayKit

let hurtActionInterval: TimeInterval = 0.2

class HurtComponent: GKComponent {
    
    var requestedHurt: Bool = false
    private var actionInterval: CGFloat = 0
    var isHurting: Bool {
        return actionInterval < hurtActionInterval
    }
    
    var renderComponent: RenderComponent {
        guard let renderComponent = entity?.component(ofType: RenderComponent.self) else {
            fatalError("A AttackComponent's entity must have a RenderComponent")
        }
        return renderComponent
    }
    
    var animationComponent: AnimationComponent {
        guard let animationComponent = entity?.component(ofType: AnimationComponent.self) else {
            fatalError("A AttackComponent's entity must have a AnimationComponent")
        }
        return animationComponent
    }
    
    var humanComponent: HumanComponent {
        guard let humanComponent = entity?.component(ofType: HumanComponent.self) else {
            fatalError("A AttackComponent's entity must have a HumanComponent")
        }
        return humanComponent
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        actionInterval += seconds
        
        if requestedHurt && !isHurting {
            animationComponent.requestedAnimationIdentifier = .humanHurt
            actionInterval = 0
            requestedHurt = false
        }
    }
}
