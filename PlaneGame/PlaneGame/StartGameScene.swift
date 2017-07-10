//
//  StartGameScene.swift
//  PlaneGame
//
//  Created by James Tyner on 6/12/17.
//  Copyright © 2017 James Tyner. All rights reserved.
//

import UIKit
import SpriteKit

class StartGameScene: SKScene {

    
    
    override func didMove(to view: SKView){
        scene?.backgroundColor = .blue
        let logo = SKSpriteNode(imageNamed: "bigplane")
        logo.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(logo)
        
        let newGameBtn = SKSpriteNode(imageNamed: "newgamebutton")
        newGameBtn.position = CGPoint(x: size.width/2, y: size.height/2 - 350)
        newGameBtn.name = "newgame"
        addChild(newGameBtn)
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)
        
        if(touchedNode.name == "newgame"){
            let newScene = GameScene(size: size)
            newScene.scaleMode = scaleMode
            view?.presentScene(newScene)
            
        }
    }}
