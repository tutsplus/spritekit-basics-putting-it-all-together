
//
//  GameScene.swift
//  PlaneGame
//
//  Created by James Tyner on 6/12/17.
//  Copyright © 2017 James Tyner. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let player = Player()
    let motionManager = CMMotionManager()
    var accelerationX: CGFloat = 0.0
    
    
    override func didMove(to view: SKView) {
        physicsWorld.gravity = CGVector(dx:0.0, dy:0.0)
        self.physicsWorld.contactDelegate = self
        scene?.backgroundColor = .blue
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsBody?.categoryBitMask = PhysicsCategories.EdgeBody
        player.position = CGPoint(x: size.width/2, y: player.size.height)
        addChild(player)
        setupAccelerometer()
        addEnemies()
        generateIslands()
        
       
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
  
    
    
    func addEnemies(){
        let generateEnemyAction = SKAction.run{ [weak self] in
            self?.generateEnemy()
        }
        let waitToGenerateEnemy = SKAction.wait(forDuration: 3.0)
        let generateEnemySequence = SKAction.sequence([generateEnemyAction,waitToGenerateEnemy])
        run(SKAction.repeatForever(generateEnemySequence))
    }
    
    func generateEnemy(){
        let enemy = Enemy()
        addChild(enemy)
        enemy.position = CGPoint(x: CGFloat(arc4random_uniform(UInt32(size.width - enemy.size.width))), y: size.height - enemy.size.height)
    }

    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if(contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask){
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }else{
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if((firstBody.categoryBitMask & PhysicsCategories.Player != 0) && (secondBody.categoryBitMask & PhysicsCategories.Enemy != 0)){
            player.die()
            secondBody.node?.removeFromParent()
            createExplosion(position: player.position)
            
        }
        
        
        if((firstBody.categoryBitMask & PhysicsCategories.Player != 0) && (secondBody.categoryBitMask & PhysicsCategories.EnemyBullet != 0)){
            player.die()
            secondBody.node?.removeFromParent()
            
        }
        if((firstBody.categoryBitMask & PhysicsCategories.Enemy != 0) && (secondBody.categoryBitMask & PhysicsCategories.PlayerBullet != 0)){
            if(firstBody.node != nil){
                createExplosion(position: (firstBody.node?.position)!)
            }
            firstBody.node?.removeFromParent()
            secondBody.node?.removeFromParent()
            
        }
    }
    
    func createExplosion(position: CGPoint){
        let explosion = SKSpriteNode(imageNamed: "explosion1")
        explosion.position = position
        addChild(explosion)
        var explosionTextures:[SKTexture] = []
        
        for i in 1...6 {
            explosionTextures.append(SKTexture(imageNamed: "explosion\(i)"))
        }
        
        let explosionAnimation = SKAction.animate(with: explosionTextures,
                                                  timePerFrame: 0.3)
        explosion.run(SKAction.sequence([explosionAnimation, SKAction.removeFromParent()]))
    
    
    }
    
    func  createIsland() {
        let island = SKSpriteNode(imageNamed: "island1")

        island.position = CGPoint(x: CGFloat(arc4random_uniform(UInt32(size.width - island.size.width))), y: size.height - island.size.height - 50)
        island.zPosition = -1
        addChild(island)
        let moveAction = SKAction.moveTo(y: 0 - island.size.height, duration: 15)
        island.run(SKAction.sequence([moveAction, SKAction.removeFromParent()]))
    }
    
    func generateIslands(){
        let generateIslandAction = SKAction.run { [weak self] in
            self?.createIsland()
        }
        let waitToGenerateIslandAction = SKAction.wait(forDuration: 9)
        run(SKAction.repeatForever(SKAction.sequence([generateIslandAction, waitToGenerateIslandAction])))
    }
    
    
    func setupAccelerometer(){
        motionManager.accelerometerUpdateInterval = 0.2
        motionManager.startAccelerometerUpdates(to: OperationQueue(), withHandler: { accelerometerData, error in
        guard let accelerometerData = accelerometerData else {
                return
        }
            let acceleration = accelerometerData.acceleration
            self.accelerationX = CGFloat(acceleration.x)
        })
    }
    
    override func didSimulatePhysics() {
        
        player.physicsBody?.velocity = CGVector(dx: accelerationX * 600, dy: 0)
    }}
