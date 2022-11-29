//
//  FaceView.swift
//  Happy
//
//  Created by ahmed on 11/22/22.
//

import UIKit
protocol FaceViewDataSource: AnyObject{
    func smilinessforHappiness(_ sender: FaceView) -> Double
}
@IBDesignable
class FaceView: UIView {
    var dataSource: FaceViewDataSource?
    @IBInspectable
    var color: UIColor = UIColor.red {didSet{setNeedsDisplay()}}
    @IBInspectable
    var lineWidth:CGFloat = 3
    @IBInspectable
    var scale: CGFloat = 0.9 {didSet{setNeedsDisplay()}}
    var faceRadius: CGFloat {
        return min(bounds.size.width, bounds.size.height) / 2 * scale
    }
    
    var faceCenter: CGPoint {
        return convert(center, from: superview)
    }
    fileprivate struct Scaling{
        static let FaceRadiusToEyeRadiusRatio: CGFloat = 10
        static let FaceRadiusToEyeOffsetRatio: CGFloat = 3
        static let FaceRadiusToEyeSeparationRatio: CGFloat = 1.5
        static let FaceRadiusToMouthWidthRatio: CGFloat = 1
        static let FaceRadiusToMouthHeightRatio: CGFloat = 3
        static let FaceRadiusToMouthOffsetRatio: CGFloat = 3
    }
    
    fileprivate enum Eye {case left, right}
    
    fileprivate func bezeirPathForEye(_ whichEye: Eye) -> UIBezierPath
    {
        let eyeRadius = faceRadius / Scaling.FaceRadiusToEyeRadiusRatio
        let eyeVerticalOffset = faceRadius / Scaling.FaceRadiusToEyeOffsetRatio
        let eyeHorizontalSeapration = faceRadius / Scaling.FaceRadiusToEyeSeparationRatio
        var eyeCenter = faceCenter
        eyeCenter.y -= eyeVerticalOffset
        switch whichEye {
        case .left:
            eyeCenter.x -= eyeHorizontalSeapration / 2
        case .right:
            eyeCenter.x += eyeHorizontalSeapration / 2
        }
        
        let path = UIBezierPath(arcCenter: eyeCenter, radius: eyeRadius, startAngle: 0, endAngle: CGFloat(2 * Double.pi), clockwise: true)
        path.lineWidth = lineWidth
        return path
    }
    
    fileprivate func bezierPathForSmile(_ fractionOfMaxSmile: Double) -> UIBezierPath
    {
        let mouthWidth = faceRadius / Scaling.FaceRadiusToMouthWidthRatio
        let mouthHeight = faceRadius / Scaling.FaceRadiusToMouthHeightRatio
        let mouthVerticalOffset = faceRadius / Scaling.FaceRadiusToMouthOffsetRatio
        let smileHeight = CGFloat(max(min(fractionOfMaxSmile, 1), -1)) * mouthHeight
        let start = CGPoint(x: faceCenter.x - mouthWidth / 2, y: faceCenter.y + mouthVerticalOffset)
        let end = CGPoint(x: start.x + mouthWidth, y: start.y)
        let cp1 = CGPoint(x: start.x + mouthWidth / 3, y: start.y + smileHeight)
        let cp2 = CGPoint(x: end.x - mouthWidth / 3, y: cp1.y)
        let path = UIBezierPath()
        path.move(to: start)
        path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = lineWidth
        return path
    }
    override func draw(_ rect: CGRect) {
        let facePath = UIBezierPath(arcCenter: faceCenter, radius: faceRadius, startAngle: 0, endAngle: CGFloat(2 * Double.pi), clockwise: true)
        facePath.lineWidth = lineWidth
        color.set()
        facePath.stroke()
        bezeirPathForEye(.left).stroke()
        bezeirPathForEye(.right).stroke()
        let smiliness = dataSource?.smilinessforHappiness(self) ?? 0.0
        bezierPathForSmile(smiliness).stroke()
        
    }
    

}
