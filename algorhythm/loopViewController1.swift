//
//  loopViewController.swift
//  algorhythm
//
//  Created by Xu, Cheng on 11/14/15.
//  Copyright © 2015 sansserif. All rights reserved.
//

import UIKit
import AVFoundation




class loopViewController: UIViewController , AVAudioPlayerDelegate, UIGestureRecognizerDelegate {
    
    
    // basic structure
    var audioPlayer : AVAudioPlayer!
    var newPlayer : AVAudioPlayer! //has to be declared here..
    var ticSlots = [AVAudioPlayer?](count:16, repeatedValue: nil)
    var ticCounter = 0
    var timer      = NSTimer()
    
    
    // graphical UI
    @IBOutlet weak var playButton: UIButton!

    var shapes = [Shape]()
    
    //drag and drop
    var newlyCreatedShape: UIImageView!
    var shapeInitialCenter: CGPoint!
    var newlyCreatedShapeOriginalCenter: CGPoint!
    var newlyCreatedShapeMenuCenter: CGPoint!

    
    //BPM 75 : 60.0/75.0/4.0
    let TIMER_INTERVAL =  60.0/300.0 // loat(60) / Float(75)
//    var LOOP_PERIOD : Float!
    let LOOP_PERIOD = 60.0/300.0 * 16
    
    //player loop
    
    var loopView : UIImageView!
    @IBOutlet weak var playerUIView : UIView!
    @IBOutlet weak var playerImage: UIImageView!
    

    //icons : these are the sound icons on the bottom and do not change.
    @IBOutlet var imageView: UIView!
    let panRec = UIPanGestureRecognizer()
    
    //initialize path bounds
    let circleStartAngle = CGFloat(270.01 * M_PI/180)
    let circleEndAngle = CGFloat(270 * M_PI/180)
    let circleBounds = CGRectMake(45, 55, 285, 285)
    let circlePath = UIBezierPath()
    
    
    
    //initialize animnation
    let anim = CAKeyframeAnimation(keyPath: "position")
    
    //icons array on the bottom
    var icons = [Shape]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //PLAYER LOOP 
         let loopImageName = "loop.png"
        let loopImage = UIImage(named: loopImageName)
         loopView = UIImageView(image: loopImage!)
        
        loopView.frame = circleBounds
        //2. add to view
        view.addSubview(loopView)

        
        
//        LOOP_PERIOD = TIMER_INTERVAL * 16.0
        //initialize view size and position
        playerUIView.frame = CGRect(x: 160, y: 300, width: 30, height: 30)
        playerUIView.alpha = 0
        playerImage.alpha = 0.5
        
        //create path for player dot
        circlePath.addArcWithCenter(CGPointMake(CGRectGetMidX(circleBounds), CGRectGetMidY(circleBounds)),
            radius: CGRectGetWidth(circleBounds)/2,
            startAngle: circleStartAngle,
            endAngle: circleEndAngle,
            clockwise: true)
        
        
       // initialize the bottom icon array with shapes
        // each shape has a init fun that loads imageView
        icons = [ Triangle(), Square(),Pentagon(),Hexagon(),Octagon()]
         //loop through the array and
        for var i = 0; i < icons.count; ++i {
            icons[i].imageView.tag = i
//            print(icons[i].imageView.tag)
            //1. set location
            icons[i].imageView.frame = CGRect(x: 10 + 70*i, y: 570, width: 65, height: 65)
            //2. add to view
            view.addSubview(icons[i].imageView)
            //3. associate  target action
            let  panGRec = UIPanGestureRecognizer()
            icons[i].imageView.addGestureRecognizer(panGRec)
            panGRec.addTarget(self, action: "didPanShape:")
            //4. enable use interaction.
            icons[i].imageView.userInteractionEnabled = true

            
        }
        

