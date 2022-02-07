//
//  Game.swift
//  SpriteKitShowCase
//
//  Created by zhangjiahao.me on 2022/1/12.
//

import Foundation
import SpriteKit

class Game {
    static let shared = Game()
    
    private init() {}
    
    var gameScene: SKScene?
    var playerNode: SKSpriteNode? {
        return gameScene?.childNode(withName: "player") as? SKSpriteNode
    }
    
    var animationWorld = AnimationWorld()
}
