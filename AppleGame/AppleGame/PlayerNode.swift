//
//  PlayerNode.swift
//  AppleGame
//
//  Created by jieliapp on 2017/10/24.
//  Copyright © 2017年 Zhuhia Jieli Technology. All rights reserved.
//

import UIKit
import SpriteKit
import Foundation

class PlayerNode: SKNode {

    override init() {
        super.init()
        name = "Player \(self)"
        initNodeGraph()
        initPhysicsBody()
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func initNodeGraph(){
        
        let label = SKLabelNode(fontNamed:"Courier")
        label.fontColor = SKColor.white
        label.fontSize = 40
        label.text = "V"
        label.zRotation = CGFloat(Double.pi)
        label.name = "Label"
        self.addChild(label)
        
    }
    
    func moveToward(location:CGPoint) {
        removeAction(forKey: "movement")
        removeAction(forKey: "wobbling")
        
        let distance = pointDistance(p1: self.position,p2: location)
        let screenWidth = UIScreen.main.bounds.size.width
        let duration = TimeInterval(2 * distance/screenWidth)
        run(SKAction.move(to: location,duration:duration),withKey:"movement")
        
        
        let wobbleTime = 0.3
        let halfWobbleTime = wobbleTime/2
        //轻微抖动
        let wobbling = SKAction.sequence([SKAction.scaleX(to: 0.2, duration: halfWobbleTime),SKAction.scaleX(to: 1.0, duration: halfWobbleTime)])
        let wobbleCount = Int(duration/wobbleTime)
        //加入动作
        run(SKAction.repeat(wobbling, count: wobbleCount), withKey: "wobbling")
        
    }
    
    
    /// 炮弹打击监测
    private func initPhysicsBody(){
        let body = SKPhysicsBody.init(rectangleOf: CGSize(width:20,height:20))
        body.affectedByGravity = false
        body.categoryBitMask = PlayerCategory
        body.contactTestBitMask = EnemyCategory
        body.collisionBitMask = 0
        body.fieldBitMask = 0
        self.physicsBody = body
    }
    
 
    override func receiveAttacker(attacker: SKNode, contact: SKPhysicsContact) {
        
        let path = Bundle.main.path(forResource: "EnemyExposion", ofType: "sks")
        let explosion = NSKeyedUnarchiver.unarchiveObject(withFile: path!) as! SKEmitterNode
        explosion.numParticlesToEmit = 50
        explosion.position = contact.contactPoint
        scene!.addChild(explosion)
        
        run(SKAction.playSoundFileNamed("playerHit.wav", waitForCompletion: false))
    }
    
    
    
    
    
}
