//
//  Untils.swift
//  SpriteKitShowCase
//
//  Created by zhangjiahao.me on 2022/1/24.
//

import Foundation

extension CGPoint {
    func atTopOfRect(_ rect: CGRect) -> Bool {
        if (rect.maxY == self.y && rect.minX <= self.x && rect.maxX >= self.x) {
            return true
        }
        return false
    }
    
    func atBottomOfRect(_ rect: CGRect) -> Bool {
        if (rect.minY == self.y && rect.minX <= self.x && rect.maxX >= self.x) {
            return true
        }
        return false
    }
}
