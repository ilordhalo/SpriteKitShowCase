//
//  PhysicsWorld.swift
//  SpriteKitShowCase
//
//  Created by zhangjiahao.me on 2022/1/20.
//

import Foundation

struct PhysicsWorld {
    struct Entities {
        struct Human {
            static let bodySize: CGSize = CGSize(width: 19, height: 59)
            static let mass: CGFloat = 1
            static let jumpVector: CGVector = CGVector(dx: 0, dy: -2000)
        }
        struct Obstacle {
        }
    }
}
