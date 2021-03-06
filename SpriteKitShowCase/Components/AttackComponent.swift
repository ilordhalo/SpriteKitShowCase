//
//  AttackComponent.swift
//  SpriteKitShowCase
//
//  Created by zhangjiahao.me on 2022/1/20.
//

import Foundation
import GameplayKit

let attackCommandInterval: TimeInterval = 0.2
let attackComboInterval: TimeInterval = 1
let attackActionInterval: TimeInterval = 0.2

enum AttackState: Int {
    case hit = 0
    case hardHit = 1
    case kick = 2
}

class AttackComponent: GKComponent {
    
    var requestedAttack: Bool = false
    private var commandInterval: CGFloat = 0
    private var comboInterval: CGFloat = 0
    private var actionInterval: CGFloat = 0
    var isAttacking: Bool {
        return actionInterval < attackActionInterval
    }
    
    private var attackState: AttackState?
    
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
        
        commandInterval += seconds
        comboInterval += seconds
        actionInterval += seconds
        
        if comboInterval >= attackComboInterval {
            attackState = nil
            comboInterval = 0
        }
        
        if commandInterval >= attackCommandInterval {
            if requestedAttack {
                enterNextAttack()
                requestedAttack = false
                comboInterval = 0
                commandInterval = 0
            }
        }
    }
    
    private func enterNextAttack() {
        if attackState == nil {
            enter(state: .hit)
        } else {
            enter(state: AttackState(rawValue: (attackState!.rawValue + 1) % 3)!)
        }
        
        actionInterval = 0
    }
    
    private func enter(state: AttackState) {
        attackState = state
        switch state {
        case .hit:
            animationComponent.requestedAnimationIdentifier = .humanAttackHit
        case .hardHit:
            animationComponent.requestedAnimationIdentifier = .humanAttackHardHit
        case .kick:
            animationComponent.requestedAnimationIdentifier = .humanAttackKick
        }
    }
}
