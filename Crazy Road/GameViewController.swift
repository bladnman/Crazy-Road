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
  var lightNode = SCNNode()
  var playerNode = SCNNode()
  var mapNode = SCNNode()
  var lanes = [LaneNode]()
  var laneCount = 0
  
  var jumpForwardAction: SCNAction?
  var jumpRightAction: SCNAction?
  var jumpLeftAction: SCNAction?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupScene()
    setupFloor()
    setupCamera()
    setupLight()
    setupPlayer()
    setupActions()
    setupGestures()
  }
  
  func setupScene() {
    sceneView = (view as! SCNView)
    sceneView.delegate = self
    scene = SCNScene()
    
    sceneView.scene = scene
    
    scene.rootNode.addChildNode(mapNode)
    
    for _ in 0..<20 {
      createNewLane()
    }
  }
  
  func setupPlayer() {
    guard let playerScene = SCNScene(named: "art.scnassets/Chicken.scn") else {
      return
    }
    if let player = playerScene.rootNode.childNode(withName: "player", recursively: true) {
      playerNode = player
      playerNode.position = SCNVector3(0, 0.3, 0)
      scene.rootNode.addChildNode(playerNode)
    }
  }

  func setupFloor() {
    let floor = SCNFloor()
    floor.firstMaterial?.diffuse.contents = UIImage(named: "art.scnassets/darkgrass.png")
    floor.firstMaterial?.diffuse.wrapS = .repeat
    floor.firstMaterial?.diffuse.wrapT = .repeat
    floor.firstMaterial?.diffuse.contentsTransform = SCNMatrix4MakeScale(12.5, 12.5, 12.5)
    floor.reflectivity = 0.0
    
    let floorNode = SCNNode(geometry: floor)
    scene.rootNode.addChildNode(floorNode)
  }
  
  func setupCamera() {
    cameraNode.camera = SCNCamera()
    cameraNode.position = SCNVector3(0, 10, 0)
    cameraNode.eulerAngles = SCNVector3(x: -toRadians(angle: 60), y: toRadians(angle: 20), z: 0)
    scene.rootNode.addChildNode(cameraNode)
  }
  
  func setupLight() {
    let ambientNode = SCNNode()
    ambientNode.light = SCNLight()
    ambientNode.light?.type = .ambient
    
    let directionalNode = SCNNode()
    directionalNode.light = SCNLight()
    directionalNode.light?.type = .directional
    directionalNode.light?.castsShadow = true
    directionalNode.light?.shadowColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)
    directionalNode.position = SCNVector3(-5, 5, 0)
    directionalNode.eulerAngles = SCNVector3(0, -toRadians(angle: 90), -toRadians(angle: 45))
    
    lightNode.addChildNode(ambientNode)
    lightNode.addChildNode(directionalNode)
    lightNode.position = cameraNode.position
    scene.rootNode.addChildNode(lightNode)
  }
  
  func setupGestures() {
    let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
    swipeUp.direction = .up
    sceneView.addGestureRecognizer(swipeUp)
    
    let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
    swipeRight.direction = .right
    sceneView.addGestureRecognizer(swipeRight)
    
    let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
    swipeLeft.direction = .left
    sceneView.addGestureRecognizer(swipeLeft)
    
  }
  
  func setupActions() {
    let moveUpAction = SCNAction.moveBy(x: 0, y: 1, z: 0, duration: 0.1)
    let moveDownAction = SCNAction.moveBy(x: 0, y: -1, z: 0, duration: 0.1)
    moveUpAction.timingMode = .easeOut
    moveDownAction.timingMode = .easeIn
    let jumpAction = SCNAction.sequence([moveUpAction, moveDownAction])
    
    let moveForward = SCNAction.moveBy(x: 0, y: 0, z: -1.0, duration: 0.2)
    let moveRight = SCNAction.moveBy(x: 1.0, y: 0, z: 0, duration: 0.2)
    let moveLeft = SCNAction.moveBy(x: -1.0, y: 0, z: 0, duration: 0.2)
    
    let turnForwardAction = SCNAction.rotateTo(x: 0, y: toRadians(angle: 180), z: 0, duration: 0.2, usesShortestUnitArc: true)
    let turnRightAction = SCNAction.rotateTo(x: 0, y: toRadians(angle: 90), z: 0, duration: 0.2, usesShortestUnitArc: true)
    let turnLeftAction = SCNAction.rotateTo(x: 0, y: toRadians(angle: -90), z: 0, duration: 0.2, usesShortestUnitArc: true)
    
    jumpForwardAction = SCNAction.group([turnForwardAction, moveForward, jumpAction])
    jumpRightAction = SCNAction.group([turnRightAction, moveRight, jumpAction])
    jumpLeftAction = SCNAction.group([turnLeftAction, moveLeft, jumpAction])
  }
  
  func jumpForward() {
    if let action = jumpForwardAction {
      addLanes()
      playerNode.runAction(action)
    }
  }
  
  func updatePositions() {
    let diffX = (playerNode.position.x + 1 - cameraNode.position.x)
    let diffZ = (playerNode.position.z + 2 - cameraNode.position.z)
    cameraNode.position.x += diffX
    cameraNode.position.z += diffZ
    
    lightNode.position = cameraNode.position
  }
  
  func addLanes() {
    for _ in 0...1 {
      createNewLane()
    }
    removeUnusedLanes()
  }
  
  func removeUnusedLanes() {
    for laneNode in mapNode.childNodes {
      // lane is not in camera "view"
      if !sceneView.isNode(laneNode, insideFrustumOf: cameraNode) {
        // lane behind the player
        if laneNode.worldPosition.z > playerNode.worldPosition.z {
          laneNode.removeFromParentNode()
          lanes.removeFirst()
        }
      }
    }
  }
  
  func createNewLane() {
    let type = chance(65) ? LaneType.road : LaneType.grass
    let lane = LaneNode(type: type, width: 21)
    lane.position = SCNVector3(0, 0, 5 - Float(laneCount))
    laneCount += 1
    lanes.append(lane)
    mapNode.addChildNode(lane)
  }
}
extension GameViewController: SCNSceneRendererDelegate {
  func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
    updatePositions()
  }
}

extension GameViewController {
  
  @objc func handleSwipe(_ sender: UISwipeGestureRecognizer) {
    switch sender.direction {
    case .up:
      jumpForward()
    case .right:
      if playerNode.position.x < 10 {
        if let action = jumpRightAction {
          playerNode.runAction(action)
        }
      }
    case .left:
      if playerNode.position.x > -10 {
        if let action = jumpLeftAction {
          playerNode.runAction(action)
        }
      }
    default:
      break
    }
  }
}
