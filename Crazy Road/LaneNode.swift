//
//  LaneNode.swift
//  Crazy Road
//
//  Created by Maher, Matt on 2/22/21.
//

import SceneKit

enum LaneType {
  case grass, road
}

class TrafficNode: SCNNode {
  
  let type: Int
  let directionRight: Bool
  
  init(type: Int, directionRight: Bool) {
    self.type = type
    self.directionRight = directionRight
    super.init()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class LaneNode: SCNNode {
  let type: LaneType
  var trafficNode: TrafficNode?

  init(type: LaneType, width: CGFloat) {
    self.type = type
    super.init()

    switch type {
    case .grass:
      guard let texture = UIImage(named: "art.scnassets/grass.png") else {
        break
      }
      createLane(width: width, height: 0.4, image: texture)
      
    case .road:
      guard let texture = UIImage(named: "art.scnassets/asphalt.png") else {
        break
      }
      trafficNode = TrafficNode(type: roll(3)-1, directionRight: flipIsHeads())
      addChildNode(trafficNode!)
      createLane(width: width, height: 0.05, image: texture)
    }
  }
  
  func createLane(width: CGFloat, height: CGFloat, image: UIImage) {
    let laneGeometry = SCNBox(width: width, height: height, length: 1, chamferRadius: 0.0)
    laneGeometry.firstMaterial?.diffuse.contents = image
    laneGeometry.firstMaterial?.diffuse.wrapS = .repeat
    laneGeometry.firstMaterial?.diffuse.wrapT = .repeat
    laneGeometry.firstMaterial?.diffuse.contentsTransform = SCNMatrix4MakeScale(Float(width), 1, 1)
    let laneNode = SCNNode(geometry: laneGeometry)
    addChildNode(laneNode)
    
    addElement(width, laneNode)
  }
  
  func addElement(_ width: CGFloat, _ laneNode: SCNNode) {
    
    var carGap = 0
    
    for index in 0..<Int(width) {
      if type == .grass {
        if chance(20) {
          let vegitation = getVegitation()
          vegitation.position = SCNVector3(10 - Float(index), 0, 0)
          laneNode.addChildNode(vegitation)
        }
      } else if type == .road {
        carGap += 1
        if carGap > 3 {
          guard let trafficNode = trafficNode else {
            continue
          }
          if chance(25) {
            carGap = 0
            let vehicle = getVehicle(for: trafficNode.type)
            vehicle.position = SCNVector3(10 - Float(index), 0, 0)
            vehicle.eulerAngles = trafficNode.directionRight ? SCNVector3Zero : SCNVector3(x: 0, y: toRadians(angle: 180), z: 0)
            trafficNode.addChildNode(vehicle)
          }
        }
      }
    }
  }
  
  func getVegitation() -> SCNNode {
    return flipIsHeads() ? Models.tree.clone() : Models.hedge.clone()
  }
  
  func getVehicle(for type: Int) -> SCNNode {
    switch type {
    case 0:
      return Models.car.clone()
    case 1:
      return Models.blueTruck.clone()
    default:
      return Models.firetruck.clone()
    }
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
