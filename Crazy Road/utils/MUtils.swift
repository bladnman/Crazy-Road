//
//  MUtils.swift
//  Jumper
//
//  Created by Maher, Matt on 2/10/21.
//
import SceneKit

// MARK : RANDOMS
func roll(_ sided:Int) -> Int {
  return Int.random(in: 1...sided)
}
func flipIsHeads() -> Bool {
  return roll(2) == 2
}
/**
  Percentage chance out of 100
 
    example:
 
      chance(50)  // 50% likely to be true
      chance(10)  // 10% likely to be true
 */
func chance(_ percent: Int) -> Bool {
  let value = roll(100)
  return value <= max(0, min(100, percent))
}


// MARK : MATHS
let degreesPerRadians = Float(Double.pi/180)
let radiansPerDegrees = Float(180/Double.pi)

func toRadians(angle: Float) -> Float {
  return angle * degreesPerRadians
}
func toRadians(angle: CGFloat) -> CGFloat {
  return angle * CGFloat(degreesPerRadians)
}
func toDegrees(radians: Float) -> Float {
  return radians * radiansPerDegrees
}
func toDegrees(radians: CGFloat) -> CGFloat {
  return radians * CGFloat(radiansPerDegrees)
}
