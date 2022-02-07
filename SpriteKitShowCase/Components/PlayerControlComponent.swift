//
//  PlayerControlComponent.swift
//  SpriteKitShowCase
//
//  Created by zhangjiahao.me on 2022/1/12.
//

import Foundation
import GameplayKit

class PlayerControlComponent: GKComponent {
    
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
    
    // MARK: Public
    
    func keyDown(with event: NSEvent) {
        switch event.keyCode {
        case 0x31:
            break;
        case 13:
            // w
            humanComponent.stateMachine.enter(HumanJumpingState.self)
            break;
        case 2:
            // d
            directionComponent.requestedDirection = .right
            humanComponent.stateMachine.enter(HumanRunningState.self)
        case 0:
            // a
            directionComponent.requestedDirection = .left
            humanComponent.stateMachine.enter(HumanRunningState.self)
            break;
        default:
            print("keyDown: \(event.characters!) keyCode: \(event.keyCode)")
        }
    }
    
    func keyUp(with event: NSEvent) {
        switch event.keyCode {
        case 0, 2:
            // a, d
            humanComponent.stateMachine.enter(HumanStandingState.self)
            break;
        default:
            print("keyDown: \(event.characters!) keyCode: \(event.keyCode)")
        }
    }
}
