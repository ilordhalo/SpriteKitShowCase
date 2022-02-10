//
//  AnimationComponent.swift
//  SpriteKitShowCase
//
//  Created by zhangjiahao.me on 2022/1/14.
//

import Foundation
import GameplayKit

class AnimationComponent: GKComponent {
    
    // MARK: Properties
    
    var times: Int = 0
    var requestedAnimationIdentifier: AnimationIdentifier? {
        didSet {
            let player = entity?.component(ofType: PlayerControlComponent.self)
            if player == nil {
                guard let requestedAnimationIdentifier = requestedAnimationIdentifier else {
                    return
                }

                print("\(times), \(requestedAnimationIdentifier)")
            }
        }
    }
    
    var requestedNoAnimation: Bool = false
    
    private var currentAnimationIdentifier: AnimationIdentifier?
    
    // MARK: Components Getter
    
    var renderComponent: RenderComponent {
        guard let renderComponent = entity?.component(ofType: RenderComponent.self) else {
            fatalError("A AnimationComponent's entity must have a RenderComponent")
        }
        return renderComponent
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        times+=1
        
        enterNextAnimationIfNeeded()
        
        requestedAnimationIdentifier = nil
        requestedNoAnimation = false
    }
    
    // MARK: Public
    
    func removeAnimation() {
        requestedNoAnimation = true
    }
    
    // MARK: Private
    
    private func enterNextAnimationIfNeeded() {
        if (requestedNoAnimation) {
            renderComponent.spriteNode.removeAction(forKey: AnimationActionKey.normal.rawValue)
            currentAnimationIdentifier = nil
            return
        }
        
        guard let requestedAnimationIdentifier = requestedAnimationIdentifier else {
            return
        }
        
        if currentAnimationIdentifier == requestedAnimationIdentifier {
            return
        }
        
        guard let animation = Game.shared.animationWorld.animations[requestedAnimationIdentifier.rawValue] else {
            fatalError("Should load animation first")
        }
        
        renderComponent.spriteNode.removeAction(forKey: AnimationActionKey.normal.rawValue)
        
        let action = action(animation: animation)
        if animation.repeatTexturesForever {
            renderComponent.spriteNode.run(SKAction.repeatForever(action), withKey: AnimationActionKey.normal.rawValue)
        } else {
            let completion = SKAction.run {
                self.removeAnimation()
            }
            let sequence = SKAction.sequence([action, completion])
            renderComponent.spriteNode.run(sequence, withKey: AnimationActionKey.normal.rawValue)
        }
        
        renderComponent.spriteNode.setTexture(texture: animation.textures.first!, resize: true)
        
        currentAnimationIdentifier = requestedAnimationIdentifier
    }
    
    private func action(animation: Animation) -> SKAction {
        let action = SKAction.animate(with: animation.textures, timePerFrame: animation.timePerFrame, resize: true, restore: false)
        return action
    }
}
