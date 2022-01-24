//
//  HumanStandingState.swift
//  SpriteKitShowCase
//
//  Created by zhangjiahao.me on 2022/1/12.
//

import Foundation
import GameplayKit

class HumanStandingState: GKState {
    unowned var entity: GKEntity
    
    required init(entity: GKEntity) {
        self.entity = entity
    }
    
    // MARK: Components Getter
    
    var humanComponent: HumanComponent {
        guard let humanComponent = entity.component(ofType: HumanComponent.self) else {
            fatalError("HumanJumpingState's entity must have an HumanComponent.")
        }
        return humanComponent
    }
    
    override func didEnter(from previousState: GKState?) {
        humanComponent.stand()
    }
}
