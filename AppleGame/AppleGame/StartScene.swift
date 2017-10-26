//
//  StartScene.swift
//  AppleGame
//
//  Created by jieliapp on 2017/10/26.
//  Copyright © 2017年 Zhuhia Jieli Technology. All rights reserved.
//

import UIKit
import SpriteKit

class StartScene: SKScene {

    override init(size:CGSize) {
        super.init(size:size)
        backgroundColor =  SKColor.green
        let topLable = SKLabelNode(fontNamed:"Courier")
        topLable.fontSize = 48
        topLable.fontColor = SKColor.black
        topLable.text = "Shooter"
        topLable.position = CGPoint(x:frame.size.width/2,y:frame.size.height*0.7)
        addChild(topLable)
        
        
        let bottomLable = SKLabelNode(fontNamed:"Courier")
        bottomLable.fontColor = SKColor.black
        bottomLable.fontSize = 20
        bottomLable.text = "Touch anywhere to start"
        bottomLable.position = CGPoint(x:frame.size.width/2,y:frame.size.height * 0.3)
        
        addChild(bottomLable)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        run(SKAction.playSoundFileNamed("gameStart.wav", waitForCompletion: false))
        
        let transition = SKTransition.doorway(withDuration: 1)
        let game = GameScene(size:frame.size)
        view!.presentScene(game, transition: transition)
        
        
    }
    
}
