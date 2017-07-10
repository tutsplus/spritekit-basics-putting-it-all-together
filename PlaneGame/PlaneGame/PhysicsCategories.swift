//
//  PhysicsCategories.swift
//  PlaneGame
//
//  Created by James Tyner on 6/21/17.
//  Copyright © 2017 James Tyner. All rights reserved.
//

import Foundation
struct PhysicsCategories{
    static let Player : UInt32 = 0x1 << 0
    static let Enemy: UInt32 = 0x1 << 1
    static let PlayerBullet: UInt32 = 0x1 << 2
    static let EnemyBullet: UInt32 = 0x1 << 3
    static let EdgeBody: UInt32 = 0x1 << 4
}
