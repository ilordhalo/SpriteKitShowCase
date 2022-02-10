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
    
    var requestedState: GKState.Type?
    
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
    
    // MARK: Update Action
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        if !physicsComponent.onTheGround {
            stateMachine.enter(HumanJumpingState.self)
        } else {
            if physicsComponent.physicsBody.velocity.dx != 0 {
                stateMachine.enter(HumanRunningState.self)
                let player = entity?.component(ofType: PlayerControlComponent.self)
                if player == nil {
                    print("run")
                }
                
            } else {
                stateMachine.enter(HumanStandingState.self)
                let player = entity?.component(ofType: PlayerControlComponent.self)
                if player == nil {
//                    print("stand")
                }
            }
        }
    }
}
