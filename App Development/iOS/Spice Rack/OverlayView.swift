
import UIKit

//http://zappdesigntemplates.com/create-your-own-overlay-view-in-swift/
class OverlayView: UIView {
    

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emptyIcon: UIImageView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    var view: UIView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    

    func loadViewFromXibFile() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "OverlayView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }
    
  
    func setupView() {
        view = loadViewFromXibFile()
        view.frame = bounds
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.text = "Saved to Rack"
        
        view.layer.cornerRadius = 4.0
        view.layer.shadowColor = UIColor.blackColor().CGColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 4.0
        view.layer.shadowOffset = CGSizeMake(0.0, 8.0)
        
        visualEffectView.layer.cornerRadius = 4.0
    }
    

    func displayView(onView: UIView) {
        self.alpha = 0.0
        onView.addSubview(self)
        
        onView.addConstraint(NSLayoutConstraint(item: self, attribute: .CenterY, relatedBy: .Equal, toItem: onView, attribute: .CenterY, multiplier: 1.0, constant: -80.0)) // move it a bit upwards
        onView.addConstraint(NSLayoutConstraint(item: self, attribute: .CenterX, relatedBy: .Equal, toItem: onView, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        onView.needsUpdateConstraints()
        
        // display the view
        transform = CGAffineTransformMakeScale(0.1, 0.1)
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.alpha = 1.0
            self.transform = CGAffineTransformIdentity
        }) { (finished) -> Void in
            // When finished wait 1.5 seconds, than hide it
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1.5 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                self.hideView()
            }
        }
    }
    
 
    override func updateConstraints() {
        super.updateConstraints()
        
        addConstraint(NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 170.0))
        addConstraint(NSLayoutConstraint(item: self, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 200.0))
        addConstraint(NSLayoutConstraint(item: view, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: view, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: view, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: view, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1.0, constant: 0.0))
    }
    
   
    private func hideView() {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.transform = CGAffineTransformMakeScale(0.1, 0.1)
        }) { (finished) -> Void in
            self.removeFromSuperview()
        }
    }
    
}
