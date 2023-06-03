//
//  FormationCalculator.swift
//  manexapp
//
//  Created by michaelyangqianlong on 1/5/23.
//

import Foundation

class FormationCalculator {
    // MARK: - PROPERTIES
    // roughly translates to 1.14 degrees tolerance
    let toleranceAngle: CGFloat = 0.02
    let toleranceDistance: CGFloat = 10.0
    var presetFormations: [[PolarPoint]] = []
    
    // MARK: - INIT
    init() {
        generatePresetFormations()
        
        print("preset fmn 1 \(presetFormations[0])")
    }
    
    // MARK: - HANDLERS
    func calculateCurrentFormation(for currentFmn: [PolarPoint]) -> FormationType? {
        var result: FormationType? = nil
        var matchAlreadyFound = false
        // compare current formation against all existing preset formations
        DispatchQueue.concurrentPerform(iterations: presetFormations.count) { (index) in
            let matched = compare(presetFmn: presetFormations[index], currentFmn: currentFmn)
            if matched && !matchAlreadyFound {
                matchAlreadyFound = true
                print("-----Match found! Formation \(index+1)-----")
                result = FormationType(rawValue: "\(index+1)")
            }
        }
        // if current formation is not one of the preset formations
        if result == nil {
            // do further checks for a line of bearing
            result = checkForLineOfBearing(points: currentFmn)
        }
        return result
    }

    // compare current formation against list of preset formations
    func compare(presetFmn: [PolarPoint], currentFmn: [PolarPoint]) -> Bool
    {
        // account for tolerance radius
        for i in 0..<currentFmn.count {
            // compare ith point of current formation against ith point of preset formation
            if currentFmn[i].a < presetFmn[i].a - toleranceAngle ||
                currentFmn[i].a > presetFmn[i].a + toleranceAngle ||
                currentFmn[i].r < presetFmn[i].r - toleranceDistance ||
                currentFmn[i].r > presetFmn[i].r + toleranceDistance {
                return false
            }
        }
        return true
    }
    
    func checkForLineOfBearing(points: [PolarPoint]) -> FormationType? {
        guard points.count > 1 else { return nil }
        print("-------Checking for LoB------")
        var isOnSameBearing = true
        let expectedBrg = points[1].a // points[0] is (0, 0) so it doesnt work
        for i in 1..<points.count {
            if points[i].a > expectedBrg + toleranceAngle || points[i].a < expectedBrg - toleranceAngle {
                isOnSameBearing = false
            }
        }
        if isOnSameBearing {
            print("ships on line of bearing (\(points[1].a / .pi * 180)).")
        }
        else {
            print("ships not on line of bearing.")
        }
        return isOnSameBearing ? FormationType.lineOfBearing : nil
    }
    
    // expects (x, y) for each point
    func createFormation(points: [(x: CGFloat, y: CGFloat)]) {
        var p: [PolarPoint] = []
        // the point of reference (origin) will be the first ship in formation
        let x = points[0].x
        let y = points[0].y

        // compute polar ranges and angles (in radians) from the first ship
        // This is assuming a base heading of 000
        for i in 0..<points.count {
            var r: CGFloat
            var a: CGFloat
            r = hypot(points[i].x - x, points[i].y - y)
            a = -atan2(points[i].y - y, points[i].x - x) + .pi / 2
            if a < 0 {
                a += .pi * 2
            }
            if i == 0 {
                r = 0
                a = 0
            }
            p.append(PolarPoint(r: r, a: a))
        }
        // Add formation to presets
        presetFormations.append(p)
    }
    
    // TODO: - add f7 to f12
    func generatePresetFormations() {
        // F1
        createFormation(points: [(0, 0), (0, -150), (0, -300), (0, -450), (0, -600), (0, -750), (0, -900), (0, -1050)])
        // F2
        createFormation(points: [(0, 0), (0, 150), (0, 300), (0, 450), (0, 600), (0, 750), (0, 900), (0, 1050)])
        // F3
        createFormation(points: [(0, 0), (150, 0), (300, 0), (450, 0), (600, 0), (750, 0), (900, 0), (1050, 0)])
        // F4
        createFormation(points: [(0, 0), (-150, 0), (-300, 0), (-450, 0), (-600, 0), (-750, 0), (-900, 0), (-1050, 0)])
        // F5
        createFormation(points: [(0, 0), (0, -150), (0, -300), (0, -450), (300, 0), (300, -150), (300, -300), (300, -450)])
        // F6
        createFormation(points: [(0, 0), (0, -150), (0, -300), (0, -450), (-300, 0), (-300, -150), (-300, -300), (-300, -450)])
    }
}

// MARK: - 
struct PolarPoint {
    // distance from origin
    let r: CGFloat
    // angle from origin POINT, which is the first ship in formation (relative to Y axis)
    // NOTE! - angle in radians is already made positive
    let a: CGFloat
}
