//#-hidden-code
import SpriteKit
import PlaygroundSupport

// Defining the page that will be showed on the book
let page = PlaygroundPage.current
let proxy = page.liveView as? PlaygroundRemoteLiveViewProxy

// The function that takes care of the interactions with variables
func setVariables(times: Int, subdivisions: Int, color: UIColor, rainbowColor: Bool) {
    let command: PlaygroundValue
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var alpha: CGFloat = 0.0
    color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    let variables = [PlaygroundValue.integer(abs(times)), PlaygroundValue.integer(abs(subdivisions)), PlaygroundValue.floatingPoint(Double(red)), PlaygroundValue.floatingPoint(Double(green)), PlaygroundValue.floatingPoint(Double(blue)), PlaygroundValue.floatingPoint(Double(alpha)),  PlaygroundValue.boolean(rainbowColor)]
    command = .dictionary([
        "Command": .string("times"),
        "Message": PlaygroundValue.array(variables)
        ])
    proxy?.send(command)
    switch times {
    case -2:
        page.assessmentStatus = .pass(message: "Nicely done with the cardioid! Now let's go to the next page! [Next page](@next)")
    case -Int.max..<0:
        page.assessmentStatus = .fail(hints: ["Negative values are not allowed", "For this time, it has been converted to a positive one automatically", "Try positive times instead!"], solution: nil)
    case 0:
        page.assessmentStatus = .fail(hints: ["0 times every number is always 0", "Try something different!"], solution: nil)
    case 1:
        page.assessmentStatus = .fail(hints: ["1 times table is not that interesting", "Try something different!"], solution: nil)
    case 2:
        page.assessmentStatus = .pass(message: "Nicely done with the cardioid! Now let's go to the next page! [Next page](@next)")
    // 3..<Int.max case
    default:
        page.assessmentStatus = .fail(hints: ["This time is too high", "Try something different!"], solution: "Try the 2 times table!")
    }
}
//#-end-hidden-code
/*:
 # Heart of Mathematics
 ## Circular Times Tables

 In order to get this straight, let's start with an example of circular times table:
 
 Take a circle and divide its perimeter into 10 points equally spaced and then label them with 0, 1, 2, ..., 9. Then do the labelling thing again, this time starting from 10 (to 19). In this way, 0 will be both 10, 20, 30.. and so on with every other numbers according to what we said.
 
 Then let's do the 3 times tables starting from 0:
 1. 3 times 0 is 0, which is the same, so we don't do anything;
 2. 3 times 1 is 3, so we connect the 1 to the 3;
 3. 3 times 2 is 6, so we connect the 2 to the 6;
 4. We keep on going until we go back to the 0.
 
 Keep in mind that, for instance, when you do the 3 times 4 which is 12, you connect the 4 to the 2 (which is also 12).
 
 When we increase the number of subdivisions, a more defined shape appears.
 Your goal for this page is to create a [cardioid](glossary://cardioid)!
 
 ## Let's start!
 Modify the values in the bottom in order to find the cardiod shape!
 
 ### Side notes:
 Use high and even values of subdivisions, like 100-200, for the best results!
 Negative values will be automatically converted to positive ones.
 */
//#-code-completion(everything, hide)
setVariables(times: /*#-editable-code*/3/*#-end-editable-code*/,
    subdivisions: /*#-editable-code*/10/*#-end-editable-code*/,
    color: /*#-editable-code*/#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)/*#-end-editable-code*/,
    //#-code-completion(identifier, show, true, false)
    rainbowColor: /*#-editable-code*/false/*#-end-editable-code*/)
