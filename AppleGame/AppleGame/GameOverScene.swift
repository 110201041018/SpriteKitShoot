//
//  GameOverScene.swift
//  AppleGame
//
//  Created by jieliapp on 2017/10/25.
//  Copyright © 2017年 Zhuhia Jieli Technology. All rights reserved.
//

import UIKit
import SpriteKit

class GameOverScene: SKScene {
    
    
    override init(size:CGSize){
        super.init(size:size)
        backgroundColor = SKColor.purple
        let text = SKLabelNode(fontNamed:"Courier")
        text.text = "Game Over"
        text.fontColor = SKColor.white
        text.fontSize = 50
        text.position = CGPoint(x:frame.size.width/2,y:frame.size.height/2)
        addChild(text)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
    
        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
         
            let transition = SKTransition.flipVertical(withDuration: 1)
            let start = StartScene(size:self.frame.size)
            view.presentScene(start, transition: transition)
            
        }
    }
    
}
