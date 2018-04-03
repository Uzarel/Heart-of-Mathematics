import UIKit

// Mandelbrot Point with view coordinates and color
public struct MandelbrotPoint {
    var viewCoordinates: CGPoint
    var color: UIColor
    public init(viewCoordinates: CGPoint, color: UIColor) {
        self.viewCoordinates = viewCoordinates
        self.color = color
    }
}

// Complex workspace creation starting by two complex points
public struct ComplexPlane {
    var topLeft: ComplexNumber
    var bottomRight: ComplexNumber
    var bottomLeft: ComplexNumber
    var topRight: ComplexNumber
    public init(c1: ComplexNumber, c2: ComplexNumber) {
        let topLeftReal = min(c1.real, c2.real)
        let topLeftImaginary = max(c1.imaginary, c2.imaginary)
        let bottomRightReal = max(c1.real, c2.real)
        let bottomRightImaginary = min(c1.imaginary, c2.imaginary)
        topLeft = ComplexNumber(real: topLeftReal, imaginary: topLeftImaginary)
        bottomRight = ComplexNumber(real: bottomRightReal, imaginary: bottomRightImaginary)
        bottomLeft = ComplexNumber(real: topLeftReal, imaginary: bottomRightImaginary)
        topRight = ComplexNumber(real: bottomRightReal, imaginary: topLeftImaginary)
    }
}

// Complex number definition
public struct ComplexNumber {
    var real: Double
    var imaginary: Double
    public init(real: Double, imaginary: Double) {
        self.real = real
        self.imaginary = imaginary
    }
    // Module of a complex number
    public func normal() -> Double {
        return real * real + imaginary * imaginary
    }
}

// Complex number operations definition
public func + (x: ComplexNumber, y: ComplexNumber) -> ComplexNumber {
    return ComplexNumber(real: x.real + y.real,
                         imaginary: x.imaginary + y.imaginary)
}
public func * (x: ComplexNumber, y: ComplexNumber) -> ComplexNumber {
    return ComplexNumber(real: x.real * y.real - x.imaginary * y.imaginary,
                         imaginary: x.real * y.imaginary + x.imaginary * y.real)
}
public func pow(z: ComplexNumber, n: Int) -> ComplexNumber {
    switch n {
    case 0:
        return ComplexNumber(real: 1, imaginary: 0)
    case 1:
        return z
    default:
        var power = z
        for _ in 1 ..< n {
            power = power * z
        }
        return power
    }
}

// Constants (iterations are low for execution times optimization)
public let constants = (iterations: 100, escape: 2.0, blockiness: 0.75)
