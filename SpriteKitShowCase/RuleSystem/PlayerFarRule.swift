//
//  PlayerFarRule.swift
//  SpriteKitShowCase
//
//  Created by zhangjiahao.me on 2022/2/9.
//

import Foundation

class PlayerFarRule: BaseRule {
    override func grade() -> Float {
        guard let snapshot = snapshot, let distanceToPlayer = snapshot.distanceToPlayer else {
            return 0.0
        }
        return distanceToPlayer > 100 ? 1.0 : 0.0
    }
    
    // MARK: Initializers
    
    init() { super.init(fact: .playerFar) }
}
