//
//  loopViewController.swift
//  algorhythm
//
//  Created by Xu, Cheng on 11/14/15.
//  Copyright © 2015 sansserif. All rights reserved.
//

import UIKit
import AVFoundation

let TOTAL_TIME_SLOTS = 16


class loopViewController: UIViewController , AVAudioPlayerDelegate, UIGestureRecognizerDelegate {
    
    
    //// basic structure
    var audioPlayer : AVAudioPlayer!
    var newPlayer : AVAudioPlayer! //has to be declared here..
    var ticSlots = [AVAudioPlayer?](count:TOTAL_TIME_SLOTS, repeatedValue: nil)
    var ticCounter = 0
    var timer      = NSTimer()
    //shapes for  the music queue
    var shapes = [ShapeView]()
    var icons = [ShapeView]()

   
    //// graphical UI
    @IBOutlet weak var playButton: UIButton!
//    @IBOutlet weak var playButtonView: UIView!
    
    var rainbowView: UIView!

    var loopView : UIImageView!
    
    var playImage : UIImageView?
    var pauseImage : UIImageView?
    
    @IBOutlet weak var playerUIView : UIView!
    
    //the path for the dot and the loop
    var  circlePath = UIBezierPath()
    var circleRadius : CGFloat!
    var circleCenterX : CGFloat!
    var circleCenterY: CGFloat!
    
    var ticksView: UIView!
    
    //drag and drop
    var newlyCreatedShape: ShapeView!
    var rotationRadians = CGFloat!()
    var previousRotationState = CGFloat(0)


//    @IBOutlet weak var debugLabel: UILabel!
    
    /// audio effects
    var SFXDict  = [String: AVAudioPlayer]()

    
    ////TIMING & ANIMATION
//slow speed for debugging
//    let TIMER_INTERVAL =  60.0/4.0/10.0
//        let LOOP_PERIOD = 60.0/4.0/10.0 * 16

        //BPM 75 : 60.0/75.0/4.0
    //    var LOOP_PERIOD : Float!
    let TIMER_INTERVAL =  60.0/200.0
    let LOOP_PERIOD = 60.0/200.0 * 16
    

