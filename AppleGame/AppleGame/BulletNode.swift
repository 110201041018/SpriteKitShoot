//
//  BulletNode.swift
//  AppleGame
//
//  Created by jieliapp on 2017/10/25.
//  Copyright © 2017年 Zhuhia Jieli Technology. All rights reserved.
//

import UIKit
import SpriteKit



class BulletNode: SKNode {

    var thrust:CGVector = CGVector(dx:0,dy:0)
    
    override init() {
        super.init()
        
        let dot = SKLabelNode(fontNamed:"Courier")
        dot.fontColor = SKColor.green
        dot.fontSize = 40
        dot.text = "."
        addChild(dot)
        
        let body = SKPhysicsBody.init(circleOfRadius: 1)
        body.isDynamic = true
        body.categoryBitMask = PlayerMissileCategory
        body.contactTestBitMask = EnemyCategory
        body.collisionBitMask = EnemyCategory
        body.fieldBitMask = GravityFiledCategory
        body.mass = 0.01
        
        physicsBody = body
        name = "Bullet \(self)"
        
    }
    

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let dx = aDecoder.decodeFloat(forKey: "thrustX")
        let dy = aDecoder.decodeFloat(forKey: "thrustY")
        
        thrust = CGVector(dx:CGFloat(dx),dy:CGFloat(dy))
        
    }
    
    
    override func encode(with aCoder: NSCoder) {
        
        super.encode(with: aCoder)
        aCoder.encode(Float(thrust.dx), forKey: "thrustX")
        aCoder.encode(Float(thrust.dy), forKey: "thrustY")
    }
    
    
    func applyRecurringForce(){
        
        physicsBody!.applyForce(thrust)
        
    }

    
}

func createBullet(from start:CGPoint,toward destination:CGPoint) -> BulletNode {
    
    let bullet = BulletNode()
    bullet.position = start
    let movement = vectorBetweenPoints(p1: start, p2: destination)
    let magnitude = vectorLength(v: movement)
    let scaledMovement = vectorMultiply(v: movement, m: 1/magnitude)
    let thrustMagnitude = CGFloat(100.0)
    bullet.thrust = vectorMultiply(v: scaledMovement, m: thrustMagnitude)
    
    bullet.run(SKAction.playSoundFileNamed("shoot.wav", waitForCompletion: false))
    
    return bullet
    
}




