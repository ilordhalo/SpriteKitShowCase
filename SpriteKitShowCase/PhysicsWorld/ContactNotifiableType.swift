//
//  ContactNotifiableType.swift
//  SpriteKitShowCase
//
//  Created by zhangjiahao.me on 2022/1/24.
//

import Foundation
import GameplayKit

protocol ContactNotifiableType {
    
    func contactWithEntityDidBegin(_ entity: GKEntity, contact: SKPhysicsContact)
    
    func contactWithEntityDidEnd(_ entity: GKEntity, contack: SKPhysicsContact)
}
