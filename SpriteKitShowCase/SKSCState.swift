//
//  SKSCState.swift
//  SpriteKitShowCase
//
//  Created by zhangjiahao.me on 2022/1/12.
//

import Foundation
import GameplayKit

class SKSCState: GKState {
    var entity: GKEntity
    var game: Game
    
    init(game: Game, entity: GKEntity) {
        self.entity = entity
        self.game = game;
    }
}