    //initialize animnation
    let anim = CAKeyframeAnimation(keyPath: "position")
    
    
    override func viewDidLoad() {
    
        super.viewDidLoad()

        prepareUI()
        prepareAudio()
        
    }
    
    
    func prepareUI(){
        
        let screenWidth = self.view.frame.size.width
        let screenHeight = self.view.frame.size.height
        
         circleRadius = CGFloat(150.0)
         circleCenterX =  screenWidth/2.0
         circleCenterY = circleRadius + CGFloat(80.0) //offset from top
        let circleBounds = CGRectMake (circleCenterX - circleRadius ,circleCenterY - circleRadius, CGFloat(circleRadius*2), CGFloat(circleRadius*2)  )

        let iconTrayLeading = CGFloat (12)
        let iconTrayTailing = iconTrayLeading
        let iconGap = CGFloat (4)
        let iconWidth = (screenWidth - iconTrayLeading-iconTrayTailing )/5 - iconGap //this is only for the 5 icon scenario
        
        let iconTrayY = screenHeight - iconWidth * 1.5  // CGFloat (570)
        
        //initialize path bounds
        let circleStartAngle = CGFloat(-90.0 * M_PI/180)
        let circleEndAngle = CGFloat(270 * M_PI/180)
        //create path for player dot
        circlePath.addArcWithCenter(CGPointMake(CGRectGetMidX(circleBounds), CGRectGetMidY(circleBounds)),
            radius: CGRectGetWidth(circleBounds)/2,
            startAngle: circleStartAngle,
            endAngle: circleEndAngle,
            clockwise: true)
        
        
        //draw the loop
        loopView = UIImageView()
        loopView.frame = circleBounds
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.CGPath
        shapeLayer.fillColor = UIColor.whiteColor().CGColor
        shapeLayer.strokeColor = UIColor.lightGrayColor().CGColor
        shapeLayer.lineWidth = 2.0
        view.layer.addSublayer(shapeLayer)
        // debugging image
        //        let loopImageName = "loopTest.png"
        //        let loopImage = UIImage(named: loopImageName)
        //        loopView = UIImageView(image: loopImage!)
        
        
        //prepare ticks
        ticksView = UIView(frame: circleBounds)
//        ticksView.backgroundColor = UIColor.yellowColor()
        view.addSubview(ticksView)
        ticksView.alpha = 0
        
        //draw ticks
        for var i = 0; i < TOTAL_TIME_SLOTS; ++i {

            let tickCenter : CGPoint!
            tickCenter = Common.calCoordinateFromIndex(CGPointMake(circleRadius, circleRadius), r: circleRadius, i: i)
            //print("index \(i) .x \(tickPosition.x) .y \(tickPosition.y)")
          
            var singleTick: UIView!
            singleTick = UIView(frame: CGRect(x: 0, y: 0, width: 6, height: 6))
//            singleTick.backgroundColor = UIColor.greenColor()
            singleTick.center = tickCenter
            ticksView.addSubview(singleTick)
            
            let tickPath = UIBezierPath ()
            tickPath.addArcWithCenter((tickCenter),
                radius: CGFloat(3.0),
                startAngle:0,
                endAngle: CGFloat(M_PI*2.0),
                clockwise: true     )
            
            let tickLayer = CAShapeLayer()
            tickLayer.path = tickPath.CGPath
            tickLayer.fillColor = UIColor.grayColor().CGColor
            ticksView.layer.addSublayer(tickLayer)
            
            
        }
        
        
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
        playerLayer.fillColor = UIColor.grayColor().CGColor
        playerLayer.strokeColor = UIColor.clearColor().CGColor
        playerLayer.lineWidth = 2.0
        playerUIView.layer.addSublayer(playerLayer)
        
        // this put the player dot in the front of the circle!
        view.bringSubviewToFront(playerUIView)
        
        //player button
        playImage = UIImageView(image: UIImage(named: "play.png")!)
        pauseImage = UIImageView(image: UIImage(named: "pause.png")!)
        let buttonDiameter = CGFloat (60)  //have to match size of play.png!!!
        let buttonRadius = buttonDiameter/2.0

        
        playButton.frame = CGRect (x: circleCenterX - buttonRadius,y: circleCenterY - buttonRadius, width: 60,height: 60)
        playButton.setImage(playImage!.image, forState: UIControlState.Normal)
//        view.addSubview(playButton)
        self.view.bringSubviewToFront(self.playButton)
        
        /// initialize the bottom icon array with shapes
        for var i = 0; i < 5 ; ++i {
            //build icon list on the bottom
            var verticesCnt = i+3
            if (i == 4) {verticesCnt = 8 }
            let iconView = ShapeView(frame: CGRect(x: iconTrayLeading + (iconWidth + iconGap)*CGFloat(i), y: iconTrayY, width: iconWidth, height: iconWidth) , numVertices: verticesCnt, sound: i )
            
            //3. associate  target action
            let  panGRec = UIPanGestureRecognizer()
            //            icons[i].imageView.addGestureRecognizer(panGRec)
            iconView.addGestureRecognizer(panGRec)
            panGRec.addTarget(self, action: "didPanIcon:")
            
            let longPressGRec = UILongPressGestureRecognizer(target: self, action: "onLongPressIcon:")
            longPressGRec.minimumPressDuration = 0.5
            iconView.addGestureRecognizer(longPressGRec)
            
            
            //4. enable use interaction.
            iconView.userInteractionEnabled = true
            
            icons.append(iconView)
            view.addSubview(iconView)
        }

        
    }

    
    func tick(){
       // print( self.ticCounter)
        //loop through shapes
        var ifAnimate = false

        //if there is a shape in the loop
        if(shapes.count > 0 ){
//            for shape in shapes {
            for var i = 0; i < shapes.count; ++i {
                if (i > shapes.count - 20 ){ //This is a hack - if too many shapes at the same positon, then only play the last 20 //TODO double check if this assumption is still valid
               // print ("index \(self.ticCounter) shape \(shape.fileName)")
                //ifAnimate turns to true, if any one shape has a note in the tic
//                 ifAnimate = ( shape.play(self.ticCounter)) || ifAnimate
                 ifAnimate = ( shapes[i].play(self.ticCounter)) || ifAnimate
                }
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
    
    
    //longpress on the icons. show different options of instruments.
    func onLongPressIcon(sender: UILongPressGestureRecognizer) {
        let iconView = sender.view as! ShapeView
        var iconColor : UIColor!
        var soundInd : Int!
        var newColor : UIColor!
        
        soundInd = iconView.soundIndex
        iconColor = iconView.soundDict[soundInd]!["color"]! as! UIColor
    
        if sender.state == UIGestureRecognizerState.Began {
           
       // bring the  imageview to the front
            view.insertSubview(iconView, aboveSubview: loopView)

            rainbowView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
            
            self.rainbowView.backgroundColor = iconColor
            self.view.addSubview(self.rainbowView)
            self.rainbowView.alpha = 0

//            print("rainbow start ")
            UIView.animateWithDuration(0.6,
                    delay: 0,
                    options: UIViewAnimationOptions.CurveEaseIn,
                    animations: {
                        iconView.transform = CGAffineTransformMakeScale (35,35)
                        self.rainbowView.alpha = 0.95
                        iconView.alpha = 0
                    },
                    completion: { (Bool) -> Void in
                        

                })
//            print("long press \(v.soundIndex)")
            
        }else if sender.state == UIGestureRecognizerState.Changed {
            
            let loc = sender.locationInView(rainbowView)
//            let spd = sender.velocityInView(rainbowView)//todo implement speeD?
            let soundDictSize = iconView.soundDict.count
            //currentIndex in choice
            var currentInd = Int (floor ((loc.y - iconView.iconFrame.minY)/100))
            currentInd = (soundInd + currentInd) % soundDictSize
            
            if (currentInd < 0 ) { currentInd = currentInd + soundDictSize }
//            print("stored index \(iconView.nextSoundIndex ) new index \(currentInd)")
            
            //if the finger touched area has changed
            if (iconView.nextSoundIndex != currentInd ) {
                
                newColor = iconView.soundDict[currentInd]!["color"]! as! UIColor
                UIView.animateWithDuration(0.5,
                    delay: 0,
                    options: UIViewAnimationOptions.CurveEaseInOut,
                    animations: {
                        self.rainbowView.backgroundColor = newColor
                        
                    },
                    completion: { (Bool) -> Void in
                       iconView.nextSoundIndex = currentInd
//                       print ("changed and playing \(currentInd)")
                       //play sound
                       self.SFXDict[String(currentInd)]!.play()
                })
            }
            
        }else if ( sender.state == UIGestureRecognizerState.Ended
            || sender.state == UIGestureRecognizerState.Cancelled
            || sender.state == UIGestureRecognizerState.Failed)
        {
//            print ("exiting  newInd \(newInd)  soundInd \(soundInd) iconView next \(iconView.nextSoundIndex )")
            //if a new color is chosen, update the shape
            if (iconView.nextSoundIndex != soundInd  ){
                iconView.soundIndex = iconView.nextSoundIndex
                iconView.updateAudio()
            }
            
//            print("zoomout start ")
            UIView.animateWithDuration(0.5,
                delay: 0,
                options: UIViewAnimationOptions.CurveEaseIn,
                animations: {
                    //scaling to 0 would NOT WORK!
//                    self.rainbowView.transform = CGAffineTransformMakeScale (0.01,0.01)
                    iconView.alpha = 0.95
                    iconView.transform = CGAffineTransformMakeScale (1,1)
                    self.rainbowView.alpha = 0
                    
                },
                completion: { (Bool) -> Void in
//                   print("zoomout end")
                    self.rainbowView.removeFromSuperview()
            })
     
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
            
            playButton.setImage(pauseImage!.image, forState: UIControlState.Normal)
            
            
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
   
   
    //drag from icon tray up &  drop into loopview
    @IBAction func didPanIcon(sender: UIPanGestureRecognizer) {
        
        let translation = sender.translationInView(view)
        let velocity = sender.velocityInView(view)
        
        //if user starts dragging shape
        if sender.state == UIGestureRecognizerState.Began {

            let draggedIconView = sender.view as! ShapeView
            //copy the icon
            newlyCreatedShape = ShapeView(frame: sender.view!.frame, numVertices: draggedIconView.numVertices, sound: draggedIconView.soundIndex )
            newlyCreatedShape.alpha = 0.7

            //bring player button to the top
            self.view.insertSubview(newlyCreatedShape, belowSubview: self.playerUIView)
            
            newlyCreatedShape.userInteractionEnabled = true
            
            //enlarge the image to react to the press down
            UIImageView.animateWithDuration(0.2, animations: { () -> Void in
                self.newlyCreatedShape.transform = CGAffineTransformMakeScale(2, 2)
                
                }, completion: { (Bool) -> Void in

            })
            
        }
        
        else if sender.state == UIGestureRecognizerState.Changed {

            //translate shape as newly created shape is dragged
            newlyCreatedShape.center = CGPoint(x: newlyCreatedShape.iconCenter.x + translation.x , y: newlyCreatedShape.iconCenter.y + translation.y)
            
        }
            
        else if sender.state == UIGestureRecognizerState.Ended {
            
            
            ///CANCEL : move shape back to selection menu
            if velocity.y >=  -0.1    {

                
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    
                    self.newlyCreatedShape.center = self.newlyCreatedShape.iconCenter
                    self.newlyCreatedShape.transform = CGAffineTransformMakeScale(0.01, 0.01)

                    }, completion: { (Bool) -> Void in
                        self.newlyCreatedShape.removeFromSuperview()
                })
            }
                
            ///add  new  shape into loop
            else {
        
                
                self.newlyCreatedShape.transform = CGAffineTransformMakeScale(1, 1)
                let newO = CGPoint (x: self.circleCenterX, y: self.circleCenterY)
                self.newlyCreatedShape.updatePosition(newO, newR: self.circleRadius)
                self.newlyCreatedShape.center = newO
//
                //enabling editing of the vertex. TODO add snapping & constraint
                //  self.newlyCreatedShape.enableAnchorLongPress()
                
                let panGestureRecognizerCanvas = UIPanGestureRecognizer(target: self, action: "didPanShapeCanvas:")
                panGestureRecognizerCanvas.delegate = self
                panGestureRecognizerCanvas.maximumNumberOfTouches = 1
                panGestureRecognizerCanvas.minimumNumberOfTouches = 1
                self.newlyCreatedShape.addGestureRecognizer(panGestureRecognizerCanvas)
                
                let rotationGestureRecognizerCanvas = UIRotationGestureRecognizer(target: self, action: "didRotateShapeCanvas:")
                self.newlyCreatedShape.addGestureRecognizer(rotationGestureRecognizerCanvas)
                rotationGestureRecognizerCanvas.delegate = self

                
                
                self.shapes.append(self.newlyCreatedShape)
//                print("list size \(self.shapes.count) added one more ")


                SFXDict["place"]!.play()
                
            }
        }
    }
    
    //MOVE SHAPE ALREADY IN LOOP
    //pan shape that is already on loop
    func didPanShapeCanvas(panGestureRecognizerCanvas: UIPanGestureRecognizer){
        
        let pannedShape = panGestureRecognizerCanvas.view as! ShapeView
        
        let location = panGestureRecognizerCanvas.locationInView(view)
        
        // The moment the gesture starts...
        if panGestureRecognizerCanvas.state == UIGestureRecognizerState.Began {
            
            pannedShape.superview?.bringSubviewToFront(view)
            
        } else if panGestureRecognizerCanvas.state == UIGestureRecognizerState.Changed {
            UIImageView.animateWithDuration(0.2, animations: { () -> Void in
                pannedShape.transform = CGAffineTransformMakeScale(0.8, 0.8)
                pannedShape.alpha = 1
            })
            
            pannedShape.center = location
            
            // When the user has stopped panning
///            cheng
        } else if panGestureRecognizerCanvas.state == UIGestureRecognizerState.Ended {

            var isOutOfCircle = false
            if ( Common.dist (CGPoint(x: self.circleCenterX, y: self.circleCenterY), b: location ) > self.circleRadius ){
                isOutOfCircle = true
            }
            
            if ((pannedShape.center.y >= view.center.y ) || isOutOfCircle ) {
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                   
                    //return to the location of the original icon
                    pannedShape.frame = pannedShape.iconFrame
                    
                    }, completion: { (Bool) -> Void in
                        
                        //delete the last one in shapes list
                        //this is a hack. since we dont know the index of the shape being activated : /
                        self.shapes.removeLast()
                        self.SFXDict["remove"]!.play()
                     //   print("list size \(self.shapes.count) removed last ")
                    
                        
                        pannedShape.removeFromSuperview()
                })
                
            }
            
                //return shape into loop
            else {
                UIImageView.animateWithDuration(0.2, animations: { () -> Void in
                    pannedShape.transform = CGAffineTransformMakeScale(1, 1)
                    
                    //translate to center of loopView
                    pannedShape.center = self.loopView.center
                    pannedShape.alpha = 0.7
                })
            }
        }
    }
    
    
    
    //ROTATE SHAPE ALREADY IN LOOP
    func didRotateShapeCanvas(rotationGestureRecognizerCanvas: UIRotationGestureRecognizer)
        
    {
        let  currentShape = rotationGestureRecognizerCanvas.view as! ShapeView
        let rotationRadians = rotationGestureRecognizerCanvas.rotation //always start from zero

       
        if rotationGestureRecognizerCanvas.state == UIGestureRecognizerState.Began {
            currentShape.alpha = 0.95
            showTicks()
        }
        else if rotationGestureRecognizerCanvas.state == UIGestureRecognizerState.Changed {
            
            currentShape.transform = CGAffineTransformMakeRotation(rotationRadians)

        }
        //when released, record the change in the shapeView class
        else if rotationGestureRecognizerCanvas.state == UIGestureRecognizerState.Ended {
            
            
            var rotationTick = rotationRadians / (2 * CGFloat(M_PI) / 16)
            rotationTick = round(rotationTick)
            
            //snap to the nearest
            UIImageView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                currentShape.transform = CGAffineTransformMakeRotation( (rotationTick) * CGFloat( M_PI) / 8 )
            }, completion: nil )
            
            //record final position to ShapeView
//            print("turned \(Int(rotationTick))")


            if ( self.shapes.count > 0){
//                   print( self.shapes.last!.currentVerticeIndex)
                self.shapes.last!.turn(Int(rotationTick))
//                 print( self.shapes.last!.currentVerticeIndex)
            }
            
            
            //now that new shape is in position, we dont need this transform any more
            currentShape.transform = CGAffineTransformMakeRotation( 0) //no long need the transform on the old shape. new geometry is at right place!
            currentShape.alpha = 0.7
            
            hideTicks()

        }
    }
    
    func showTicks() {
        ticksView.alpha = 1

        
    }
    
    func hideTicks() {
        ticksView.alpha = 0

        
    }

    func animatePlayer() {
        //animate dot player when a beat is there
        UIView.animateWithDuration(0, delay: 0 , usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options:[] , animations: { () -> Void in
            self.playerUIView.transform = CGAffineTransformMakeScale(1.4, 1.4)
//            self.loopView.transform = CGAffineTransformMakeScale(0.9, 0.9)
            }, completion: { (Bool) -> Void in
        })
        
        UIView.animateWithDuration(0.1) { () -> Void in
            self.playerUIView.transform = CGAffineTransformMakeScale(1, 1)
//            self.loopView.transform = CGAffineTransformMakeScale(1, 1)
        }
    }
 
    
    func prepareAudio(){
        SFXDict["place"] = prepareAVAudioPlayer("splits",fileType: "mp3")
        SFXDict["remove"] = prepareAVAudioPlayer("suspension",fileType: "mp3")
        
        let tempShapeView = ShapeView(frame: CGRectMake(0, 0, 0, 0), numVertices: 0, sound: 0)
        for var i = 0 ; i < tempShapeView.soundDict.count; ++i {
            SFXDict[String(i)] = prepareAVAudioPlayer( tempShapeView.soundDict[i]!["name"]! as! String, fileType: tempShapeView.soundDict[i]!["extention"]! as! String )
        }
    }
    
    func prepareAVAudioPlayer(fileName: String, fileType: String) -> AVAudioPlayer {
        let path = NSBundle.mainBundle().pathForResource(fileName, ofType: fileType)
        let fileURL = NSURL.fileURLWithPath(path!)
        let tempPlayer = try! AVAudioPlayer(contentsOfURL: fileURL)
        tempPlayer.delegate = self
        tempPlayer.prepareToPlay()
        return tempPlayer
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
}


