//
//  BadGuyEntity.swift
//  SpriteKitShowCase
//
//  Created by zhangjiahao.me on 2022/1/12.
//

import Foundation
import GameplayKit

class BadGuyEntity: GKEntity, ContactNotifiableType, RulesComponentDelegate {
    
    var game: Game
    var node: SKSpriteNode
    
    // MARK: Initializers
    
    init(game: Game, node: SKSpriteNode) {
        self.game = game
        self.node = node
        
        super.init()
        
        setupComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupComponents() {
        let renderComponent = RenderComponent(spriteNode: node)
        addComponent(renderComponent)
        
        let animationComponent = AnimationComponent()
        addComponent(animationComponent)
        
        let physicsComponent = PhysicsComponent(physicsBody: setupPhysicsBody(), colliderType: .BadGuy)
        addComponent(physicsComponent)
        renderComponent.spriteNode.physicsBody = physicsComponent.physicsBody
        
        let directionComponent = DirectionComponent()
        addComponent(directionComponent)
        
        let intelligenceComponent = IntelligenceComponent(states: [BadGuyPatrolState(entity: self), BadGuyAttackState(entity: self)])
        addComponent(intelligenceComponent)
        
        let movementComponent = MovementComponent()
        addComponent(movementComponent)
        
        let attackComponent = AttackComponent()
        addComponent(attackComponent)
        
        let humanComponent = HumanComponent(states:setupHumanStates())
        addComponent(humanComponent)
        
        let rulesComponent = RulesComponent(rules: [PlayerNearRule(), PlayerFarRule(), PlayerOnTheFloorRule()])
        rulesComponent.delegate = self
        addComponent(rulesComponent)
    }
    
    private func setupHumanStates() -> [GKState] {
        let jumping = HumanJumpingState(entity: self)
        let running = HumanRunningState(entity: self)
        let standing = HumanStandingState(entity: self)
        let attacking = HumanAttackingState(entity: self)
        let death = HumanDeathState(entity: self)
        
        return [jumping, running, standing, attacking, death]
    }
    
    private func setupPhysicsBody() -> SKPhysicsBody {
        let physicsBody = SKPhysicsBody(rectangleOf: PhysicsWorld.Entities.Human.bodySize)
        physicsBody.mass = PhysicsWorld.Entities.Human.mass;
        physicsBody.isDynamic = true
        physicsBody.affectedByGravity = true
        physicsBody.allowsRotation = false
        physicsBody.restitution = PhysicsWorld.Entities.Human.restitution
        physicsBody.friction = PhysicsWorld.Entities.Human.friction
        return physicsBody
    }
    
    // MARK: Components Getter
    
    var renderComponent: RenderComponent {
        guard let renderComponent = self.component(ofType: RenderComponent.self) else {
            fatalError("BadGuyEntity must have an RenderComponent.")
        }
        return renderComponent
    }
    
    var humanComponent: HumanComponent {
        guard let humanComponent = self.component(ofType: HumanComponent.self) else {
            fatalError("BadGuyEntity must have an HumanComponent.")
        }
        return humanComponent
    }
    
    var physicsComponent: PhysicsComponent {
        guard let physicsComponent = self.component(ofType: PhysicsComponent.self) else {
            fatalError("BadGuyEntity must have an PhysicsComponent.")
        }
        return physicsComponent
    }
    
    var intelligenceComponent: IntelligenceComponent {
        guard let intelligenceComponent = self.component(ofType: IntelligenceComponent.self) else {
            fatalError("BadGuyEntity must have an IntelligenceComponent.")
        }
        return intelligenceComponent
    }
    
    var rulesComponent: RulesComponent {
        guard let rulesComponent = self.component(ofType: RulesComponent.self) else {
            fatalError("BadGuyEntity must have an RulesComponent.")
        }
        return rulesComponent
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        
    }
    
    // MARK: Public
    
    func huntPlayer() {
        guard let snapshot = rulesComponent.ruleSystem.state[RuleState.snapshot] as? EntitySnapshot else {
            return
        }
        
        if snapshot.playerPosition.x < node.position.x {
            
        }
    }
    
    // MARK: RuleComponentDelegate
    
    func rulesComponent(rulesComponent: RulesComponent, didFinishEvaluatingRuleSystem ruleSystem: GKRuleSystem) {
        let huntPlayer = ruleSystem.minimumGrade(forFacts: [Fact.playerNear.rawValue, Fact.playerOnTheFloor.rawValue]) > 0
        if huntPlayer {
            intelligenceComponent.stateMachine.enter(BadGuyAttackState.self)
        } else {
            intelligenceComponent.stateMachine.enter(BadGuyPatrolState.self)
        }
    }
    
    // MARK: ContactNotifiableType
    
    func contactWithEntityDidBegin(_ entity: GKEntity, contact: SKPhysicsContact) {
        if (contact.contactNormal.dy < 0 && entity.component(ofType: GroundComponent.self) != nil) {
            // hit the ground
        }
    }
    
    func contactWithEntityDidEnd(_ entity: GKEntity, contack: SKPhysicsContact) {
        
    }
    
}
