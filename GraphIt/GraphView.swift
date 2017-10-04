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
    var lineWidth: CGFloat = 3.0 { didSet { setNeedsDisplay() } }
    
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
    
    private func viewCoorinate(for point: CGPoint, in rect:CGRect) -> CGPoint {
        let xInView = origin.x + (point.x * scale)
        let yInView = origin.y - (point.y * scale)
        return CGPoint(x: xInView, y: yInView)
    }
    
    private func drawGraph(in rect: CGRect) -> UIBezierPath {
        let minXValue: CGFloat = -origin.x / scale
        let maxXValue: CGFloat = (rect.maxX - origin.x) / scale
        
        let minYValue: CGFloat = (origin.y - rect.maxY) / scale
        let maxYValue: CGFloat = -origin.y / scale
        
        print("min X Value = \(minXValue)")
        print("max X Value = \(maxXValue)")
        
        // one step corresponds to advancing one pixel on x-axis
        let stepSize: CGFloat = (1 / contentScaleFactor) / scale
        
        func yValue(for xValue: CGFloat) -> CGFloat {
            return cos(xValue)
        }
        
        var x = minXValue
        var y = yValue(for: x)
        
        let graph = UIBezierPath()
        graph.lineWidth = lineWidth
        let startPoint = CGPoint(x: x, y: y)
        graph.move(to: viewCoorinate(for: startPoint, in: rect))
        repeat {
            x = x + stepSize
            y = yValue(for: x)
            let nextPoint = CGPoint(x: x, y: y)
            graph.addLine(to: viewCoorinate(for: nextPoint, in: rect))
        } while x <= maxXValue
        
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
        UIColor.blue.set()
        graph.stroke()
    }

}
