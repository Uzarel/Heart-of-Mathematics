import UIKit

public class mandelbrotScene: UIView {
    // Variables for initialization
    var power: Int!
    var hue: CGFloat = 0.0
    var colors: [UIColor] = []
    var mandelbrotPoints: [MandelbrotPoint] = []
    // Complex plane creation
    var mandelbrotRect = ComplexPlane(c1: ComplexNumber(real: -1.5, imaginary: 1.5), c2: ComplexNumber(real: 1.5, imaginary: -1.5))
    
    // Initialization
    public init(frame: CGRect, power: Int, hue: CGFloat) {
        self.colors = []
        self.mandelbrotPoints = []
        self.power = power
        self.hue = hue
        super.init(frame: frame)
        generateColors()
        createMandelbrotPoints(viewFrame: frame, power: self.power)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Initializing colors array
    func generateColors() {
        for i in 1...constants.iterations {
            let indexCGFloat = CGFloat(i)
            colors.append(UIColor(hue: self.hue, saturation: 1-abs(sin(indexCGFloat/30)), brightness: abs(sin(indexCGFloat/30)), alpha: 1.0))
        }
    }
    
    // Calculate how many iterations until a complex number may "blow up"
    func iterationsForLocation(c: ComplexNumber, n: Int) -> Int? {
        var iteration = 0
        var z = ComplexNumber(real: 0.0, imaginary: 0.0)
        repeat {
            z = pow(z: z, n: n) + c
            iteration += 1
        } while (z.normal() < constants.escape && iteration < constants.iterations)
        return iteration < constants.iterations ? iteration : nil
    }
    
    // Determinates the color for number of iterations
    func colorForIterations(iterations: Int?) -> UIColor {
        switch iterations {
        case nil:
            return .black
        default:
            return colors[iterations!]
        }
    }
    
    // Converts view coordinates to complex coordinates
    func viewToComplexConversion(x: Double, y: Double, viewFrame: CGRect) -> ComplexNumber {
        let topLeft = mandelbrotRect.topLeft
        let bottomRight = mandelbrotRect.bottomRight
        let real = topLeft.real + (x/Double(viewFrame.size.width))*(bottomRight.real - topLeft.real)
        let imaginary = topLeft.imaginary + (y/Double(viewFrame.size.height))*(bottomRight.imaginary - topLeft.imaginary)
        return ComplexNumber(real: real, imaginary: imaginary)
    }
    
    // Creates the Mandelbrot Points
    func createMandelbrotPoints(viewFrame: CGRect, power: Int) {
        let width: Double = Double(viewFrame.size.width)
        let height: Double = Double(viewFrame.size.height)
        for dx in stride(from: 0, through: width, by: constants.blockiness) {
            for dy in stride(from: 0, through: height, by: constants.blockiness) {
                let complexCoordinates = viewToComplexConversion(x: dx, y: dy, viewFrame: viewFrame)
                let iterations = iterationsForLocation(c: complexCoordinates, n: power)
                let color = colorForIterations(iterations: iterations)
                let mandelbrotPoint = MandelbrotPoint(viewCoordinates: CGPoint(x: dx, y: dy), color: color)
                mandelbrotPoints.append(mandelbrotPoint)
            }
        }
    }
    
    // Draw the Mandelbrot Points
    func fractalPlot(rect: CGRect, points: [MandelbrotPoint]) {
        for point in points {
            let rect = CGRect(x: point.viewCoordinates.x, y: point.viewCoordinates.y, width: CGFloat(constants.blockiness), height: CGFloat(constants.blockiness))
            let path = UIBezierPath(rect: rect)
            point.color.setFill()
            path.fill()
        }
    }
    
    // Custom draw
    override public func draw(_ rect: CGRect) {
        // Draws the scene by little rectangles
        fractalPlot(rect: rect, points: mandelbrotPoints)
    }
}
