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
            static let bodySize: CGSize = CGSize(width: 10, height: 30)
            static let mass: CGFloat = 1
            static let jumpVector: CGVector = CGVector(dx: 0, dy: 500)
            static let runVelocity: CGFloat = 100
            static let friction: CGFloat = 0.0
            static let restitution: CGFloat = 0
        }
        struct AbstractPhysics {
            static let restitution: CGFloat = 0
        }
    }
}
