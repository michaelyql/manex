//
//  GameSceneHelper.swift
//  manexapp
//
//  Created by michaelyangqianlong on 9/4/23.
//

import Foundation
import SpriteKit

extension GameScene {
    
    // MARK: - CAMERA
    func setupCamera() {
        let cameraNode = SKCameraNode()
        self.camera = cameraNode
        camera?.setScale(2.0)
        camera?.position = CGPoint(x: 0, y: 0)
        addChild(cameraNode)
        
        // Gesture recognizer for moving the camera
        guard let view = self.view else { return }
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        view.addGestureRecognizer(panGesture)
        
        // Gesture recognizer for zooming in and out
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        view.addGestureRecognizer(pinchGesture)
    }
    
    @objc func handleSwipe(_ sender: UIPanGestureRecognizer) {
        guard let camera = self.camera else {
            return
        }
        if sender.state == .began {
            previousCameraPoint = camera.position
        }
        let translation = sender.translation(in: self.view)
        let newPos = CGPoint(
            x: previousCameraPoint.x + translation.x * -1,
            y: previousCameraPoint.y + translation.y
        )
        camera.position = newPos
    }
    
    @objc func handlePinch(_ sender: UIPinchGestureRecognizer) {
        guard let camera = self.camera else {
            return
        }
        if sender.state == .began {
            previousCameraScale = camera.xScale
            sender.scale = previousCameraScale
        }
        if sender.state == .changed {
            let change = sender.scale - previousCameraScale
            let newScale = max(min((previousCameraScale - change), maxCameraScale), minCameraScale)
            camera.setScale(newScale)
        }
    }
    
    func setupDegreeWheel() {
        guard let view = self.view, let camera = self.camera else { return }
        
        // create degree wheel sprite
        camera.addChild(self.degreeWheel)
        degreeWheel.position = CGPoint(x: camera.frame.midX, y: camera.frame.midY)
        degreeWheel.setScale(0.35)
        degreeWheel.blendMode = .multiply
        degreeWheel.alpha = 0.0
        
        // add long gesture recognizer to show degree wheel
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPressGesture.minimumPressDuration = 0.5
        view.addGestureRecognizer(longPressGesture)
        
        // degree wheel arrow
        camera.addChild(degreeWheelArrow)
        degreeWheelArrow.anchorPoint = CGPoint(x: 0.5, y: 0)
        degreeWheelArrow.alpha = 0.0
        
        camera.addChild(degreeWheelAngleLabel)
        degreeWheelAngleLabel.constraints = [
            SKConstraint.distance(SKRange(constantValue: 0), to: CGPoint(x: camera.frame.midX, y: camera.frame.midY - 50))
        ]
        degreeWheelAngleLabel.alpha = 0.0
    }
    
    // TODO: - If the ships have a current heading they are pointing to, any rotation needs to account for the offset so the ships can maintain their relative heading
    @objc func handleLongPress(_ sender: UILongPressGestureRecognizer) {
        guard let view = self.view else { return }
        let point = sender.location(in: self.view)
        
        let deltaX = point.x - view.frame.midX
        let deltaY = view.frame.midY - point.y
        
        // if touch began, make degree wheel appear
        if sender.state == .began {
            degreeWheel.alpha = 1.0
            degreeWheelArrow.alpha = 1.0
            degreeWheelAngleLabel.alpha = 1.0
            prevWheelAngle = -warshipsArray[0].zRotation
            prevShipHeading = -warshipsArray[0].zRotation / .pi * 180
        }
        
        // while finger is held down and is moving, rotate the arrow and update ship's zRotation
        if sender.state == .changed {
            
            // rotationInRad represents the true direction that the arrow is pointing in
            var rotationInRad: CGFloat = 0
            // avoid divide by zero error
            if (deltaY) == 0 {
                if deltaX > 0 {
                    rotationInRad = .pi / 2
                }
                else if deltaX < 0 {
                    rotationInRad = .pi * 3/2
                }
            }
            else {
                // top right quadrant: angle
                // Angle is measured relative to y-Axis
                rotationInRad = atan(abs(deltaX/deltaY))
                
                // bottom right quadrant: 180º - angle
                if deltaY < 0 && deltaX > 0 {
                    rotationInRad = .pi - rotationInRad
                }
                
                // bottom left quadrant: 180º + angle
                else if deltaY < 0 && deltaX < 0 {
                    rotationInRad = .pi + rotationInRad
                }
                
                // top left quadrant: 270º + angle
                else if deltaY > 0 && deltaX < 0 {
                    rotationInRad = .pi * 2 - rotationInRad
                }
            }
            
            // convert radians to degrees, clamp the rotation to a step of 1º, then convert back to radians
            rotationInRad = round(rotationInRad / .pi * 180) * .pi / 180
            
            degreeWheelArrow.zRotation = -rotationInRad
            
            // turning individual ships
            if isTurnButtonEnabled == true {
                for ship in warshipsArray {
                    ship.zRotation = -rotationInRad
                }
                degreeWheelAngleLabel.text = "\(round(rotationInRad / .pi * 180))"
            }
            
            // turning the formation as a whole
            else if isTurnButtonEnabled == false {

                // e.g. if previous angle was 45º and user drags to 48º, leads to +3º change
                let angleChange = prevWheelAngle - rotationInRad
                
                // calculating the centroid
                var cenX = CGFloat.zero
                var cenY = CGFloat.zero
                for ship in warshipsArray {
                    cenX += ship.position.x
                    cenY += ship.position.y
                }
                cenX = cenX / CGFloat(warshipsArray.count)
                cenY = cenY / CGFloat(warshipsArray.count)
                
                for ship in warshipsArray {
                    let translatedPos = CGPoint(x: ship.position.x - cenX,
                                                y: ship.position.y - cenY)
                    let newX = translatedPos.x * cos(angleChange) - translatedPos.y * sin(angleChange) + cenX
                    let newY = translatedPos.x * sin(angleChange) + translatedPos.y * cos(angleChange) + cenY
                    ship.position = CGPoint(x: newX, y: newY)
                    
                    // TODO: - account for ship's current rotation (?)
                    ship.zRotation = -rotationInRad
                    
                }
                
                degreeWheelAngleLabel.text = "\(round(rotationInRad / .pi * 180))"
                headingLabel.text = "Heading: \(round(rotationInRad / .pi * 180))"
            }
            
            prevWheelAngle = rotationInRad
        }
        
        // when user lifts up their finger, make degree wheel disappear
        if sender.state == .ended {
            degreeWheel.alpha = 0.0
            degreeWheelArrow.alpha = 0.0
            degreeWheelAngleLabel.alpha = 0.0
        }
    }
    
    func setupInfoView() {
        guard let camera = self.camera else { return }
        for label in [headingLabel, formationLabel, numberOfShipsLabel] {
            camera.addChild(label)
            label.fontName = "Arial Rounded MT Bold"
            label.fontSize = 18
            label.fontColor = .white
            label.horizontalAlignmentMode = .left
        }
        headingLabel.position = CGPoint(x: -175, y: 300)
        formationLabel.position = CGPoint(x: -175, y: 275)
        numberOfShipsLabel.position = CGPoint(x: -175, y: 250)
        
        headingLabel.alpha = 0.0
        formationLabel.alpha = 0.0
        numberOfShipsLabel.alpha = 0.0
    }
}
