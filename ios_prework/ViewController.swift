import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var button: UIButton!
    
    @IBOutlet var label: [UILabel]!
    
    @IBOutlet weak var progressBar: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpButton()
        progressBar.progress = 0.0
        progressBar.trackTintColor = UIColor.white
    }
    
    /*
     source: https://stackoverflow.com/questions/9733288/how-to-programmatically-calculate-the-contrast-ratio-between-two-colors/9733420#9733420
    */
    private func luminance(r: Double, g: Double, b: Double) -> Double {
        let GAMMA = 2.4
        let RED = 0.2126
        let GREEN = 0.7152
        let BLUE = 0.0722

        var a = [r, g, b]
        a = a.map { $0 / 255 }
        a = a.map { v in
            v <= 0.03928 ? v / 12.92 : pow((v + 0.055) / 1.055, GAMMA)
        }

        return a[0] * RED + a[1] * GREEN + a[2] * BLUE
    }
    
    private func setUpButton(){
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.layer.cornerCurve = .continuous
        button.layer.cornerRadius = 10
        button.layer.backgroundColor = UIColor.systemPink.cgColor
    }
    
    private func updateProgressBar(backgroundColor: UIColor){
        
        var progressColor: UIColor
        var progressPercent: Float
        
        let ciColor = CIColor(color: backgroundColor)

        let redRGB = ciColor.red
        let blueRGB = ciColor.blue
        let greenRGB = ciColor.green

        // barColor = "red"
        if redRGB > greenRGB && redRGB > blueRGB {
            progressColor = UIColor.red
            progressPercent = 0.25
        // barColor = "green"
        } else if greenRGB > redRGB && greenRGB > blueRGB {
            progressColor = UIColor.green
            progressPercent = 0.50
        // barColor = "blue"
        } else if blueRGB > redRGB && blueRGB > greenRGB {
            progressColor = UIColor.blue
            progressPercent = 0.75
        // barColor = "white"
        } else {
            progressColor = UIColor.white
            progressPercent = 1
        }
        
        progressBar.progress = progressPercent
        progressBar.progressTintColor = progressColor
        progressBar.setProgress(progressBar.progress, animated: true)
    }

    @IBAction func changeBackground(_ sender: UIButton) {
        
        func changeColor() -> (textColor: UIColor, backgroundColor: UIColor){
            let red = CGFloat.random(in: 0...1)
            let green = CGFloat.random(in: 0...1)
            let blue = CGFloat.random(in: 0...1)
            
            let luminance = luminance(r: red*255, g: green*255, b: blue*255)

            let textColor = luminance > 0.179 ? UIColor.black : UIColor.white
            
            return (textColor: textColor, backgroundColor: UIColor(red: red, green: green, blue: blue, alpha: 1))
        }
        
        let newColor = changeColor()
        view.backgroundColor = newColor.backgroundColor
        
        updateProgressBar(backgroundColor: newColor.backgroundColor)
        
        for lb in self.label{
            lb.textColor = newColor.textColor
        }
        
    }

}

