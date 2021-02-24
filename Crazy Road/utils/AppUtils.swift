//
//  AppUtils.swift
//  Crazy Road
//
//  Created by Maher, Matt on 2/22/21.
//
import SceneKit

struct Models {
  private static let treeScene = SCNScene(named: "art.scnassets/Tree.scn")!
  static let tree = treeScene.rootNode.childNode(withName: "tree", recursively: true)!
  
  private static let hedgeScene = SCNScene(named: "art.scnassets/Hedge.scn")!
  static let hedge = hedgeScene.rootNode.childNode(withName: "hedge", recursively: true)!
  
  private static let carScene = SCNScene(named: "art.scnassets/PurpleCar.scn")!
  static let car = carScene.rootNode.childNode(withName: "car", recursively: true)!
  
  private static let blueTruckScene = SCNScene(named: "art.scnassets/BlueTruck.scn")!
  static let blueTruck = blueTruckScene.rootNode.childNode(withName: "truck", recursively: true)!
  
  private static let firetruckScene = SCNScene(named: "art.scnassets/Firetruck.scn")!
  static let firetruck = firetruckScene.rootNode.childNode(withName: "truck", recursively: true)!
}

struct PhysicsCategory {
  static let chicken = 1
  static let vehicle = 2
  static let vegitation = 4
  // collision test helpers
  static let collisionTestFront = 8
  static let collisionTestRight = 16
  static let collisionTestLeft = 32
  static let collisionTestBack = 64
}
