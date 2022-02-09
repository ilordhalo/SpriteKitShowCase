//
//  IntelligenceComponent.swift
//  SpriteKitShowCase
//
//  Created by zhangjiahao.me on 2022/1/12.
//

import Foundation
import GameplayKit

class IntelligenceComponent: GKComponent {
    let stateMachine: GKStateMachine
    
    var requestedState: GKState.Type?
    
    init(states: [GKState]) {
        stateMachine = GKStateMachine(states: states)
        
        stateMachine.enter(BadGuyPatrolState.self)
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
