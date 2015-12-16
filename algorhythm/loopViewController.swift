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
    
    
    //// basic structure
    var audioPlayer : AVAudioPlayer!
    var newPlayer : AVAudioPlayer! //has to be declared here..
    var ticSlots = [AVAudioPlayer?](count:16, repeatedValue: nil)
    var ticCounter = 0
    var timer      = NSTimer()
    //shapes for  the music queue
    var shapes = [Shape]()
    //icons array on the bottom
    var icons = [Shape]()

    
    
    //// graphical UI
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var playButtonView: UIView!

    var loopView : UIImageView!
    
    var playImage : UIImageView?
    
    
    let pauseImage = UIImageView(image: UIImage(named: "pause.png")!)
    
    
    
    @IBOutlet weak var playerUIView : UIView!
    
    //the path for the dot and the loop
    var  circlePath = UIBezierPath()

    
    //drag and drop
    //JANAK this is always pointing to the same last created shape, hence 
    // the bug of shapes always returning to the same postion
    var newlyCreatedShape: UIImageView!
    var shapeInitialCenter: CGPoint!
    var newlyCreatedShapeOriginalCenter: CGPoint!
    var newlyCreatedShapeMenuCenter: CGPoint!
    
    @IBOutlet weak var debugLabel: UILabel!
    
    
    ////TIMING & ANIMATION
//slow speed for debugging
//    let TIMER_INTERVAL =  60.0/4.0/10.0
//        let LOOP_PERIOD = 60.0/4.0/10.0 * 16

        //BPM 75 : 60.0/75.0/4.0
    //    var LOOP_PERIOD : Float!
    let TIMER_INTERVAL =  60.0/300.0 
    let LOOP_PERIOD = 60.0/300.0 * 16
    

    //initialize animnation
    let anim = CAKeyframeAnimation(keyPath: "position")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //draw players
        prepareUI()
        
        
       // initialize the bottom icon array with shapes
        // each shape has a init fun that loads imageView
        icons = [ Triangle(), Square(),Pentagon(),Hexagon(),Octagon()]

