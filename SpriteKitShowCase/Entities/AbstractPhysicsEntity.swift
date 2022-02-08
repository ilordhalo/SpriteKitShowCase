//
//  AbstractPhysicsEntity.swift
//  SpriteKitShowCase
//
//  Created by zhangjiahao.me on 2022/2/7.
//

import Foundation
import GameplayKit

class AbstractPhysicsEntity: GKEntity {
    var game: Game
    var node: SKSpriteNode
    
    // MARK: Initializers
    
    init(game: Game, node: SKSpriteNode) {
        self.game = game
        self.node = node
        
        super.init()
        
        node.entity = self
        setupComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupComponents() {
        node.physicsBody!.restitution = PhysicsWorld.Entities.AbstractPhysics.restitution
        let physicsComponent = PhysicsComponent(physicsBody: node.physicsBody!, colliderType: .Obstacle)
        addComponent(physicsComponent)
        
        let groundComponent = GroundComponent()
        addComponent(groundComponent)
    }
}
