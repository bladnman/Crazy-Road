//
//  GameViewController.swift
//  Crazy Road
//
//  Created by Matt Maher on 2/21/21.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {

  var scene: SCNScene!
  var sceneView: SCNView!
  var cameraNode = SCNNode()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupScene()
    setupFloor()
    setupCamera()
  }
  
  func setupScene() {
    sceneView = (view as! SCNView)
    scene = SCNScene()
    
    sceneView.scene = scene
  }

  func setupFloor() {
    let floor = SCNFloor()
    floor.firstMaterial?.diffuse.contents = UIColor.green
    floor.reflectivity = 0.0
    
    let floorNode = SCNNode(geometry: floor)
    scene.rootNode.addChildNode(floorNode)
  }
  
  func setupCamera() {
    cameraNode.camera = SCNCamera()
    cameraNode.position = SCNVector3(0, 10, 0)
    cameraNode.eulerAngles = SCNVector3(x: -.pi/2, y: 0, z: 0)
    scene.rootNode.addChildNode(cameraNode)
  }
}
