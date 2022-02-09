//
//  Math.swift
//  SpriteKitShowCase
//
//  Created by zhangjiahao.me on 2022/2/9.
//

import Foundation

func distance(pointA: CGPoint, pointB: CGPoint) -> CGFloat {
    return sqrt(pow(pointA.x - pointB.x, 2) + pow(pointA.y - pointB.y, 2))
}
