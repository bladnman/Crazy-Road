//
//  CollisionNode.swift
//  Crazy Road
//
//  Created by Maher, Matt on 2/23/21.
//

import SceneKit

class CollisionNode: SCNNode {

  let front: SCNNode
  let right: SCNNode
  let left: SCNNode
  
  override init() {
    front = SCNNode()
    right = SCNNode()
    left = SCNNode()
    super.init()
    createPhysicsBodies()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func createPhysicsBodies() {
    let boxGeometry = SCNBox(width: 0.25, height: 0.25, length: 0.25, chamferRadius: 0)
    boxGeometry.firstMaterial?.diffuse.contents = UIColor.init(white: 1.0, alpha: 0.2)
    
    let shape = SCNPhysicsShape(geometry: boxGeometry, options: [SCNPhysicsShape.Option.type: SCNPhysicsShape.ShapeType.boundingBox])
    
    front.geometry = boxGeometry
    right.geometry = boxGeometry
    left.geometry = boxGeometry
    
    front.physicsBody = SCNPhysicsBody(type: .kinematic, shape: shape)
    right.physicsBody = SCNPhysicsBody(type: .kinematic, shape: shape)
    left.physicsBody = SCNPhysicsBody(type: .kinematic, shape: shape)
    
    front.physicsBody?.categoryBitMask = PhysicsCategory.collisionTestFront
    right.physicsBody?.categoryBitMask = PhysicsCategory.collisionTestRight
    left.physicsBody?.categoryBitMask = PhysicsCategory.collisionTestLeft
    
    front.physicsBody?.contactTestBitMask = PhysicsCategory.vegitation
    right.physicsBody?.contactTestBitMask = PhysicsCategory.vegitation
    left.physicsBody?.contactTestBitMask = PhysicsCategory.vegitation
    
    front.position = SCNVector3(0, 0.5, -1)
    right.position = SCNVector3(1, 0.5, 0)
    left.position = SCNVector3(-1, 0.5, 0)
    
    addChildNode(front)
    addChildNode(right)
    addChildNode(left)
    
  }
  
}
