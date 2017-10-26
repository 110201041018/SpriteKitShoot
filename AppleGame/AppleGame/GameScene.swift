//
//  GameScene.swift
//  AppleGame
//
//  Created by jieliapp on 2017/10/24.
//  Copyright © 2017年 Zhuhia Jieli Technology. All rights reserved.
//

import SpriteKit
import GameplayKit
import UIKit

class GameScene: SKScene,SKPhysicsContactDelegate {
    
    private var levelNumber:UInt = 0
    private var playerLives:Int {
        
        didSet{
            
            let lives = childNode(withName: "livesLabel") as! SKLabelNode
            lives.text = "Lives:\(playerLives)"
            
        }
        
    }
    private var finished = false
    private let playerNode:PlayerNode = PlayerNode() //玩家
    private let enemies = SKNode()                   //敌人
    private let playerBullets = SKNode()             //炮弹
    private let forceFields = SKNode()               //重力场
    
    
    
    class func scene(size:CGSize ,levelNum:UInt) ->GameScene{

        return GameScene(size:size,levelNum:levelNum);
        
    }
    
    override convenience init(size: CGSize) {
        
        self.init(size: size, levelNum: 1)
        
    }
    

    private func spawnEnemies() {
        
        let count = UInt(log(double_t(levelNumber))) + levelNumber
        for _ in 0..<count  {
            
            let enemy = EnemyNode()
            let size = frame.size
            let x = arc4random_uniform(UInt32(size.width * 0.8)) + UInt32(size.width * 0.1)
            let y = arc4random_uniform(UInt32(size.height * 0.5)) + UInt32(size.height * 0.5)
            enemy.position = CGPoint(x:CGFloat(x) , y:CGFloat(y))
            enemies.addChild(enemy)
            
        }
        
    }
    
    init(size:CGSize,levelNum:UInt) {
        
        self.levelNumber = levelNum;
        self.playerLives = 5;
        super.init(size: size)
        backgroundColor = SKColor.white
        
        let lives = SKLabelNode(fontNamed:"Courier")
        lives.fontSize = 16
        lives.fontColor = SKColor.white
        lives.name = "livesLabel"
        lives.text = "Lives:\(playerLives)"
        lives.verticalAlignmentMode = .top
        lives.horizontalAlignmentMode = .right
        lives.position = CGPoint(x:frame.size.width,y:frame.size.height)
        addChild(lives)
        
        let level = SKLabelNode(fontNamed:"Courier")
        level.fontSize = 16
        level.fontColor = SKColor.white
        level.name = "levelLabel"
        level.text = "Level:\(levelNum)"
        level.verticalAlignmentMode = .top
        level.horizontalAlignmentMode = .left
        level.position = CGPoint(x:0,y:frame.height)
        addChild(level)
        
        playerNode.position = CGPoint(x:frame.midX,y:frame.height * 0.1)
        addChild(playerNode)

        addChild(enemies)
        spawnEnemies()
        addChild(playerBullets)
        
        addChild(forceFields)
//        createForceField()
        
        physicsWorld.gravity = CGVector(dx:0,dy:-1)
        physicsWorld.contactDelegate = self;
        
        self.backgroundColor = SKColor.black
        
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch:AnyObject in touches {
            let location = touch.location(in: self)
            
            if location.y < frame.height * 0.2 {
                let target = CGPoint(x:location.x,y:playerNode.position.y)
                playerNode.moveToward(location: target)
            }else{
                
                let bullet = createBullet(from: playerNode.position, toward: location)
                playerBullets.addChild(bullet)
            }
        }
    }
    
    
    /// 更新UI
    ///
    /// - Parameter currentTime: 时间
    override func update(_ currentTime: TimeInterval) {
        if finished{
            
            return
            
        }
        
        
        updateBullets()//更新炮弹
        updateEnemies()//更新敌人
        if !checkGameOver() { //优先检查游戏是否已经over了
            checkForNextLevel()//升级
        }
        
    }
    
    /// 更新了炮弹的位置
    private func updateBullets(){
        
        var bulletsToRemove:[BulletNode] = []
        for bullet in playerBullets.children as! [BulletNode] {
            
            if !frame.contains(bullet.position){
                
                bulletsToRemove.append(bullet)
                continue
            }
            
            bullet.applyRecurringForce()
            
        }
        
        playerBullets.removeChildren(in: bulletsToRemove)
    }
    
    
 /////////////////////****************///////////////////////
    
    /// 从内存中去掉被打飞了的敌人
    private func updateEnemies() {
        
        var enemiesToRemove:[EnemyNode] = []
        for node in enemies.children as! [EnemyNode] {
            if !frame.contains(node.position){
                
                enemiesToRemove.append(node)
                continue
            }
        }
        
        enemies.removeChildren(in: enemiesToRemove)
        
    }
    
