//#-hidden-code
import SpriteKit
import PlaygroundSupport

// Defining the page that will be showed on the book
let page = PlaygroundPage.current
let proxy = page.liveView as? PlaygroundRemoteLiveViewProxy

// Variables for proxy checking
var lastPower: Int = 3
var lastColor: UIColor = UIColor.blue

// The function that takes care of the interactions with variables
func setVariables(power: Int, color: UIColor) {
    // Does not send any command if the power is too high or negative and if the power or the color are different from the last time
    if power > -1 && power < 6 && (power != lastPower || color != lastColor) {
        let command: PlaygroundValue
        var hue: CGFloat = 0.0
        color.getHue(&hue, saturation: nil, brightness: nil, alpha: nil)
        let variables = [PlaygroundValue.integer(abs(power)), PlaygroundValue.floatingPoint(Double(hue))]
        command = .dictionary([
            "Command": .string("mandelbrot"),
            "Message": PlaygroundValue.array(variables)
            ])
        proxy?.send(command)
    }
    switch power {
    case -Int.max ..< 0:
        page.assessmentStatus = .fail(hints: ["Negative values are not allowed at all, so the code won't run this time", "Try something between 0 and 5 instead!"], solution: "Try a power of 2!")
    case 0:
        page.assessmentStatus = .fail(hints: ["A power of 0 is not that interesting", "Try something different!"], solution: "Try a power of 2!")
    case 1:
        page.assessmentStatus = .fail(hints: ["Although a power of 1 creates a cool shape, it's still too low", "Try something different!"], solution: "Try a power of 2!")
    case 2:
        page.assessmentStatus = .pass(message: "You made it to the end, nice job. Now just have fun with the customizations!")
    case 2 ..< 6:
        page.assessmentStatus = .fail(hints: ["This power is too high, but the code will run anyway", "Try something different!"], solution: "Try a power of 2!")
    default:
        page.assessmentStatus = .fail(hints: ["This power is way too high and it is not allowed, so the code won't run this time", "Try something between 0 and 5 instead!"], solution: "Try a power of 2!")
    }
}
//#-end-hidden-code
/*:
 # Heart of Mathematics
 ## Generalized Mandelbrot Set
 
 - Important: As the calculations for the Mandelbrot sets are **very** high, the code execution may last up to 20 seconds **every time** you run it. Please, wait until the set appears on screen each time you tap on "Run my code"!
 
 As also stated before, there are several ways for getting these kind of shapes. The last one presented on this playground is through the Mandelbrot sets.
 
 ## Definition
 The term Mandelbrot set refers to a class of [fractals](glossary://fractal) sets. These sets mark a set of points in the [complex](glossary://complex) plane and are obtained from the following [recurrence equation](glossary://recurrence):
 
 _z(n+1) = z(n)^power + c_  with _c = z(0)_.
 
 For each and every point of the complex plane, we evaluate this equation multiple times.
 
 - The points that are in the set are the ones whose distance from the origin of the complex plane is **always** bounded (never larger than 2 in our simulations).
 - The ones that are not in the set are the ones whose distance from the origin of the complex plane gets arbitrary large (gets bigger than 2) in a certain number of iterations.
 * Depending on the number of iterations until these points _blow up_, a different color is assigned to them. The brighter the color, the slower it blows up.
 - The color of the points in the set is set to black.
 
 As you may have noticed, the main bulb shape in these sets are the ones we created with circles and times tables! Your goal for this page is again (for the last time hopefully) to create a [cardioid](glossary://cardioid)!
 
 ## Let's start!
 Modify the values in the bottom in order to find the cardiod shape!
 
 ### Side notes:
 While you could potentially set the power of the Generalized Mandelbrot Set as you like, for this time you are **only** allowed to use low values, like the ones between 1 and 5, because of code execution time.
 Negative values will not be allowed this time.
 */
//#-code-completion(everything, hide)
setVariables(power: /*#-editable-code*/3/*#-end-editable-code*/,
    color: /*#-editable-code*/#colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)/*#-end-editable-code*/)
