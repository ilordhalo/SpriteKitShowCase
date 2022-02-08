//
//  PlayerControlComponent.swift
//  SpriteKitShowCase
//
//  Created by zhangjiahao.me on 2022/1/12.
//

import Foundation
import GameplayKit

let CommandInterval: CGFloat = 0.1

struct PlayerCommand {
    enum KeyCode: Int {
        case w = 13
        case a = 0
        case d = 2
        case j = 38
    }
    
    enum EventType: Int {
        case keyDown = 0
        case keyUp = 1
    }
    
    enum CommandType: Int {
        case unknown = 0
        case jump = 1
        case goLeft = 2
        case goRight = 3
        case attack = 4
        
        case stopGoLeft = 12
        case stopGoRight = 13
    }
    
    var keyCode: KeyCode?
    var eventType: EventType
    var commandType: CommandType?
    
    init (keyCode: Int, eventType: EventType) {
        self.keyCode = KeyCode(rawValue: keyCode)
        self.eventType = eventType
        
        if (self.keyCode != nil) {
            commandType = commandTypeFromKeyCode(keyCode: self.keyCode!, eventType: self.eventType)
        } else {
            self.commandType = .unknown
        }
    }
    
    private func commandTypeFromKeyCode(keyCode: KeyCode, eventType: EventType) -> CommandType? {
        var commandType: CommandType? = .unknown
        
        switch keyCode {
        case .w:
            commandType = .jump
        case .a:
            commandType = .goLeft
        case .d:
            commandType = .goRight
        case .j:
            commandType = .attack
        }
        
        if (eventType == .keyUp) {
            commandType = CommandType(rawValue: commandType!.rawValue + 10)
        }
        
        return commandType
    }
}

class PlayerControlComponent: GKComponent {
    
    var commandQueue = [PlayerCommand]()
    var interval: CGFloat = 0
    
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
    
    // MARK: Public
    
    func keyDown(with event: NSEvent) {
        addCommand(command: PlayerCommand(keyCode: Int(event.keyCode), eventType: .keyDown))
    }
    
    func keyUp(with event: NSEvent) {
            addCommand(command: PlayerCommand(keyCode: Int(event.keyCode), eventType: .keyUp))
    }
    
    private func addCommand(command: PlayerCommand) {
        if (command.commandType != nil) {
            commandQueue.append(command)
        }
    }
    
    private func handleCommand(command: PlayerCommand) {
        switch command.commandType {
        case .jump:
            if physicsComponent.onTheGround {
                physicsComponent.physicsBody.applyImpulse(PhysicsWorld.Entities.Human.jumpVector)
            }
        case .goLeft:
            directionComponent.requestedDirection = .left
            physicsComponent.physicsBody.velocity.dx = PhysicsWorld.Entities.Human.runVelocity * directionComponent.K
        case .goRight:
            directionComponent.requestedDirection = .right
            physicsComponent.physicsBody.velocity.dx = PhysicsWorld.Entities.Human.runVelocity * directionComponent.K
        case .attack:
            attackComponent.requestedAttack = true
        case .stopGoLeft, .stopGoRight:
            physicsComponent.physicsBody.velocity.dx = 0
        default:
            break
        }
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        interval += seconds
        
        if interval >= CommandInterval {
            guard let lastCommand = commandQueue.last else {
                return
            }
            handleCommand(command: lastCommand)
            
            commandQueue.removeAll()
            interval = 0
        }
    }
}
