//
//  PlayerEntity.swift
//  SpriteKitShowCase
//
//  Created by zhangjiahao.me on 2022/1/12.
//

import Foundation
import GameplayKit

class PlayerEntity: GKEntity, ContactNotifiableType {
    
    var game: Game
    
    // MARK: Initializers
    
    init(game: Game) {
        self.game = game
        
        super.init()
        
        setupComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupComponents() {
        
        guard let playerNode = game.playerNode else {
            fatalError("PlayerEntity must have a playerNode from Game")
        }
        let renderComponent = RenderComponent(spriteNode: playerNode)
        addComponent(renderComponent)
        
        let animationComponent = AnimationComponent()
        addComponent(animationComponent)
        
        let physicsComponent = PhysicsComponent(physicsBody: setupPhysicsBody(), colliderType: .Player)
        addComponent(physicsComponent)
        renderComponent.spriteNode.physicsBody = physicsComponent.physicsBody
        
        let directionComponent = DirectionComponent()
        addComponent(directionComponent)
        
        let playerControlComponent = PlayerControlComponent()
        addComponent(playerControlComponent)
        
        let movementComponent = MovementComponent()
        addComponent(movementComponent)
        
        let attackComponent = AttackComponent()
        addComponent(attackComponent)
        
        let humanComponent = HumanComponent(states:setupHumanStates())
        addComponent(humanComponent)
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
            fatalError("PlayerEntity must have an RenderComponent.")
        }
        return renderComponent
    }
    
    var humanComponent: HumanComponent {
        guard let humanComponent = self.component(ofType: HumanComponent.self) else {
            fatalError("PlayerEntity must have an HumanComponent.")
        }
        return humanComponent
    }
    
    var physicsComponent: PhysicsComponent {
        guard let physicsComponent = self.component(ofType: PhysicsComponent.self) else {
            fatalError("PlayerEntity must have an PhysicsComponent.")
        }
        return physicsComponent
    }
    
    // MARK: Public
    
    // MARK: ContactNotifiableType
    
    func contactWithEntityDidBegin(_ entity: GKEntity, contact: SKPhysicsContact) {
        if (contact.contactNormal.dy < 0 && entity.component(ofType: GroundComponent.self) != nil) {
            // hit the ground
        }
    }
    
    func contactWithEntityDidEnd(_ entity: GKEntity, contack: SKPhysicsContact) {
        
    }
    
}
