import PlaygroundSupport
import SpriteKit
import UIKit

// Class that handles the changing of scenes
public class liveViewController: UIViewController {
    // Variables definitions for initializating the scenes
    var sceneName: String!
    var spriteView: SKView!
    var spriteScene: SKScene!
    var backgroundView: UIView!
    var CGView: UIView!
    var originalSpriteSize: CGSize!
    var originalViewSize: CGSize!
    
    // Variables definitions for scenes parameters
    public var times: Int = 3
    public var subdivisions: Int = 10
    public var linesColor = UIColor.white
    public var rainbowColor = false
    public var ratio: Int = 2
    public var duration: Int = 5
    public var power: Int = 3
    public var hue: CGFloat = (2/3)
    
    // Setting up the correct scene for the current page
    public init(sceneName: String) {
        super.init(nibName: nil, bundle: nil)
        self.sceneName = sceneName
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        // Handles the different scenes displaying
        switch sceneName {
        case "TimeTables":
            spriteView = SKView(frame: view.frame)
            spriteScene = TimeTables(size: spriteView.frame.size, times: times, radius: 200, subdivisions: subdivisions, color: linesColor, rainbowColor: rainbowColor)
            originalSpriteSize = spriteView.frame.size
            view.addSubview(spriteView)
            spriteScene.scaleMode = .aspectFill
            spriteView.presentScene(spriteScene)
        case "circlesRadiiRatio":
            spriteView = SKView(frame: view.frame)
            spriteScene = circlesRadiiRatio(size: spriteView.frame.size, ratio: ratio, radius: 80, duration: duration)
            originalSpriteSize = spriteView.frame.size
            view.addSubview(spriteView)
            spriteScene.scaleMode = .aspectFill
            spriteView.presentScene(spriteScene)
        case "Mandelbrot":
            let minDimension = min(view.frame.size.width, view.frame.size.height)
            backgroundView = UIView(frame: view.frame)
            backgroundView.backgroundColor = .black
            originalViewSize = backgroundView.frame.size
            CGView = mandelbrotScene(frame: CGRect(x: backgroundView.frame.midX-(minDimension/4), y: view.frame.midY-(minDimension/4), width: (minDimension/2), height: (minDimension/2)), power: power, hue: hue)
            view.addSubview(backgroundView)
            backgroundView.addSubview(CGView)
        default:
            print("Error")
        }
    }
    
    // Fixes the layout
    override public func viewDidLayoutSubviews() {
        if spriteView != nil {
            self.spriteView.center = self.view.center
            self.spriteView.frame = self.view.frame
        } else {
            self.backgroundView.frame = self.view.frame
            self.backgroundView.center = self.view.center
            self.CGView.center = self.backgroundView.center
        }
    }
}

// Takes care of receiving the parameters from the contents view for each page
extension liveViewController: PlaygroundLiveViewMessageHandler {
    public func receive(_ message: PlaygroundValue) {
        switch message {
            case let .dictionary(dictionary):
                guard case let .string(command)? = dictionary["Command"] else {
                    return
                }
            switch command {
            case "times":
                if case let PlaygroundValue.array(message)? = dictionary["Message"] {
                    if case let .integer(t) = message[0] {
                        if case let .integer(s) = message[1] {
                            if case let .floatingPoint(red) = message[2] {
                                if case let .floatingPoint(green) = message[3] {
                                    if case let .floatingPoint(blue) = message[4] {
                                        if case let .floatingPoint(alpha) = message[5] {
                                            if case let .boolean(b) = message[6] {
                                                self.times = t
                                                self.subdivisions = s
                                                self.linesColor = UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
                                                self.rainbowColor = b
                                                spriteScene = TimeTables(size: originalSpriteSize, times: times, radius: 200, subdivisions: subdivisions, color: linesColor, rainbowColor: rainbowColor)
                                                spriteScene.scaleMode = .aspectFill
                                                spriteView.presentScene(spriteScene)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            case "ratio":
                if case let PlaygroundValue.array(message)? = dictionary["Message"] {
                    if case let .integer(r) = message[0] {
                        if case let .integer(d) = message[1] {
                            self.ratio = r
                            self.duration = d
                            spriteScene = circlesRadiiRatio(size: originalSpriteSize, ratio: ratio, radius: 100.0, duration: duration)
                            spriteScene.scaleMode = .aspectFill
                            spriteView.presentScene(spriteScene)
                        }
                    }
                }
            case "mandelbrot":
                if case let PlaygroundValue.array(message)? = dictionary["Message"] {
                    if case let .integer(p) = message[0] {
                        if case let .floatingPoint(h) = message[1] {
                            self.power = p
                            self.hue = CGFloat(h)
                            let minDimension = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
                            backgroundView.subviews[0].removeFromSuperview()
                            self.CGView = mandelbrotScene(frame: CGRect(x: backgroundView.frame.midX-(minDimension/4), y: view.frame.midY-(minDimension/4), width: (minDimension/2), height: (minDimension/2)), power: power, hue: hue)
                            backgroundView.addSubview(self.CGView)
                        }
                    }
                }
            default:
                break
            }
        default:
            break
        }
    }
}

