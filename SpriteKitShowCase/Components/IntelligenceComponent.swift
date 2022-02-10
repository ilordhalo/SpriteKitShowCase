//
//  IntelligenceComponent.swift
//  SpriteKitShowCase
//
//  Created by zhangjiahao.me on 2022/1/12.
//

import Foundation
import GameplayKit

class IntelligenceComponent: GKComponent {
    // MARK: Properties
    
    let stateMachine: GKStateMachine
    
    var requestedState: GKState.Type?
    
    // MARK: Component Getter
    
    var controlComponent: ControlComponent {
        guard let controlComponent = entity?.component(ofType: ControlComponent.self) else {
            fatalError("A IntelligenceComponent's entity must have a ControlComponent")
        }
        return controlComponent
    }
    
    var rulesComponent: RulesComponent {
        guard let rulesComponent = entity?.component(ofType: RulesComponent.self) else {
            fatalError("A IntelligenceComponent's entity must have a RulesComponent")
        }
        return rulesComponent
    }
    
    var renderComponent: RenderComponent {
        guard let renderComponent = entity?.component(ofType: RenderComponent.self) else {
            fatalError("A HumanComponent's entity must have a RenderComponent")
        }
        return renderComponent
    }
    
    // MARK: Initializers
    
    init(states: [GKState]) {
        stateMachine = GKStateMachine(states: states)
        
        stateMachine.enter(BadGuyPatrolState.self)
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)

        if stateMachine.currentState is BadGuyAttackState {
            guard let snapshot = rulesComponent.ruleSystem.state[RuleState.snapshot.rawValue] as? EntitySnapshot else {
                return
            }
            
            if controlComponent.humanComponent.hurtComponent.isHurting {
                return
            }
            
            if abs(snapshot.playerPosition.x - renderComponent.spriteNode.position.x) < 15 {
                controlComponent.requestedCommand = .attack
            } else {
                if snapshot.playerPosition.x < renderComponent.spriteNode.position.x {
                    controlComponent.requestedCommand = .goLeft
                } else {
                    controlComponent.requestedCommand = .goRight
                }
            }
            
            
        } else {
            controlComponent.requestedCommand = .stop
        }
    }
}
