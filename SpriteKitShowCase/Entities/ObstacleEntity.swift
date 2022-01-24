//
//  ObstacleEntity.swift
//  SpriteKitShowCase
//
//  Created by zhangjiahao.me on 2022/1/24.
//

import Foundation
import GameplayKit

class ObstacleEntity: GKEntity {
    var game: Game
    var node: SKSpriteNode
    
    // MARK: Initializers
    
    init(game: Game, node: SKSpriteNode) {
        self.game = game
        self.node = node
        
        super.init()
        
        setupComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupComponents() {
        let renderComponent = RenderComponent(spriteNode: node)
        addComponent(renderComponent)
        
        let physicsComponent = PhysicsComponent(physicsBody: node.physicsBody!, colliderType: .Obstacle)
        addComponent(physicsComponent)
        
        let groundComponent = GroundComponent()
        addComponent(groundComponent)
    }
}
