//
//  AnimationWorld.swift
//  SpriteKitShowCase
//
//  Created by zhangjiahao.me on 2022/1/26.
//

import Foundation
import SpriteKit

enum AnimationIdentifier: String, CaseIterable {
    case humanRun = "human_run"
    case humanAttackHit = "human_attack_hit"
    case humanAttackHardHit = "human_attack_hardhit"
    case humanAttackKick = "human_attack_kick"
}

enum AnimationActionKey: String {
    case normal = "animation_action_key_normal"
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
    
    let timePerFrame: TimeInterval
}

class AnimationFactory {
    
    var atlasMap = [AnimationIdentifier: SKTextureAtlas]()
    
    func animation(identifier: AnimationIdentifier, repeatTexturesForever: Bool = true, timePerFrame: TimeInterval = 0.1) -> Animation {
        
        guard let atlas = atlasMap[identifier] else {
            fatalError("Should load atlas first")
        }
        
        // Find all matching texture names, sorted alphabetically, and map them to an array of actual textures.
        let textures = atlas.textureNames.sorted().map { name in
            return atlas.textureNamed(name)
        }
        
        // Create a new `Animation` for these settings.
        let animation = Animation(identifier: identifier, direction: Direction.right, textures: textures, repeatTexturesForever: repeatTexturesForever, timePerFrame: timePerFrame)
    
        return animation
    }
    
    func loadTextureAtlasIfNeeded(identifiers: [AnimationIdentifier], completion: @escaping (Bool) -> Void) {
        var preloadIdentifiers = [AnimationIdentifier]()
        for identifier in identifiers {
            if (atlasMap[identifier] == nil) {
                preloadIdentifiers.append(identifier)
            }
        }
        
        if (preloadIdentifiers.isEmpty) {
            completion(true)
            return
        }
        
        let names = preloadIdentifiers.map { identifier in
            return identifier.rawValue
        }
        
        SKTextureAtlas.preloadTextureAtlasesNamed(names) { error, atlases in
            if let error = error {
                fatalError("One or more texture atlases could not be found: \(error)")
            }
            
            for (index, atlas) in atlases.enumerated() {
                self.atlasMap[preloadIdentifiers[index]] = atlas
            }
            
            completion(true)
        }
    }
    
    func loadAllTextureAtlasIfNeeded(completion: @escaping (Bool) -> Void) {
        let identifiers = AnimationIdentifier.allCases
        loadTextureAtlasIfNeeded(identifiers: identifiers) { success in
            completion(success)
        }
    }
}

class AnimationWorld {
    
    // MARK: Properties
    
    var factory = AnimationFactory()
    var animations = [String: Animation]()
    
    func loadAllAnimations(completion: (Bool) -> Void) {
        factory.loadAllTextureAtlasIfNeeded { success in
            self.loadHumanAnimations()
        }
    }
    
    private func loadHumanAnimations() {
        
        let humanRun = factory.animation(identifier: AnimationIdentifier.humanRun, repeatTexturesForever: true, timePerFrame: 0.1)
        animations[AnimationIdentifier.humanRun.rawValue] = humanRun
        
        let humanAttackHit = factory.animation(identifier: AnimationIdentifier.humanAttackHit, repeatTexturesForever: false, timePerFrame: 0.1)
        animations[AnimationIdentifier.humanAttackHit.rawValue] = humanAttackHit
        
        let humanAttackHardHit = factory.animation(identifier: AnimationIdentifier.humanAttackHardHit, repeatTexturesForever: false, timePerFrame: 0.1)
        animations[AnimationIdentifier.humanAttackHardHit.rawValue] = humanAttackHardHit
        
        let humanAttackKick = factory.animation(identifier: AnimationIdentifier.humanAttackKick, repeatTexturesForever: false, timePerFrame: 0.1)
        animations[AnimationIdentifier.humanAttackKick.rawValue] = humanAttackKick
    }
}