//         icons = [ Triangle(), Square(), Pentagon(), Hexagon()]
        //loop through the array and
        for var i = 0; i < icons.count; ++i {
            icons[i].imageView.tag = i
//            print(icons[i].imageView.tag)
            //1. set location
            icons[i].imageView.frame = CGRect(x: 11 + 70*i, y: 570, width: 65, height: 65)
            //2. add to view
            view.addSubview(icons[i].imageView)
            //3. associate  target action
            let  panGRec = UIPanGestureRecognizer()
            icons[i].imageView.addGestureRecognizer(panGRec)
            panGRec.addTarget(self, action: "didPanShape:")
            //4. enable use interaction.
            icons[i].imageView.userInteractionEnabled = true

            
        }
        
    }
    
    
    func prepareUI(){
        
        ///initialize path bounds
        let circleStartAngle = CGFloat(-90.0 * M_PI/180)
        let circleEndAngle = CGFloat(270 * M_PI/180)
        
        let screenWidth = self.view.frame.size.width
        let circleRadius = CGFloat(150.0)
        let circleCenterX =  screenWidth/2.0
        let circleCenterY = circleRadius + CGFloat(80.0) //offset from top
        let circleBounds = CGRectMake (circleCenterX - circleRadius ,circleCenterY - circleRadius, CGFloat(circleRadius*2), CGFloat(circleRadius*2)  )
        //create path for player dot
        circlePath.addArcWithCenter(CGPointMake(CGRectGetMidX(circleBounds), CGRectGetMidY(circleBounds)),
            radius: CGRectGetWidth(circleBounds)/2,
            startAngle: circleStartAngle,
            endAngle: circleEndAngle,
            clockwise: true)
        
        
        //draw the loop
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.CGPath
        shapeLayer.fillColor = UIColor.clearColor().CGColor
        shapeLayer.strokeColor = UIColor.grayColor().CGColor
        shapeLayer.lineWidth = 2.0
        view.layer.addSublayer(shapeLayer)
        // debugging image
        //        let loopImageName = "loopTest.png"
        //        let loopImage = UIImage(named: loopImageName)
        //        loopView = UIImageView(image: loopImage!)
        
        loopView = UIImageView()
        loopView.frame = circleBounds
        
        
        //draw the player dot
        //initialize view size and position
        let playerRadius = CGFloat (15.0)
        let playerDiameter = playerRadius * 2.0
        //initial location
        playerUIView.frame = CGRect(x: circleCenterX - playerRadius, y: circleCenterY - playerRadius - circleRadius  , width: playerDiameter, height: playerDiameter)
        playerUIView.alpha = 1
        
        let playerPath = UIBezierPath ()
        playerPath.addArcWithCenter( CGPointMake( playerRadius  , playerRadius ),
            radius: CGFloat(15.0),
            startAngle:0,
            endAngle: CGFloat(M_PI*2.0),
            clockwise: true     )
        
        let playerLayer = CAShapeLayer()
        playerLayer.path = playerPath.CGPath
        playerLayer.fillColor = UIColor.blackColor().CGColor
        playerLayer.strokeColor = UIColor.clearColor().CGColor
        playerLayer.lineWidth = 2.0
        playerUIView.layer.addSublayer(playerLayer)
        
        // this put the player dot in the front of the circle!
        view.bringSubviewToFront(playerUIView)
        
        
        //player button
         playImage = UIImageView(image: UIImage(named: "play.png")!)
//        playImage!.frame = CGRectMake (0,0,60,60)
//        self.view.addSubview(playImage!)
        
        let buttonDiameter = CGFloat (60)
//        let buttonDiameter = playImage.size.width
//        print（ "size \(buttonDiameter)")
        let buttonRadius = buttonDiameter/2.0
//        playButtonView.frame = CGRectMake(0 , 0,
//            buttonDiameter,  buttonDiameter)
///        playButtonView.frame = CGRectMake(circleCenterX - buttonRadius, circleCenterY - buttonRadius,
//            buttonDiameter,  buttonDiameter)
//        var image : UIImage = UIImage(named:"play.png")!
//        
        
        playButton.frame = CGRect (x: circleCenterX - buttonRadius,y: circleCenterY - buttonRadius, width: 60,height: 60)
        playButton.setImage(playImage!.image, forState: UIControlState.Normal)
//        view.addSubview(playButton)
        self.view.bringSubviewToFront(self.playButton)
        
        
    }

    @IBAction func addOne(sender: AnyObject) {
        
    }
    
    func tick(){
       // print( self.ticCounter)
        //for debugging
        
        debugLabel.text = String(self.ticCounter)
        
        //loop through shapes
        var ifAnimate = false

        //if there is a shape in the loop
        if(shapes.count > 0 ){
            for shape in shapes {
               // print ("index \(self.ticCounter) shape \(shape.fileName)")
                //ifAnimate turns to true, if any one shape has a note in the tic
//               ifAnimate = ifAnimate || shape.play(self.ticCounter) // this doesnt work
                 ifAnimate = ( shape.play(self.ticCounter)) || ifAnimate

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
    //TODO the circling of player dot stops if we exit and come back
    
    //you cant stop the timer if it's already stopped because your app will crash.
    @IBAction func onClickPlayButton(sender: AnyObject) {
        
        //if currently running
        if ( timer.valid){
                timer.invalidate()
            //playButton.setTitle("PLAY", forState: UIControlState.Normal)
            print ("stop timer" )
            playButton.setImage(playImage!.image, forState: UIControlState.Normal)
            
            
          
            
            //PLAYER LOOP 
            playerUIView.layer.removeAllAnimations()
         //   playerUIView.alpha = 0
            
            
        } //if currently paused, clicking this button will start the timer
        
        else {
            
            self.ticCounter = 0 ;  //reset to the start
            self.tick(); // the timer would schedule one to happen in some time,but we want one right now! 
            
              //create the timer & add the timer automatically to the NSRunLoop
           timer = NSTimer.scheduledTimerWithTimeInterval(TIMER_INTERVAL, target: self, selector: "tick", userInfo: ticSlots as? AnyObject, repeats: true)
            //playButton.setTitle("PAUSE", forState: UIControlState.Normal)
            print ("start timer" )
            
            playButton.setImage(pauseImage.image, forState: UIControlState.Normal)
            
            
            //PLAYER LOOP ----------------------------------------------------------------------------------------------------
       //     playerUIView.alpha = 1
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
        let velocity = sender.velocityInView(view)
        let location = sender.locationInView(view)
//        print(location.y)
        
        //if user starts dragging shape
        if sender.state == UIGestureRecognizerState.Began {
//            print("began")
            
            //Janak: whats newlyCreatedShape vs newShapeImageView?
            let  newShapeImageView = sender.view as! UIImageView
            
            
          //  print(sender.description)
            newlyCreatedShape = UIImageView(image: newShapeImageView.image)
            newlyCreatedShape.alpha = 0.7
//            view.addSubview(newlyCreatedShape)
            //bring player button to the top
            self.view.insertSubview(newlyCreatedShape, belowSubview: self.playerUIView)
            
            
            self.newlyCreatedShape.transform = CGAffineTransformMakeScale(0.3, 0.3)
            
            newlyCreatedShape.center = newShapeImageView.center
            
//            newShapeImageView.userInteractionEnabled = true
            
            newlyCreatedShape.userInteractionEnabled = true
            
            newlyCreatedShapeOriginalCenter = newlyCreatedShape.center
            newlyCreatedShapeMenuCenter = newlyCreatedShapeOriginalCenter
            
            
            //CALL OTHER GESTURES
            
            UIImageView.animateWithDuration(0.2, animations: { () -> Void in
                self.newlyCreatedShape.transform = CGAffineTransformMakeScale(0.5, 0.5)
                
                let panGestureRecognizerCanvas = UIPanGestureRecognizer(target: self, action: "didPanShapeCanvas:")
                panGestureRecognizerCanvas.delegate = self
                panGestureRecognizerCanvas.maximumNumberOfTouches = 1
                panGestureRecognizerCanvas.minimumNumberOfTouches = 1
                self.newlyCreatedShape.addGestureRecognizer(panGestureRecognizerCanvas)
                
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
            if velocity.y >  0    {
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    
                    self.newlyCreatedShape.center = self.newlyCreatedShapeOriginalCenter
                    self.newlyCreatedShape.transform = CGAffineTransformMakeScale(0.2, 0.2)

                    
                    }, completion: { (Bool) -> Void in
                        self.newlyCreatedShape.removeFromSuperview()
                })
                
            }
                
            //move shape into loop
            else {
//            else {
                UIImageView.animateWithDuration(0.2, animations: { () -> Void in
                    self.newlyCreatedShape.transform = CGAffineTransformMakeScale(1, 1)
                    //translate to center of loopView
                    self.newlyCreatedShape.center = self.loopView.center
                    
                    let tag = sender.view!.tag
                    
                    let klass = self.icons[tag].dynamicType.self
                    
                    self.shapes.append(klass.init())
        
                   
                    
                })
            }
        }
    }
    
    
    //pan shape that is already on loop
    func didPanShapeCanvas(panGestureRecognizerCanvas: UIPanGestureRecognizer){
        
        let location = panGestureRecognizerCanvas.locationInView(view)
        
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
            
            newlyCreatedShape.center = location
            
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
                        self.shapes.removeLast()
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
    
    
    
    //ROTATE SHAPE ALREADY IN LOOP
    
    func didRotateShapeCanvas(rotationGestureRecognizerCanvas: UIRotationGestureRecognizer)
        
    {
        
        let rotationRadians = rotationGestureRecognizerCanvas.rotation
        var alpha = CGFloat!()
        
        if rotationGestureRecognizerCanvas.state == UIGestureRecognizerState.Began {
            
            newlyCreatedShape = rotationGestureRecognizerCanvas.view as! UIImageView
//            newlyCreatedShape.multipleTouchEnabled = false ;
            
            // set the initial center point
            newlyCreatedShapeOriginalCenter = newlyCreatedShape.center
            
            
        } else if rotationGestureRecognizerCanvas.state == UIGestureRecognizerState.Changed {
            
//            let previousTransform = newlyCreatedShape.transform
            
            newlyCreatedShape.transform = CGAffineTransformMakeRotation(rotationRadians)
            
        } else if rotationGestureRecognizerCanvas.state == UIGestureRecognizerState.Ended {
            
            alpha = rotationRadians / (2 * CGFloat(M_PI) / 16)
            alpha = round(alpha)
            print("turn \(Int(alpha))")
            
            if ( self.shapes.count > 0){
                   print( self.shapes.last!.filledSlots)
                self.shapes.last!.turn(Int(alpha))
                 print( self.shapes.last!.filledSlots)
                
            }
            
            newlyCreatedShape.transform = CGAffineTransformMakeRotation(alpha * CGFloat(M_PI) / 8)
            
            
        }
        
        
    }
    
    //MOVE SHAPE ALREADY IN LOOP
    
    
    func animatePlayer() {
    
        //animate dot player when a beat is there
        UIView.animateWithDuration(0, delay: 0 , usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options:[] , animations: { () -> Void in
            self.playerUIView.transform = CGAffineTransformMakeScale(1.4, 1.4)
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


