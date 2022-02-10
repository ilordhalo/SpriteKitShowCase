//
//  SKSpriteNode+Texture.swift
//  SpriteKitShowCase
//
//  Created by zhangjiahao.me on 2022/1/12.
//

import Foundation
import SpriteKit

extension SKSpriteNode {
    func setTexture(texture: SKTexture, resize: Bool) {
        self.run(SKAction.setTexture(texture, resize: true))
    }
}
