//
//  GameScene.swift
//  SpriteKitShowCase
//
//  Created by zhangjiahao.me on 2022/1/7.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var game: Game {
        return Game.shared
    }
    
    lazy var componentSystems: [GKComponentSystem] = {
        return [playerControlComponentSystem, humanComponentSystem, directionComponentSystem, animationComponentSystem, attackComponentSystem]
    }()
    
    let humanComponentSystem = GKComponentSystem(componentClass: HumanComponent.self)
    let playerControlComponentSystem = GKComponentSystem(componentClass: PlayerControlComponent.self)
    let animationComponentSystem = GKComponentSystem(componentClass: AnimationComponent.self)
    let directionComponentSystem = GKComponentSystem(componentClass: DirectionComponent.self)
    let attackComponentSystem = GKComponentSystem(componentClass: AttackComponent.self)
    
    var entities = [GKEntity]()
    var player: PlayerEntity?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        game.gameScene = self
        game.animationWorld.loadAllAnimations { success in
        }
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        setupPhysicsBody()
        setupEntities()
        addComponentsToComponentSystems()
    }
    
    func setupPhysicsBody() {
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = ColliderType.Obstacle.rawValue
    }
    
    func setupEntities() {
        player = PlayerEntity(game: game)
        entities.append(player!)
        
        var index: Int = 0
        while let node = self.childNode(withName: "wall" + String(index)) as? SKSpriteNode {
            let entity = ObstacleEntity(game: game, node: node)
            entities.append(entity)
            index += 1
        }
        
        index = 0
        while let node = self.childNode(withName: "abstract_physics_" + String(index)) as? SKSpriteNode {
            let entity = AbstractPhysicsEntity(game: game, node: node)
            entities.append(entity)
            index += 1
        }
    }
    
    func addComponentsToComponentSystems() {
        for entity in entities {
            for componentSystem in componentSystems {
                componentSystem.addComponent(foundIn: entity)
            }
        }
    }
    
    override func mouseDown(with event: NSEvent) {
    }
    
    override func mouseDragged(with event: NSEvent) {
    }
    
    override func mouseUp(with event: NSEvent) {
    }
    
    override func keyDown(with event: NSEvent) {
        for case let component as PlayerControlComponent in playerControlComponentSystem.components {
            component.keyDown(with: event)
        }
    }
    
    override func keyUp(with event: NSEvent) {
        for case let component as PlayerControlComponent in playerControlComponentSystem.components {
            component.keyUp(with: event)
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        for componentSystem in componentSystems {
            componentSystem.update(deltaTime: currentTime)
        }
    }
    
    // MARK: SKPhysicsContactDelegate
    
    func didBegin(_ contact: SKPhysicsContact) {
        handleContact(contact: contact) { (ContactNotifiableType: ContactNotifiableType, otherEntity: GKEntity) in
            ContactNotifiableType.contactWithEntityDidBegin(otherEntity, contact: contact)
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        handleContact(contact: contact) { (ContactNotifiableType: ContactNotifiableType, otherEntity: GKEntity) in
            ContactNotifiableType.contactWithEntityDidEnd(otherEntity, contack: contact)
        }
    }
    
    private func handleContact(contact: SKPhysicsContact, contactCallback: (ContactNotifiableType, GKEntity) -> Void) {
        // Get the `ColliderType` for each contacted body.
        let colliderTypeA = ColliderType(rawValue: contact.bodyA.categoryBitMask)
        let colliderTypeB = ColliderType(rawValue: contact.bodyB.categoryBitMask)
        
        // Determine which `ColliderType` should be notified of the contact.
        let aWantsCallback = colliderTypeA.notifyOnContactWith(colliderTypeB)
        let bWantsCallback = colliderTypeB.notifyOnContactWith(colliderTypeA)
        
        // Make sure that at least one of the entities wants to handle this contact.
        assert(aWantsCallback || bWantsCallback, "Unhandled physics contact - A = \(colliderTypeA), B = \(colliderTypeB)")
        
        let entityA = contact.bodyA.node?.entity
        let entityB = contact.bodyB.node?.entity

        /*
            If `entityA` is a notifiable type and `colliderTypeA` specifies that it should be notified
            of contact with `colliderTypeB`, call the callback on `entityA`.
        */
        if let notifiableEntity = entityA as? ContactNotifiableType, let otherEntity = entityB, aWantsCallback {
            contactCallback(notifiableEntity, otherEntity)
        }
        
        /*
            If `entityB` is a notifiable type and `colliderTypeB` specifies that it should be notified
            of contact with `colliderTypeA`, call the callback on `entityB`.
        */
        if let notifiableEntity = entityB as? ContactNotifiableType, let otherEntity = entityA, bWantsCallback {
            contactCallback(notifiableEntity, otherEntity)
        }
    }
}
