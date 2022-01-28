//
//  AnimationWorld.swift
//  SpriteKitShowCase
//
//  Created by zhangjiahao.me on 2022/1/26.
//

import Foundation
import SpriteKit

enum AnimationState: String {
    case idle = "Idle"
    case walkForward = "WalkForward"
    case walkBackward = "WalkBackward"
    case preAttack = "PreAttack"
    case attack = "Attack"
    case zapped = "Zapped"
    case hit = "Hit"
    case inactive = "Inactive"
}

enum AnimationIdentifier: String {
    case humanRun = "human_run"
    case humanAttack = "human_attack"
}

/**
    Encapsulates all of the information needed to animate an entity and its shadow
    for a given animation state and facing direction.
*/
struct Animation {

    // MARK: Properties
    
    /// The animation state represented in this animation.
    let identifier: AnimationIdentifier
    
    /// The direction the entity is facing during this animation.
    let direction: Direction
    
    /// One or more `SKTexture`s to animate as a cycle for this animation.
    let textures: [SKTexture]

    /// Whether this action's `textures` array should be repeated forever when animated.
    let repeatTexturesForever: Bool

    /// The name of an optional action for this entity's body, loaded from an action file.
    let bodyActionName: String?

    /// The optional action for this entity's body, loaded from an action file.
    let bodyAction: SKAction?
}

class AnimationFactory {
    /// Returns the first texture in an atlas for a given `CompassDirection`.
    class func firstTexture(atlas atlas: SKTextureAtlas, imageIdentifier identifier: String) -> SKTexture {
        // Filter for this facing direction, and sort the resulting texture names alphabetically.
        let textureNames = atlas.textureNames.filter {
            $0.hasPrefix("\(identifier)_\(compassDirection.rawValue)_")
        }.sorted()
        
        // Find and return the first texture for this direction.
        return atlas.textureNamed(atlas.textureNames.first)
    }
    
    /// Creates a texture action from all textures in an atlas.
    class func actionForAllTexturesInAtlas(atlas: SKTextureAtlas) -> SKAction {
        // Sort the texture names alphabetically, and map them to an array of actual textures.
        let textures = atlas.textureNames.sorted().map {
            atlas.textureNamed($0)
        }

        // Create an appropriate action for these textures.
        if textures.count == 1 {
            return SKAction.setTexture(textures.first!)
        }
        else {
            let texturesAction = SKAction.animate(with: textures, timePerFrame: AnimationComponent.timePerFrame)
            return SKAction.repeatForever(texturesAction)
        }
    }
    
    class func animation(identifier identifier: AnimationIdentifier, bodyActionName: String? = nil, repeatTexturesForever: Bool = true) -> Animation {

        let bodyAction: SKAction?
        if let name = bodyActionName {
            bodyAction = SKAction(named: name)
        } else {
            bodyAction = nil
        }
            
        // Find all matching texture names, sorted alphabetically, and map them to an array of actual textures.
        let textures = atlas.textureNames.filter {
            $0.hasPrefix("\(identifier)_\(compassDirection.rawValue)_")
        }.sorted {
            playBackwards ? $0 > $1 : $0 < $1
        }.map {
            atlas.textureNamed($0)
        }
        
        // Create a new `Animation` for these settings.
        let animation = Animation(
            animationState: animationState,
            direction: compassDirection,
            textures: textures,
            frameOffset: 0,
            repeatTexturesForever: repeatTexturesForever,
            bodyActionName: bodyActionName,
            bodyAction: bodyAction
        )
    
        return animation
    }
}

struct AnimationWorld {
    
}
