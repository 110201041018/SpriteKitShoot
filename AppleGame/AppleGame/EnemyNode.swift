//
//  EnemyNode.swift
//  AppleGame
//
//  Created by jieliapp on 2017/10/25.
//  Copyright © 2017年 Zhuhia Jieli Technology. All rights reserved.
//

import UIKit
import SpriteKit


class EnemyNode: SKNode {

    
    override init() {
        super.init()
        name = "Enmy \(self)"
        initNodeGraph()
        initPhysicsBody()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func initNodeGraph(){
        
        let topRow = SKLabelNode(fontNamed:"Courier-Bold")
        topRow.fontColor = SKColor.blue
        topRow.fontSize = 20
        topRow.text = "x x"
        topRow.position = CGPoint(x:0,y:15)
        addChild(topRow)
        
        
        let middleRow = SKLabelNode(fontNamed:"Courier-Bold")
        middleRow.fontColor = SKColor.red
        middleRow.fontSize = 21
        middleRow.text = "o"
        addChild(middleRow)
        
        let bottomRow = SKLabelNode(fontNamed:"Courier-Bold")
        bottomRow.fontColor = SKColor.green
        bottomRow.fontSize = 20
        bottomRow.position = CGPoint(x:0,y:-15)
        bottomRow.text = "v v"
        addChild(bottomRow)
        
    }
    
    
    /// 炮弹击中监测
    private func initPhysicsBody(){
        
        let body = SKPhysicsBody.init(rectangleOf: CGSize(width:40,height:40))
        body.affectedByGravity = false
        body.categoryBitMask = EnemyCategory
        body.contactTestBitMask = PlayerCategory | EnemyCategory
        body.mass = 0.2
        body.angularDamping = 0
        body.linearDamping = 0
        body.fieldBitMask = 0
        self.physicsBody = body
        
    }
    
    override func friendlyBumpFrom(node: SKNode) {
        physicsBody!.affectedByGravity = true
    }
    
    override func receiveAttacker(attacker: SKNode, contact: SKPhysicsContact) {
     
        physicsBody!.affectedByGravity = true
        let force = vectorMultiply(v: attacker.physicsBody!.velocity, m: contact.collisionImpulse)
        let myContact = scene!.convertPoint(toView: contact.contactPoint)
        
        physicsBody!.applyForce(force, at: myContact)
        
        let path = Bundle.main.path(forResource: "MissileExplosion", ofType: "sks")
        let explosion = NSKeyedUnarchiver.unarchiveObject(withFile: path!) as! SKEmitterNode
        explosion.numParticlesToEmit = 20
        explosion.position = contact.contactPoint
        scene!.addChild(explosion)
        
        run(SKAction.playSoundFileNamed("enemyHit.wav", waitForCompletion: false))
        
        
    }
    
    
    
}
