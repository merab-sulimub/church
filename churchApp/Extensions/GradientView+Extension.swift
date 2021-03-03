//Created for churchApp  (21.10.2020 )

import UIKit

@IBDesignable class GradientView: UIView {

    @IBInspectable var startColor: UIColor = .blue {
        didSet {
            setNeedsLayout()
        }
    }

    @IBInspectable var endColor: UIColor = .green {
        didSet {
            setNeedsLayout()
        }
    }

    @IBInspectable var shadowColor: UIColor = .yellow {
        didSet {
            setNeedsLayout()
        }
    }

    @IBInspectable var shadowX: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }

    @IBInspectable var shadowY: CGFloat = -3 {
        didSet {
            setNeedsLayout()
        }
    }

    @IBInspectable var shadowBlur: CGFloat = 3 {
        didSet {
            setNeedsLayout()
        }
    }

    @IBInspectable var startPointX: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }

    @IBInspectable var startPointY: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }

    @IBInspectable var endPointX: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }

    @IBInspectable var endPointY: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }

//    @IBInspectable override var cornerRadius: CGFloat = 0 {
//        didSet {
//            setNeedsLayout()
//        }
//    }

    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    override func layoutSubviews() {
        let gradientLayer = layer as! CAGradientLayer
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: startPointX, y: startPointY)
        gradientLayer.endPoint = CGPoint(x: endPointX, y: endPointY)
//        layer.cornerRadius = cornerRadius
//        layer.shadowColor = shadowColor.cgColor
//        layer.shadowOffset = CGSize(width: shadowX, height: shadowY)
//        layer.shadowRadius = shadowBlur
//        layer.shadowOpacity = 1
    }
}





/// Gradient for Buttons

typealias GradientPoints = (startPoint: CGPoint, endPoint: CGPoint)

enum GradientOrientation {
    case topRightBottomLeft
    case topLeftBottomRight
    case horizontal
    case vertical

    var startPoint : CGPoint {
        return points.startPoint
    }

    var endPoint : CGPoint {
        return points.endPoint
    }

    var points : GradientPoints {
        switch self {
        case .topRightBottomLeft:
            return (CGPoint(x: 0.0,y: 1.0), CGPoint(x: 1.0,y: 0.0))
        case .topLeftBottomRight:
            return (CGPoint(x: 0.0,y: 0.0), CGPoint(x: 1,y: 1))
        case .horizontal:
            return (CGPoint(x: 0.0,y: 0.5), CGPoint(x: 1.0,y: 0.5))
        case .vertical:
            return (CGPoint(x: 0.0,y: 0.0), CGPoint(x: 0.0,y: 1.0))
        }
    }
}


extension UIView {
    @discardableResult
    func applyGradient(colours: [UIColor]) -> CAGradientLayer {
        return self.applyGradient(colours: colours, locations: nil)
    }

    @discardableResult
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
        return gradient
    }
    
    
     

    func applyGradient(with colours: [UIColor], gradient orientation: GradientOrientation) {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.startPoint = orientation.startPoint
        gradient.endPoint = orientation.endPoint
        self.layer.insertSublayer(gradient, at: 0)
    }
    
}
