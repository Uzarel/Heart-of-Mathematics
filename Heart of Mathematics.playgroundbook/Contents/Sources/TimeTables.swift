import SpriteKit

public class TimeTables: SKScene {
    // Indexing for update animation
    var index: Int!
    var times: Int!
    var radius: CGFloat!
    var subdivisions: Int!
    var color: UIColor!
    var rainbowColor: Bool!
    
    // Initialization
    public init(size: CGSize, times: Int, radius: Double, subdivisions: Int, color: UIColor, rainbowColor: Bool) {
        self.index = 0
        self.times = times
        self.radius = CGFloat(radius)
        self.subdivisions = subdivisions
        self.color = color
        self.rainbowColor = rainbowColor
        super.init(size: size)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func didMove(to view: SKView) {
        // Draws the circle and its subdivisions
        drawCircle(scene: self, radius: radius, subdivision: subdivisions)
    }
    override public func update(_ currentTime: TimeInterval) {
        // Draws a line everytime a frame is rendered
        if index < points.count {
            drawLine(scene: self, points: points, times: times, index: index)
            index = index + 1
        }
    }
    
    // Global variable for points storing
    var points: [CGPoint] = []
    
    // Draw the circle and its subdivisions
    public func drawCircle(scene: SKScene, radius: CGFloat, subdivision: Int) {
        // Creates the big circle
        let circle = SKShapeNode(circleOfRadius: radius)
        circle.position = CGPoint(x: scene.frame.midX, y: scene.frame.midY)
        circle.strokeColor = .white
        circle.glowWidth = 1.0
        scene.addChild(circle)
        
        for i in 0 ..< subdivision {
            let angle: CGFloat = CGFloat(i) * (.pi * 2) / CGFloat(subdivision)
            // Creates the little circles
            let pointCoordinates = CGPoint(x: scene.frame.midX + (radius * cos(angle)), y: scene.frame.midY + (radius * sin(angle)))
            let point = SKShapeNode(circleOfRadius: 2)
            point.position = pointCoordinates
            point.strokeColor = .white
            point.glowWidth = 1.0
            point.name = "point"
            scene.addChild(point)
            // Creates the labels
            let labelCoordinates = CGPoint(x: scene.frame.midX + ((radius + 30) * cos(angle)), y: scene.frame.midY + ((radius + 30) * sin(angle)))
            let label = SKLabelNode(text: String(i))
            label.position = labelCoordinates
            label.color = .white
            label.horizontalAlignmentMode = .center
            label.verticalAlignmentMode = .center
            // Adapting the font size depending on the numbers of subdivisions
            switch subdivision {
            case 0 ... 50:
                label.fontSize = 12
            case 51 ... 100:
                label.fontSize = 6
            default:
                label.fontSize = 4
            }
            label.name = "name"
            scene.addChild(label)
            // Creates the array of points
            points.append(pointCoordinates)
        }
        
    }
    
    // Draw line once per call
    public func drawLine(scene: SKScene, points: [CGPoint], times: Int, index: Int) {
        // Picks up the points that are going to be connected
        var linePoints: [CGPoint] = []
        linePoints.append(points[index])
        // Modular division
        let nextIndexPoint = (times * index) % points.count
        linePoints.append(points[nextIndexPoint])
        let line = SKShapeNode(points: &linePoints, count: linePoints.count)
        if rainbowColor {
            // Rainbow color
            line.strokeColor = UIColor(hue: (CGFloat(index) / CGFloat(points.count)), saturation: 1, brightness: 1, alpha: 1)
        } else {
            // Static color
            line.strokeColor = color
        }
        line.name = "line"
        scene.addChild(line)
    }
}

