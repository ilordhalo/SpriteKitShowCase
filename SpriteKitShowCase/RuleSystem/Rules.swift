//
//  Rules.swift
//  SpriteKitShowCase
//
//  Created by zhangjiahao.me on 2022/2/9.
//

import Foundation
import GameplayKit

enum Fact: String {
    case playerOnTheGround = "playerOnTheGround"
    case playerOnTheFloor = "playerOnTheFloor"
    
    case playerNear = "playerNear"
    case playerFar = "playerFar"
}

enum RuleState: String {
    case snapshot = "snapshot"
}

class BaseRule: GKRule {
    // MARK: Properties
    var snapshot: EntitySnapshot?
    
    func grade() -> Float { return 0.0 }
    
    let fact: Fact
    
    // MARK: Initializers
    
    init(fact: Fact) {
        self.fact = fact
        
        super.init()
        
        // Set the salience so that 'fuzzy' rules will evaluate first.
        salience = Int.max
    }
    
    // MARK: GPRule Overrides
    
    override func evaluatePredicate(in system: GKRuleSystem) -> Bool {
        snapshot = system.state[RuleState.snapshot.rawValue] as? EntitySnapshot
        
        if grade() >= 0.0 {
            return true
        }
        
        return false
    }
    
    override func performAction(in system: GKRuleSystem) {
        system.assertFact(fact.rawValue as NSObject, grade: grade())
    }
}
