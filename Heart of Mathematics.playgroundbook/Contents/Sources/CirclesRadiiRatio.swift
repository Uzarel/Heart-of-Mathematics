import SpriteKit

public class circlesRadiiRatio: SKScene {
    // Variables
    var isRunning: Bool!
    var ratio: Int!
    var duration: TimeInterval!
    var startingRadius: CGFloat!
    var curvePoints: [CGPoint] = []
    
    // Initializator
    public init(size: CGSize, ratio: Int, radius: Double, duration: Int) {
        self.isRunning = false
        self.ratio = ratio
        self.startingRadius = CGFloat(radius)
        self.duration = TimeInterval(duration)
        self.curvePoints = []
        super.init(size: size)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Rotates the circle and creates the line from the rotating point
    func rotateCircles(radiiRatio: Int, duration: TimeInterval) {
        guard let bigCircle = childNode(withName: "bigCircle") else { return }
        guard let littleCircle = bigCircle.childNode(withName: "littleCircle") else { return }
        // Let the coordinates evaluation start
        self.isRunning = true
        // Actions definitions for rotation
        let bigRotate = SKAction.rotate(byAngle: 2 * .pi, duration: duration)
        let littleRotate = SKAction.rotate(byAngle: CGFloat(radiiRatio) * 2 * .pi, duration: duration)
        // Wait action definition for avoiding lag problems
        let wait = SKAction.wait(forDuration: 0.5)
        bigCircle.run(SKAction.sequence([wait, bigRotate]))
        // Animation with completion handler for drawing the final line
        littleCircle.run(SKAction.sequence([wait, littleRotate])) {
            self.isRunning = false
            let curve = SKShapeNode(points: &self.curvePoints, count: self.curvePoints.count)
            curve.strokeColor = .white
            curve.name = "curve"
            self.addChild(curve)
        }
    }
    
    // Scene drawing
    func createCircles(scene: SKScene, radiiRatio: Int) {
        // Draws the big circle
        let bigCircle = SKShapeNode(circleOfRadius: startingRadius)
        bigCircle.position = CGPoint(x: scene.frame.midX, y: scene.frame.midY)
        bigCircle.strokeColor = .white
        bigCircle.glowWidth = 1
        bigCircle.name = "bigCircle"
        scene.addChild(bigCircle)
        // Draws the little circle
        let littleCircle = SKShapeNode(circleOfRadius: startingRadius / CGFloat(ratio))
        littleCircle.position = CGPoint(x: startingRadius + (startingRadius / CGFloat(ratio)), y: 0)
        littleCircle.strokeColor = .white
        littleCircle.glowWidth = 1
        littleCircle.name = "littleCircle"
        bigCircle.addChild(littleCircle)
        // Draws the point that rotates and creates the line
        let rotatingPoint = SKShapeNode(circleOfRadius: (startingRadius / CGFloat(ratio)) / 5)
        rotatingPoint.position = CGPoint(x: -(startingRadius / CGFloat(ratio)), y: 0)
        rotatingPoint.strokeColor = .white
        rotatingPoint.glowWidth = 1
        rotatingPoint.name = "rotatingPoint"
        littleCircle.addChild(rotatingPoint)
    }
    
    // Setting up the scene
    override public func didMove(to view: SKView) {
        createCircles(scene: self, radiiRatio: ratio)
        rotateCircles(radiiRatio: ratio, duration: duration)
    }
    
    override public func update(_ currentTime: TimeInterval) {
        // Defining what are the nodes that need to be animated
        guard let bigCircle = childNode(withName: "bigCircle") else { return }
        guard let littleCircle = bigCircle.childNode(withName: "littleCircle") else { return }
        guard let rotatingPoint = littleCircle.childNode(withName: "rotatingPoint") else { return }
        // Get absolute position
        if isRunning {
            let point = convert(rotatingPoint.position, from: littleCircle)
            self.curvePoints.append(CGPoint(x: point.x, y: point.y))
        }
    }
}
