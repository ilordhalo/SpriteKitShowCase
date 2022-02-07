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
//        self.texture = texture
        self.run(SKAction.setTexture(texture, resize: true))
//        if (resize) {
//            self.size = CGSize(width: texture.size().width * 2, height: texture.size().height * 2)
//        }
    }
}
