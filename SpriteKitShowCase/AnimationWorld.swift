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

/**
    Encapsulates all of the information needed to animate an entity and its shadow
    for a given animation state and facing direction.
*/
struct Animation {

    // MARK: Properties
    
    /// The animation state represented in this animation.
    let animationState: AnimationState
    
    /// The direction the entity is facing during this animation.
    let compassDirection: Direction
    
    /// One or more `SKTexture`s to animate as a cycle for this animation.
    let textures: [SKTexture]
    
    /**
        The offset into the `textures` array to use as the first frame of the animation.
        Defaults to zero, but will be updated if a copy of this animation decides to offset
        the starting frame to continue smoothly from the end of a previous animation.
    */
    var frameOffset = 0
    
    /**
        An array of textures that runs from the animation's `frameOffset` to its end,
        followed by the textures from its start to just before the `frameOffset`.
    */
    var offsetTextures: [SKTexture] {
        if frameOffset == 0 {
            return textures
        }
        let offsetToEnd = Array(textures[frameOffset..<textures.count])
        let startToBeforeOffset = textures[0..<frameOffset]
        return offsetToEnd + startToBeforeOffset
    }

    /// Whether this action's `textures` array should be repeated forever when animated.
    let repeatTexturesForever: Bool

    /// The name of an optional action for this entity's body, loaded from an action file.
    let bodyActionName: String?

    /// The optional action for this entity's body, loaded from an action file.
    let bodyAction: SKAction?

    /// The name of an optional action for this entity's shadow, loaded from an action file.
    let shadowActionName: String?

    /// The optional action for this entity's shadow, loaded from an action file.
    let shadowAction: SKAction?
}

class AnimationWorld {
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
    
    /// Creates an `Animation` from textures in an atlas and actions loaded from file.
    class func animationsFromAtlas(atlas: SKTextureAtlas, withImageIdentifier identifier: String, forAnimationState animationState: AnimationState, bodyActionName: String? = nil, shadowActionName: String? = nil, repeatTexturesForever: Bool = true, playBackwards: Bool = false) -> [CompassDirection: Animation] {
        // Load a body action from an actions file if requested.
        let bodyAction: SKAction?
        if let name = bodyActionName {
            bodyAction = SKAction(named: name)
        }
        else {
            bodyAction = nil
        }

        // Load a shadow action from an actions file if requested.
        let shadowAction: SKAction?
        if let name = shadowActionName {
            shadowAction = SKAction(named: name)
        }
        else {
            shadowAction = nil
        }
        
        /// A dictionary of animations with an entry for each compass direction.
        var animations = [CompassDirection: Animation]()
        
        for compassDirection in CompassDirection.allDirections {
            
            // Find all matching texture names, sorted alphabetically, and map them to an array of actual textures.
            let textures = atlas.textureNames.filter {
                $0.hasPrefix("\(identifier)_\(compassDirection.rawValue)_")
            }.sorted {
                playBackwards ? $0 > $1 : $0 < $1
            }.map {
                atlas.textureNamed($0)
            }
            
            // Create a new `Animation` for these settings.
            animations[compassDirection] = Animation(
                animationState: animationState,
                compassDirection: compassDirection,
                textures: textures,
                frameOffset: 0,
                repeatTexturesForever: repeatTexturesForever,
                bodyActionName: bodyActionName,
                bodyAction: bodyAction,
                shadowActionName: shadowActionName,
                shadowAction: shadowAction
            )
            
        }
        
        return animations
    }
}
