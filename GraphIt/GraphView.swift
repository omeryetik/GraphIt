//
//  GraphView.swift
//  GraphIt
//
//  Created by Ömer Yetik on 28/09/2017.
//  Copyright © 2017 Ömer Yetik. All rights reserved.
//

import UIKit

@IBDesignable
class GraphView: UIView {

    // scale identifies points per unit in the view
    @IBInspectable
    var scale: CGFloat = 50 { didSet { setNeedsDisplay() } }
    
    // origin for graph
    @IBInspectable
    var origin: CGPoint = CGPoint(x: 0.0, y: 0.0) { didSet { setNeedsDisplay() } }
    
    @IBInspectable
    var lineWidth: CGFloat = 2.0 { didSet { setNeedsDisplay() } }
    
    var dataSource: GraphViewDataSource? = nil
    
    private var axesDrawer = AxesDrawer()
    
    // MARK: Gesture handling functions
    
    // Pinch Gesture handler : Modifies scale
    func changeScale(byReactingTo pinchRecognizer: UIPinchGestureRecognizer) {
        switch pinchRecognizer.state {
        case .changed, .ended:
            scale *= pinchRecognizer.scale
            pinchRecognizer.scale = 1.0 // reset scale of the gesture to allow incremental scaling
        default:
            break
        }
    }
    
    // Pan Gesture handler : Moves origin by a pan gesture
    // Tap Gesture Handler : Sets origin to the point tapped
    func changeOrigin(byReactingTo gestureRecognizer: UIGestureRecognizer) {
        if let panRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            switch panRecognizer.state {
            case .changed, .ended:
                let translation = panRecognizer.translation(in: self)
                origin.x += translation.x
                origin.y += translation.y
                panRecognizer.setTranslation(CGPoint(x: 0, y: 0), in: self)
            default:
                break
            }
        } else if let tapRecognizer = gestureRecognizer as? UITapGestureRecognizer {
            switch tapRecognizer.state {
            case .recognized:
                let location = tapRecognizer.location(in: self)
                origin = location
            default:
                break
            }
        }
    }
    //
    
    private func pointOnGraph(correspondingTo xInViewCoordinates: CGFloat) -> CGPoint {
        let xInGraphCoordinates = (-origin.x + xInViewCoordinates) / scale
        let yInGraphCoordinates = CGFloat(dataSource!.yValue(for: Double(xInGraphCoordinates)))
        
        let yInViewCoordinates = origin.y - (yInGraphCoordinates * scale)
        
        return CGPoint(x: xInViewCoordinates, y: yInViewCoordinates)
    }
    
    private func drawGraph(in rect: CGRect) -> UIBezierPath {
        let numberOfPixelsOnXAxis = Int(rect.width * contentScaleFactor)
        let stepSizeInPoints = 1 / contentScaleFactor // one pixel = 1/contentScaleFactor points
        
        let graph = UIBezierPath()
        graph.lineWidth = lineWidth
        let startPoint = pointOnGraph(correspondingTo: 0)
        graph.move(to: startPoint)
        
        for pixelCount in 1...numberOfPixelsOnXAxis {
            let xInViewCoordinates = stepSizeInPoints * CGFloat(pixelCount)
            let nextPoint = pointOnGraph(correspondingTo: xInViewCoordinates)
            graph.addLine(to: nextPoint)
            
        }

        return graph
    }
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        print("There are \(self.contentScaleFactor) pixels per point")
        print(rect)
        let graph = drawGraph(in: rect)
        axesDrawer.contentScaleFactor = contentScaleFactor
        axesDrawer.drawAxes(in: rect, origin: origin, pointsPerUnit: scale)
        UIColor.red.set()
        graph.stroke()
    }

}
