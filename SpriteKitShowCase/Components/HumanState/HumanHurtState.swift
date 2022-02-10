//
//  HumanHurtState.swift
//  SpriteKitShowCase
//
//  Created by 张家豪 on 2022/2/11.
//

import Foundation
import GameplayKit

class HumanHurtState: GKState {
    unowned var entity: GKEntity
    
    required init(entity: GKEntity) {
        self.entity = entity
    }
}