    private func checkForNextLevel(){
        
        if enemies.children.isEmpty {
            goToNextLevel()
        }
        
    }
    
    
    ////////////////进入下一个关卡
    private func goToNextLevel(){
        
        finished = true
        let label = SKLabelNode(fontNamed:"Courier")
        label.text = "Level Up!"
        label.fontColor = SKColor.black
        label.fontSize = 32
        label.position = CGPoint(x:frame.size.width * 0.5,y:frame.size.height * 0.5)
        addChild(label)
        
        let nextLevel = GameScene(size:frame.size,levelNum:levelNumber+1)
        nextLevel.playerLives = playerLives
        self.view?.presentScene(nextLevel, transition: SKTransition.flipHorizontal(withDuration: 1.0))
        
    }
    
    
    
    ////////敌人攻击机制
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == contact.bodyB.categoryBitMask {
            let nodeA = contact.bodyA.node!
            let nodeB = contact.bodyB.node!
            
            nodeA.friendlyBumpFrom(node: nodeB)
            nodeB.friendlyBumpFrom(node: nodeA)
            
        }else{
            
            var attacker:SKNode
            var attackee:SKNode
            
            if contact.bodyA.categoryBitMask > contact.bodyB.categoryBitMask{
                
                //Body A 正在攻击 Body B
                attacker = contact.bodyA.node!
                attackee = contact.bodyB.node!
                
            }else{
                //Body B 正在攻击 Body A
                attacker = contact.bodyB.node!
                attackee = contact.bodyA.node!
                
            }
            
            if attackee is PlayerNode{
                
                playerLives = playerLives-1
            }
            
            //处理攻击者和被攻击者
            attackee.receiveAttacker(attacker: attacker, contact: contact)
            playerBullets.removeChildren(in: [attacker])
            enemies.removeChildren(in: [attacker])
            
            
        }
    }
    
    
    /////////重力场添加
    private func createForceField(){
        
        let fieldCount = Int(levelNumber) * 0
        let size = frame.size
        
        let sectionWidth = Int(size.width)/fieldCount
        for i in 0..<fieldCount {
            let x = CGFloat( UInt32(i*sectionWidth) + arc4random_uniform(UInt32(sectionWidth)))
            let y = CGFloat(arc4random_uniform(UInt32(size.height * 0.25)) + UInt32(size.height * 0.25))
            let gravityField = SKFieldNode.radialGravityField()
            gravityField.position = CGPoint(x:x,y:y)
            gravityField.categoryBitMask = GravityFiledCategory
            gravityField.strength = 4
            gravityField.falloff = 2
            gravityField.region = SKRegion.init(size: CGSize(width:size.width * 0.3,height:size.height * 0.1))
            forceFields.addChild(gravityField)
            
            
            
            let fieldLocationNode = SKLabelNode(fontNamed:"Courier")
            fieldLocationNode.fontSize = 25
            fieldLocationNode.fontColor = SKColor.red
            fieldLocationNode.name = "GravityField"
            fieldLocationNode.text = "V"
            fieldLocationNode.position = CGPoint(x:x,y:y)
            
            forceFields.addChild(fieldLocationNode)
            
        }
        
        
    }
    
    
    //////游戏结束
    private func triggerGameOver(){
        
        finished = true
        
        let path = Bundle.main.path(forResource: "EnemyExposion", ofType: "sks")
        let explosion = NSKeyedUnarchiver.unarchiveObject(withFile: path!) as! SKEmitterNode
        
        explosion.numParticlesToEmit = 200
        explosion.position = playerNode.position
        scene!.addChild(explosion)
        
        playerNode.removeFromParent()
        
        let transition = SKTransition.doorsOpenVertical(withDuration: 1)
        let gameOver = GameOverScene.init(size: frame.size)
        
        view!.presentScene(gameOver, transition: transition)
        
        run(SKAction.playSoundFileNamed("gameOver.wav", waitForCompletion: false))
    }
    
    private func checkGameOver()->Bool{
        
        if playerLives == 0{
            triggerGameOver()
            return true
        }else{
            return false
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        
        levelNumber = UInt(aDecoder.decodeInteger(forKey: "level"))
        playerLives = aDecoder.decodeInteger(forKey: "playerLives")
        super.init(coder: aDecoder)
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
    override func encode(with aCoder: NSCoder) {
        aCoder.encodeCInt(Int32(Int(levelNumber)), forKey: "level")
        aCoder.encodeCInt(Int32(playerLives), forKey: "playerLives")
    }
    
    
}
