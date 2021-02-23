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
}
