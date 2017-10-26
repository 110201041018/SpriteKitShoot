//
//  Geometry.swift
//  AppleGame
//
//  Created by jieliapp on 2017/10/25.
//  Copyright © 2017年 Zhuhia Jieli Technology. All rights reserved.
//

import UIKit

//接收CGVector和CGfloat为参数
//返回一个新的CGVector，其中每个元素V都已经乘以m

func vectorMultiply(v:CGVector,m:CGFloat) -> CGVector {
    
    return CGVector(dx:v.dx*m,dy:v.dy*m)
    
}

//接收两个cgpoint为参数
//返回一个表示P1到P2距离的CGVector

func vectorBetweenPoints(p1:CGPoint,p2:CGPoint) -> CGVector {
    return CGVector(dx:p2.x - p1.x,dy:p2.y - p1.y)
}


/// 接收一个CGPoint为参数
/// 通过勾股定理算出向量的长度并返回一个CGFloat值
/// - Parameter v: CGPoint
/// - Returns: CGFloat
func vectorLength(v:CGVector) -> CGFloat {

    return CGFloat(sqrtf(powf(Float(v.dx), 2) + powf(Float(v.dy), 2)))
    
}


/// 计算两者之间的距离
///
/// - Parameters:
///   - p1: 第一点的Point
///   - p2: 第二个点的Point
/// - Returns: CGFloat
func pointDistance(p1:CGPoint,p2:CGPoint) -> CGFloat {
    
    return CGFloat(sqrtf(powf(Float(p2.x-p1.x), 2) + powf(Float(p2.y - p1.y), 2)))
    
}

class Geometry: NSObject {

    
    
    
}
