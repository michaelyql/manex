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
    static let toleranceAngle: CGFloat = 0.02
    static let toleranceDistance: CGFloat = 10.0
    static let presetFormations: [[PolarPoint]] = generatePresetFormations()
    
    // MARK: - INIT
    init() {}
    
    // MARK: - HANDLERS
    static func calculateCurrentFormation(for currentFmn: [PolarPoint]) -> FormationType {
        var result: FormationType = .none
        var matchAlreadyFound = false
        // compare current formation against all existing preset formations
        print("Checking for preset formations")
        DispatchQueue.concurrentPerform(iterations: presetFormations.count) { (index) in
            let matched = compare(presetFmn: presetFormations[index], currentFmn: currentFmn)
            if matched && !matchAlreadyFound {
                matchAlreadyFound = true
                result = FormationType(index: index+1) 
                print("Match found: \(result)")
            }
        }
        // if current formation is not one of the preset formations
        if result == .none {
            // do further checks for a line of bearing
            print("No match found.")
            result = checkForLineOfBearing(points: currentFmn)
        }
        return result
    }

    // compare current formation against list of preset formations
    static func compare(presetFmn: [PolarPoint], currentFmn: [PolarPoint]) -> Bool
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
    
    // TODO: Since angle is always normalized w.r.t. 000, we need to convert the angle back to true bearing instead of relative.
    // Otherwise, a LOB 150 when ships are all facing 140 would become a LOB 010 which is wrong.
    // We can do this by adding back the ship's current heading.
    static func checkForLineOfBearing(points: [PolarPoint]) -> FormationType {
        guard points.count > 1 else { return .none }
        print("Checking for Line of Bearing.")
        var isOnSameBearing = true
        let expectedBrg = points[1].a // points[0] is (0, 0) so it doesnt work
        for i in 1..<points.count {
            if points[i].a > expectedBrg + toleranceAngle || points[i].a < expectedBrg - toleranceAngle {
                isOnSameBearing = false
                break
            }
        }
        if isOnSameBearing {
            print("Ships on line of bearing \(points[1].a / .pi * 180).")
        }
        else {
            print("No line of bearing.")
        }
        return isOnSameBearing ? .lineOfBearing(points[1].a / .pi * 180) : .none
    }
    
    // expects (x, y) for each point
    static func createFormation(points: [(x: CGFloat, y: CGFloat)]) -> [PolarPoint] {
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
        return p
    }
    
    // TODO: - add f7 to f12
    // Currently this is not working as intended because each of the 12 comparisons
    // are happening concurrently. F1 and F6 have the same first 4 ship coordinates
    // so it becomes a race to see which thread finishes comparing first.
    // In this case the functions defined specifically for F1 will not be executed,
    // and the formation will be treated as F6 instead, which is not intended. 
    static func generatePresetFormations() -> [[PolarPoint]] {
        var f: [[PolarPoint]] = []
        
        let f1 = createFormation(points: [(0, 0), (0, -150), (0, -300), (0, -450), (0, -600), (0, -750), (0, -900), (0, -1050)])
        
        let f2 = createFormation(points: [(0, 0), (0, 150), (0, 300), (0, 450), (0, 600), (0, 750), (0, 900), (0, 1050)])
        
        let f3 = createFormation(points: [(0, 0), (150, 0), (300, 0), (450, 0), (600, 0), (750, 0), (900, 0), (1050, 0)])
        
        let f4 = createFormation(points: [(0, 0), (-150, 0), (-300, 0), (-450, 0), (-600, 0), (-750, 0), (-900, 0), (-1050, 0)])
        
        let f5 = createFormation(points: [(0, 0), (0, -150), (0, -300), (0, -450), (300, 0), (300, -150), (300, -300), (300, -450)])
        
        let f6 = createFormation(points: [(0, 0), (0, -150), (0, -300), (0, -450), (-300, 0), (-300, -150), (-300, -300), (-300, -450)])
        
        let f7 = createFormation(points: [(0, 0), (0, -150), (300, 0), (300, -150), (600, 0), (600, -150), (900, 0), (900, -150)])
        
        let f8 = createFormation(points: [(0, 0), (0, -150), (-300, 0), (-300, -150), (-600, 0), (-600, -150), (-900, 0), (-900, -150)])
        
        for formation in [f1, f2, f3, f4, f5, f6, f7, f8] {
            f.append(formation)
        }
        
        return f
    }
}

// MARK: - 
struct PolarPoint: CustomStringConvertible {
    // distance from origin
    let r: CGFloat
    // angle from origin POINT, which is the first ship in formation (relative to Y axis)
    // NOTE! - angle in radians is already made positive
    let a: CGFloat
    
    var description: String {
        return "r: \(r), a: \(a / .pi * 180)"
    }
}
