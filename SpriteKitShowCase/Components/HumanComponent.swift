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
    
    // MARK: Public
    
    func jump() {
        physicsComponent.physicsBody.applyImpulse(PhysicsWorld.Entities.Human.jumpVector)
        renderComponent.spriteNode.setTexture(texture: SKTexture(imageNamed: "human_jumping"), resize: true)
    }
    
    func stand() {
        renderComponent.spriteNode.setTexture(texture: SKTexture(imageNamed: "human"), resize: true)
    }
    
    func run() {
        
    }
    
    func hitTheGround() {
        if self.stateMachine.currentState is HumanJumpingState {
            self.stateMachine.enter(HumanStandingState.self)
        }
    }
}
