//
//  AttackComponent.swift
//  SpriteKitShowCase
//
//  Created by zhangjiahao.me on 2022/1/20.
//

import Foundation
import GameplayKit

class AttackComponent: GKComponent {
    
    var renderComponent: RenderComponent {
        guard let renderComponent = entity?.component(ofType: RenderComponent.self) else {
            fatalError("A HumanComponent's entity must have a RenderComponent")
        }
        return renderComponent
    }
    
    
}
