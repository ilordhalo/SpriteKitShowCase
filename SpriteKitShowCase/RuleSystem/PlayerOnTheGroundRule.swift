//
//  PlayerOnTheGroundRule.swift
//  SpriteKitShowCase
//
//  Created by zhangjiahao.me on 2022/2/9.
//

import Foundation

class PlayerOnTheGroundRule: BaseRule {
    override func grade() -> Float {
        guard let snapshot = snapshot else {
            return 0.0
        }
        return snapshot.playerVelocity.dy == 0 ? 1.0 : 0.0
    }
    
    // MARK: Initializers
    
    init() { super.init(fact: .playerOnTheGround) }
}
