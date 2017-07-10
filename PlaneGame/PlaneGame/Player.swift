//
//  Player.swift
//  PlaneGame
//
//  Created by James Tyner on 6/12/17.
//  Copyright © 2017 James Tyner. All rights reserved.
//

import UIKit
import SpriteKit


class Player: SKSpriteNode {
    private var canFire = true
    private var invincible = false
    private var lives:Int = 3 {
        didSet {
            if(lives < 0){
                kill()
            }else{
                respawn()
            }
        }
    }
    init() {
        let texture = SKTexture(imageNamed: "player")
        super.init(texture: texture, color: .clear, size: texture.size())
        self.physicsBody = SKPhysicsBody(texture: self.texture!,size:self.size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = PhysicsCategories.Player
        self.physicsBody?.contactTestBitMask = PhysicsCategories.Enemy | PhysicsCategories.EnemyBullet
        self.physicsBody?.collisionBitMask = PhysicsCategories.EdgeBody
        self.physicsBody?.allowsRotation = false
        generateBullets()

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

    
    
    func die (){
        if(invincible == false){
            lives -= 1
        }
    }
    
    
    func kill(){
        let newScene = StartGameScene(size: self.scene!.size)
        newScene.scaleMode = self.scene!.scaleMode
        let doorsClose = SKTransition.doorsCloseVertical(withDuration: 2.0)
        self.scene!.view?.presentScene(newScene, transition: doorsClose)
    }
    
    func respawn(){
        invincible = true
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.4)
        let fadeInAction = SKAction.fadeIn(withDuration: 0.4)
        let fadeOutIn = SKAction.sequence([fadeOutAction,fadeInAction])
        let fadeOutInAction = SKAction.repeat(fadeOutIn, count: 5)
        let setInvicibleFalse = SKAction.run {
            self.invincible = false
        }
        run(SKAction.sequence([fadeOutInAction,setInvicibleFalse]))
        
    }
    
    func generateBullets(){
        
        let fireBulletAction = SKAction.run{ [weak self] in
            self?.fireBullet()
        }
        let waitToFire = SKAction.wait(forDuration: 0.8)
        let fireBulletSequence = SKAction.sequence([fireBulletAction,waitToFire])
        let fire = SKAction.repeatForever(fireBulletSequence)
        run(fire)
    }
    
    func fireBullet(){
            let bullet = SKSpriteNode(imageNamed: "bullet")
            bullet.position.x = self.position.x
            bullet.position.y = self.position.y + self.size.height/2
            bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
            bullet.physicsBody?.categoryBitMask = PhysicsCategories.PlayerBullet
            bullet.physicsBody?.allowsRotation = false
            scene?.addChild(bullet)
            let moveBulletAction = SKAction.move(to: CGPoint(x:self.position.x,y:(scene?.size.height)! + bullet.size.height), duration: 1.0)
            let removeBulletAction = SKAction.removeFromParent()
            bullet.run(SKAction.sequence([moveBulletAction,removeBulletAction]))
       
        
       }
}


