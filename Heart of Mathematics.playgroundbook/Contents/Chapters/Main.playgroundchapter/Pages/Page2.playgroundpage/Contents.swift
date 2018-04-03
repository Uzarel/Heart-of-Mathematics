//#-hidden-code
import SpriteKit
import PlaygroundSupport

// Defining the page that will be showed on the book
let page = PlaygroundPage.current
let proxy = page.liveView as? PlaygroundRemoteLiveViewProxy

// The function that takes care of the interactions with variables
func setVariables(ratio: Int, duration: Int) {
    let command: PlaygroundValue
    let variables = [PlaygroundValue.integer(abs(ratio)), PlaygroundValue.integer(abs(duration))]
    command = .dictionary([
        "Command": .string("ratio"),
        "Message": PlaygroundValue.array(variables)
        ])
    proxy?.send(command)
    switch ratio {
    case -1:
        page.assessmentStatus = .pass(message: "Nicely done with the cardioid again! Now let's go to the next page! [Next page](@next)")
    case -Int.max..<0:
        page.assessmentStatus = .fail(hints: ["Negative values are not allowed", "For this time, it has been converted to a positive one automatically", "Try positive ratios instead!"], solution: nil)
    case 0:
        page.assessmentStatus = .fail(hints: ["A ratio of 0 is not that interesting", "Try something different!"], solution: nil)
    case 1:
        page.assessmentStatus = .pass(message: "Nicely done with the cardioid again! Now let's go to the next page! [Next page](@next)")
    default:
        page.assessmentStatus = .fail(hints: ["This ratio is too high", "Try something different!"], solution: "Try a ratio of 1!")
    }
}

//#-end-hidden-code
/*:
 # Heart of Mathematics
 ## Circles Radii Ratio
 
 As we have seen before, a cardioid (as a lot of other shapes) can be obtained with Circular Times Tables.. but is it the only one way to do that? Of course it is not!
 
 Take two circles: the first one will have a certain radius and the other one will have another. Let's call _ratio_ the ratio between these two radii. Then let the second circle rotate around the first one and see what happens to one of the points on they boundary of the rolling circle.
 
 It traces a shape!
 Your goal for this page is (again) to create a [cardioid](glossary://cardioid)!
 
 ## Let's start!
 Modify the values in the bottom in order to find the cardiod shape!
 
 ### Side notes:
 Set duration as you please but not too short, otherwise you will see nothing on screen!
 Best results are achieved around 5 seconds. Also, don't set a ratio higher than 25.
 Negative values will be automatically converted to positive ones.
 */
//#-code-completion(everything, hide)
setVariables(ratio: /*#-editable-code*/2/*#-end-editable-code*/,
    duration: /*#-editable-code*/5/*#-end-editable-code*/)
