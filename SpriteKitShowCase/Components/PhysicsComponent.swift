//
//  PhysicsComponent.swift
//  SpriteKitShowCase
//
//  Created by zhangjiahao.me on 2022/1/14.
//

import Foundation
import GameplayKit

class PhysicsComponent: GKComponent {
    var physicsBody: SKPhysicsBody
    private(set) var onTheGround: Bool = true
    
    init(physicsBody: SKPhysicsBody, colliderType: ColliderType) {
        self.physicsBody = physicsBody
        self.physicsBody.categoryBitMask = colliderType.categoryMask
        self.physicsBody.collisionBitMask = colliderType.collisionMask
        self.physicsBody.contactTestBitMask = colliderType.contactMask
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        if self.physicsBody.velocity.dy != 0 {
            onTheGround = false
        } else {
            onTheGround = true
        }
    }
}