          print("exit viewDidLoad")
        
    }
    
    
    func tick(){
       // print( self.ticCounter)

        //loop through shapes
        var ifAnimate = false
        
        if(shapes.count > 0 ){
            for shape in shapes {
                //ifAnimate turns to true, if any one shape has a note in the tic
                ifAnimate = ifAnimate || shape.play(self.ticCounter)
            }
            
        }
        
        if(ifAnimate){
            animatePlayer()
        }
        
        //ticCounter loops through 0-15
        self.ticCounter++
        if(self.ticCounter >= self.ticSlots.count){
            self.ticCounter = 0
        }
        
        
    }
    
    //you cant stop the timer if it's already stopped because your app will crash.
    @IBAction func onClickPlayButton(sender: AnyObject) {
        
        //if currently running
        if ( timer.valid){
                timer.invalidate()
            playButton.setTitle("PLAY", forState: UIControlState.Normal)
            print ("stop timer" )
            let playImage = UIImage(named: "play.png")
            playButton.setImage(playImage, forState: UIControlState.Normal)
            view.bringSubviewToFront(playButton)
                
            //PLAYER LOOP 
            playerUIView.layer.removeAllAnimations()
            playerUIView.alpha = 0
            
            
        } //if currently paused, clicking this button will start the timer
        
        else {
              //create the timer & add the timer automatically to the NSRunLoop
           timer = NSTimer.scheduledTimerWithTimeInterval(TIMER_INTERVAL, target: self, selector: "tick", userInfo: ticSlots as? AnyObject, repeats: true)
            playButton.setTitle("PAUSE", forState: UIControlState.Normal)
            print ("start timer" )
            
            let pauseImage = UIImage(named: "pause.png")
            playButton.setImage(pauseImage, forState: UIControlState.Normal)
            view.bringSubviewToFront(playButton)
            
            //PLAYER LOOP 
            playerUIView.alpha = 1
            //choose animation path
            anim.path = circlePath.CGPath
            
            //set some more parameters for the animation
            anim.repeatCount = Float.infinity
            anim.duration = LOOP_PERIOD
            
            //add animation to square layer
            playerUIView.layer.addAnimation(anim, forKey: "animate position along path")
        }
        
//        print("timer" , timer.valid)
    }
    
    
 
    //drag and drop
    
    @IBAction func didPanShape(sender: UIPanGestureRecognizer) {
        
        let translation = sender.translationInView(view)
        
        //if user starts dragging shape
        if sender.state == UIGestureRecognizerState.Began {
//            print("began")
            
            let newShape = sender.view as! UIImageView
            
         //   print(sender.description)
            
            newlyCreatedShape = UIImageView(image: newShape.image)
            
            view.addSubview(newlyCreatedShape)
            
            self.newlyCreatedShape.transform = CGAffineTransformMakeScale(0.3, 0.3)
            
            newlyCreatedShape.center = newShape.center
            
            newShape.userInteractionEnabled = true
            
            newlyCreatedShape.userInteractionEnabled = true
            
            newlyCreatedShapeOriginalCenter = newlyCreatedShape.center
            newlyCreatedShapeMenuCenter = newlyCreatedShapeOriginalCenter
            
            UIImageView.animateWithDuration(0.2, animations: { () -> Void in
                self.newlyCreatedShape.transform = CGAffineTransformMakeScale(0.5, 0.5)
                
                let panGestureRecognizerCanvas = UIPanGestureRecognizer(target: self, action: "didPanShapeCanvas:")
                self.newlyCreatedShape.addGestureRecognizer(panGestureRecognizerCanvas)
                panGestureRecognizerCanvas.delegate = self
                
                let rotationGestureRecognizerCanvas = UIRotationGestureRecognizer(target: self, action: "didRotateShapeCanvas:")
                self.newlyCreatedShape.addGestureRecognizer(rotationGestureRecognizerCanvas)
                rotationGestureRecognizerCanvas.delegate = self
                
            })
            
        }
        
        else if sender.state == UIGestureRecognizerState.Changed {

            //translate shape as newly created shape is dragged
            newlyCreatedShape.center = CGPoint(x: newlyCreatedShapeOriginalCenter.x + translation.x, y: newlyCreatedShapeOriginalCenter.y + translation.y)
            
        }
            
        else if sender.state == UIGestureRecognizerState.Ended {
            
            //move shape back to selection menu
            if newlyCreatedShape.center.y >= view.center.y {
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    
                    self.newlyCreatedShape.center = self.newlyCreatedShapeOriginalCenter
                    self.newlyCreatedShape.transform = CGAffineTransformMakeScale(0.2, 0.2)
                    

                    
                    }, completion: { (Bool) -> Void in
                        self.newlyCreatedShape.removeFromSuperview()
                })
                
            }
                
            //move shape into loop
            else {
                UIImageView.animateWithDuration(0.2, animations: { () -> Void in
                    self.newlyCreatedShape.transform = CGAffineTransformMakeScale(1, 1)
                    //translate to center of loopView
                    self.newlyCreatedShape.center = self.loopView.center
                    
                    //add to the shape queue
                    if let tag = sender.view?.tag {
                        
                    }

                })
                
            }
            
        }
        
    }
    
    //ROTATE SHAPE ALREADY IN LOOP
    
    func didRotateShapeCanvas(rotationGestureRecognizerCanvas: UIRotationGestureRecognizer)
    
    {
        let rotationRadians = rotationGestureRecognizerCanvas.rotation
        var alpha = CGFloat!()
        
        if rotationGestureRecognizerCanvas.state == UIGestureRecognizerState.Began {
            
            newlyCreatedShape = rotationGestureRecognizerCanvas.view as! UIImageView
            
            // set the initial center point
            newlyCreatedShapeOriginalCenter = newlyCreatedShape.center
            
            // bring the newlyCreatedShape imageview to the front
            newlyCreatedShape.superview?.bringSubviewToFront(view)
            
        } else if rotationGestureRecognizerCanvas.state == UIGestureRecognizerState.Changed {

            let previousTransform = newlyCreatedShape.transform
            
            newlyCreatedShape.transform = CGAffineTransformMakeRotation(rotationRadians)
            
        } else if rotationGestureRecognizerCanvas.state == UIGestureRecognizerState.Ended {
            
            
            
            print("\(rotationRadians)")
            
            alpha = rotationRadians / (2 * CGFloat(M_PI) / 16)
            alpha = round(alpha)
            print("\(alpha)")
            newlyCreatedShape.transform = CGAffineTransformMakeRotation(alpha * CGFloat(M_PI) / 8)
            
        }
        
        
    }
    
