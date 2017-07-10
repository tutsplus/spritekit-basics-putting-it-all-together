//
//  Enemy.swift
//  PlaneGame
//
//  Created by James Tyner on 6/12/17.
//  Copyright © 2017 James Tyner. All rights reserved.
//

import UIKit
import SpriteKit

class Enemy: SKSpriteNode {

    init() {
        let texture = SKTexture(imageNamed: "enemy1")
        super.init(texture: texture, color: .clear, size: texture.size())
        self.name = "enemy"
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = PhysicsCategories.Enemy
        self.physicsBody?.contactTestBitMask = PhysicsCategories.Player | PhysicsCategories.PlayerBullet
        self.physicsBody?.allowsRotation = false
        move()
        generateBullets()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    func fireBullet(){
        let bullet = SKSpriteNode(imageNamed: "bullet")
        bullet.position.x = self.position.x
        bullet.position.y = self.position.y - bullet.size.height * 2
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        bullet.physicsBody?.categoryBitMask = PhysicsCategories.EnemyBullet
        bullet.physicsBody?.allowsRotation = false
        scene?.addChild(bullet)
        let moveBulletAction = SKAction.move(to: CGPoint(x:self.position.x,y: 0 - bullet.size.height), duration: 2.0)
        let removeBulletAction = SKAction.removeFromParent()
        bullet.run(SKAction.sequence([moveBulletAction,removeBulletAction])
        )
    }
    
    
    func move(){
        
        let moveEnemyAction = SKAction.moveTo(y: 0 - self.size.height, duration: 12.0)
        let removeEnemyAction = SKAction.removeFromParent()
        let moveEnemySequence = SKAction.sequence([moveEnemyAction, removeEnemyAction])
        run(moveEnemySequence)
    }
    
    func generateBullets(){
        
        let fireBulletAction = SKAction.run{ [weak self] in
            self?.fireBullet()
        }
        let waitToFire = SKAction.wait(forDuration: 1.5)
        let fireBulletSequence = SKAction.sequence([fireBulletAction,waitToFire])
        let fire = SKAction.repeatForever(fireBulletSequence)
        run(fire)
    }
}
