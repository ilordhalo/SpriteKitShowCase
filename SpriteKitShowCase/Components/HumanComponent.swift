//
//  HumanComponent.swift
//  SpriteKitShowCase
//
//  Created by zhangjiahao.me on 2022/1/12.
//

import Foundation
import GameplayKit

class HumanComponent: GKComponent {
    
    let stateMachine: GKStateMachine
    
    init(states: [GKState]) {
        stateMachine = GKStateMachine(states: states)
        
        stateMachine.enter(HumanStandingState.self)
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Components Getter
    
    var animationComponent: AnimationComponent {
        guard let animationComponent = entity?.component(ofType: AnimationComponent.self) else {
            fatalError("A HumanComponent's entity must have a AnimationComponent")
        }
        return animationComponent
    }
    
    var renderComponent: RenderComponent {
        guard let renderComponent = entity?.component(ofType: RenderComponent.self) else {
            fatalError("A HumanComponent's entity must have a RenderComponent")
        }
        return renderComponent
    }
    
    var physicsComponent: PhysicsComponent {
        guard let physicsComponent = entity?.component(ofType: PhysicsComponent.self) else {
            fatalError("A HumanComponent's entity must have a PhysicsComponent")
        }
        return physicsComponent
    }
    
    var directionComponent: DirectionComponent {
        guard let directionComponent = entity?.component(ofType: DirectionComponent.self) else {
            fatalError("A HumanComponent's entity must have a DirectionComponent")
        }
        return directionComponent
    }
    
    var attackComponent: AttackComponent {
        guard let attackComponent = entity?.component(ofType: AttackComponent.self) else {
            fatalError("A HumanComponent's entity must have a AttackComponent")
        }
        return attackComponent
    }
    
    var hurtComponent: HurtComponent {
        guard let hurtComponent = entity?.component(ofType: HurtComponent.self) else {
            fatalError("A HumanComponent's entity must have a HurtComponent")
        }
        return hurtComponent
    }
    
    // MARK: Update Action
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        if hurtComponent.isHurting {
            stateMachine.enter(HumanHurtState.self)
            return
        }
        
        if !physicsComponent.onTheGround {
            stateMachine.enter(HumanJumpingState.self)
        } else {
            if attackComponent.isAttacking {
                stateMachine.enter(HumanAttackingState.self)
            } else if physicsComponent.physicsBody.velocity.dx != 0 {
                stateMachine.enter(HumanRunningState.self)
            } else {
                stateMachine.enter(HumanStandingState.self)
            }
        }
    }
}
