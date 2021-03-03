//Created for churchApp  (13.11.2020 )

import SwiftUI



extension Path {
    var reversed: Path {
        let reversedCGPath = UIBezierPath(cgPath: cgPath)
            .reversing()
            .cgPath
        return Path(reversedCGPath)
    }
}

struct ShapeWithHole: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Rectangle().path(in: rect)
        let hole = Circle().path(in: rect).reversed
        path.addPath(hole)
        return path
    }
}


struct ShapeWithRoundedRectangle: Shape {
    
    let cornerRadius: CGFloat = 25
    let inset: CGFloat = 24
     
    func path(in rect: CGRect) -> Path {
        var path = Rectangle().path(in: rect)
        let hole = RoundedRectangle(cornerRadius: inset+cornerRadius).inset(by: inset)
             
            .path(in: rect).reversed
        path.addPath(hole)
        return path
    }
}

struct CircleWithTranspShape: Shape {
    
    let cornerRadius: CGFloat = 25
    let inset: CGFloat = 6
     
    func path(in rect: CGRect) -> Path {
        var path = Rectangle().path(in: rect)
        
        let hole = Circle().inset(by: inset)
            //RoundedRectangle(cornerRadius: inset+cornerRadius).inset(by: inset)
             
            .path(in: rect).reversed
        path.addPath(hole)
        return path
    }
}
