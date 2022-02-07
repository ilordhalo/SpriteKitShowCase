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
    
    private var lastFrameState: GKState.Type
    
    init(states: [GKState]) {
        stateMachine = GKStateMachine(states: states)
        
        stateMachine.enter(HumanStandingState.self)
        lastFrameState = type(of: stateMachine.currentState!)
        
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
    
    // MARK: Public
    
    func hitTheGround() {
        if stateMachine.currentState is HumanJumpingState {
            stateMachine.enter(HumanStandingState.self)
        }
    }
    
    // MARK: Update Action
    
    private func jump() {
        animationComponent.removeAnimation()
        renderComponent.spriteNode.setTexture(texture: SKTexture(imageNamed: "human_jumping"), resize: true)
    }
    
    private func stand() {
        animationComponent.removeAnimation()
        renderComponent.spriteNode.setTexture(texture: SKTexture(imageNamed: "human"), resize: true)
    }
    
    private func run() {
        animationComponent.requestedAnimationIdentifier = AnimationIdentifier.humanRun
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        if type(of: stateMachine.currentState!) == self.lastFrameState {
            return
        }
        
        if stateMachine.currentState is HumanStandingState {
            stand()
        } else if stateMachine.currentState is HumanJumpingState {
            jump()
        } else if stateMachine.currentState is HumanRunningState {
            run()
        }
        
        lastFrameState = type(of: stateMachine.currentState!)
    }
}
