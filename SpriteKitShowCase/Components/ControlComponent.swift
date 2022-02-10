//
//  ControlComponent.swift
//  SpriteKitShowCase
//
//  Created by zhangjiahao.me on 2022/2/10.
//

import Foundation
import GameplayKit

enum ControlCommand: Int {
    case unknown = 0
    case jump = 1
    case goLeft = 2
    case goRight = 3
    case attack = 4
    case stop = 5
    
    case stopGoLeft = 12
    case stopGoRight = 13
}

struct ControlProperty {
    var jumpVector: CGVector
    var runVelocity: CGFloat
}

class ControlComponent: GKComponent {
    // MARK: Properties
    
    var requestedCommand: ControlCommand?
    
    private var controlProperty: ControlProperty
    
    // MARK: Component Getter
    
    var humanComponent: HumanComponent {
        guard let humanComponent = entity?.component(ofType: HumanComponent.self) else {
            fatalError("A PlayerControlComponent's entity must have a HumanComponent")
        }
        return humanComponent
    }
    
    var directionComponent: DirectionComponent {
        guard let directionComponent = entity?.component(ofType: DirectionComponent.self) else {
            fatalError("A PlayerControlComponent's entity must have a DirectionComponent")
        }
        return directionComponent
    }
    
    var physicsComponent: PhysicsComponent {
        guard let physicsComponent = entity?.component(ofType: PhysicsComponent.self) else {
            fatalError("A PlayerControlComponent's entity must have a PhysicsComponent")
        }
        return physicsComponent
    }
    
    var attackComponent: AttackComponent {
        guard let attackComponent = entity?.component(ofType: AttackComponent.self) else {
            fatalError("A PlayerControlComponent's entity must have a AttackComponent")
        }
        return attackComponent
    }
    
    // MARK: Initializers
    
    init(control: ControlProperty) {
        controlProperty = control
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Component Lift Cycle
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        guard let requestedCommand = requestedCommand else {
            return
        }
        
        handleCommand(command: requestedCommand)
        self.requestedCommand = nil
    }
    
    // MARK: Private
    
    private func handleCommand(command: ControlCommand) {
        switch command {
        case .jump:
            if physicsComponent.onTheGround {
                physicsComponent.physicsBody.applyImpulse(controlProperty.jumpVector)
            }
        case .goLeft:
            directionComponent.requestedDirection = .left
            physicsComponent.physicsBody.velocity.dx = controlProperty.runVelocity * directionComponent.K
        case .goRight:
            directionComponent.requestedDirection = .right
            physicsComponent.physicsBody.velocity.dx = controlProperty.runVelocity * directionComponent.K
        case .attack:
            physicsComponent.physicsBody.velocity.dx = 0
            attackComponent.requestedAttack = true
        case .stopGoLeft, .stopGoRight, .stop:
            physicsComponent.physicsBody.velocity.dx = 0
        default:
            break
        }
    }
}
