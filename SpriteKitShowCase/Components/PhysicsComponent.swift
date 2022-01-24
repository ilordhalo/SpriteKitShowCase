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
}
