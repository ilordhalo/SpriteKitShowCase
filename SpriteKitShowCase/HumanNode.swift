//
//  HumanNode.swift
//  SpriteKitShowCase
//
//  Created by zhangjiahao.me on 2022/1/7.
//

import Foundation
import SpriteKit

class HumanNode: SKSpriteNode {
    
    func jump() {
        let jumpVector = CGVector(dx: 0, dy: -200)
        self.physicsBody?.applyImpulse(jumpVector)
    }
    
}
