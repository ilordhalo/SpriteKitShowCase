//
//  RenderComponent.swift
//  SpriteKitShowCase
//
//  Created by zhangjiahao.me on 2022/1/14.
//

import Foundation
import GameplayKit

class SpriteNode: SKSpriteNode {
    override var size: CGSize {
        didSet {
            
        }
    }
}

class RenderComponent: GKComponent {
    
    var spriteNode: SKSpriteNode
    
    init(spriteNode: SKSpriteNode) {
        self.spriteNode = spriteNode
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didAddToEntity() {
        spriteNode.entity = entity
    }
    
    override func willRemoveFromEntity() {
        spriteNode.entity = nil
    }
}
