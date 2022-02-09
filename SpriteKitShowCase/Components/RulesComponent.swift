//
//  RulesComponent.swift
//  SpriteKitShowCase
//
//  Created by zhangjiahao.me on 2022/1/20.
//

import Foundation
import GameplayKit

protocol RulesComponentDelegate: AnyObject {
    // Called whenever the rules component finishes evaluating its rules.
    func rulesComponent(rulesComponent: RulesComponent, didFinishEvaluatingRuleSystem ruleSystem: GKRuleSystem)
}

class RulesComponent: GKComponent {
    // MARK: Properties
    
    weak var delegate: RulesComponentDelegate?
    
    var ruleSystem: GKRuleSystem
    
    // MARK: Initializers
    
    init(rules: [GKRule]) {
        ruleSystem = GKRuleSystem()
        ruleSystem.add(rules)
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: GKComponent Life Cycle
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        guard let entity = entity, let scene = entity.component(ofType: RenderComponent.self)?.spriteNode.scene as? GameScene else {
            return
        }
        
        let entitySnapshot = scene.entitySnapshotForEntity(entity: entity)
        
        ruleSystem.reset()
        ruleSystem.state[RuleState.snapshot.rawValue] = entitySnapshot
        ruleSystem.evaluate()
        
        delegate?.rulesComponent(rulesComponent: self, didFinishEvaluatingRuleSystem: ruleSystem)
    }
}
