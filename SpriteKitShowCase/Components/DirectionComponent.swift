//
//  DirectionComponent.swift
//  SpriteKitShowCase
//
//  Created by zhangjiahao.me on 2022/1/14.
//

import Foundation
import GameplayKit

enum Direction: Int {
    case left = 0
    case right = 1
}

class DirectionComponent: GKComponent {

    var requestedDirection: Direction?
    
    var K: CGFloat {
        var direction = currentDirection
        if let requestedDirection = requestedDirection {
            direction = requestedDirection
        }
        
        return direction == .left ? -1 : 1
    }
    
    private(set) var currentDirection: Direction = .right
    
    var renderComponent: RenderComponent {
        guard let renderComponent = entity?.component(ofType: RenderComponent.self) else {
            fatalError("A HumanComponent's entity must have a RenderComponent")
        }
        return renderComponent
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        changeDirectionIfNeeded()
        
        requestedDirection = nil
    }
    
    private func changeDirectionIfNeeded() {
        guard let requestedDirection = requestedDirection else {
            return
        }
        
        if (currentDirection == requestedDirection) {
            return
        }
        
        renderComponent.spriteNode.xScale *= -1.0
        currentDirection = requestedDirection
    }
}