//MOVE SHAPE ALREADY IN LOOP
    
    func didPanShapeCanvas(panGestureRecognizerCanvas: UIPanGestureRecognizer)
        
    {
        // Get the translation from the pan gesture recognizer
        let translation = panGestureRecognizerCanvas.translationInView(view)
        
        // The moment the gesture starts...
        if panGestureRecognizerCanvas.state == UIGestureRecognizerState.Began {
            
            // reference the ImageView that recieved the gesture (the face you panned) and store it in newlyCreatedShape
            newlyCreatedShape = panGestureRecognizerCanvas.view as! UIImageView
            
            // set the initial center point
            newlyCreatedShapeOriginalCenter = newlyCreatedShape.center
            
            // bring the newlyCreatedShape imageview to the front
            newlyCreatedShape.superview?.bringSubviewToFront(view)
            
            // while the user is in the process of panning. (called continuously as user pans)
        } else if panGestureRecognizerCanvas.state == UIGestureRecognizerState.Changed {
            UIImageView.animateWithDuration(0.2, animations: { () -> Void in
                self.newlyCreatedShape.transform = CGAffineTransformMakeScale(0.5, 0.5)
                })
            
            // move the face with the pan
            newlyCreatedShape.center = CGPoint(x: newlyCreatedShapeOriginalCenter.x + translation.x, y: newlyCreatedShapeOriginalCenter.y + translation.y)
            
            // When the user has stopped panning
        } else if panGestureRecognizerCanvas.state == UIGestureRecognizerState.Ended {
            if newlyCreatedShape.center.y >= view.center.y {
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    
                    self.newlyCreatedShape.center = self.newlyCreatedShapeMenuCenter
                    self.newlyCreatedShape.transform = CGAffineTransformMakeScale(0.2, 0.2)
                    
                    }, completion: { (Bool) -> Void in
                        self.newlyCreatedShape.removeFromSuperview()
                        //delete the last one in shapes list 
                        //this is a hack. since we dont know the index of the shape being activated : /
                       // self.shapes.removeLast()
                })
                
            }
                
                //move shape into loop
                
            else {
                UIImageView.animateWithDuration(0.2, animations: { () -> Void in
                    self.newlyCreatedShape.transform = CGAffineTransformMakeScale(1, 1)
                    
                    //translate to center of loopView
                    self.newlyCreatedShape.center = self.loopView.center
                })
            }
        }
    }
    
    func moveShape() {
        
    }
    
    func animatePlayer() {
    
        //animate dot player when a beat is there - this should be in an if statement
        UIView.animateWithDuration(0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options:[] , animations: { () -> Void in
            self.playerUIView.transform = CGAffineTransformMakeScale(2, 2)
            }, completion: { (Bool) -> Void in
        })
        
        UIView.animateWithDuration(0.1) { () -> Void in
            self.playerUIView.transform = CGAffineTransformMakeScale(1, 1)
            
        }

        
        
    }
    
    // This function is necessary to have mutliple gesture recognizers work simultaneously.
    func gestureRecognizer(_: UIGestureRecognizer,shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool {
        return true
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


