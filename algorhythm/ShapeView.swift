//
//  ShapeView.swift
//  algorhythm
//
//  Created by Timothy Lee on 12/16/15.
//  Copyright © 2015 sansserif. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation



class ShapeView: UIView, AVAudioPlayerDelegate {
    
    
    ///visual
    var numVertices: Int!
    var defaultVerticeIndex = [Int]()
    var currentVerticeIndex = [Int]()
//    var vertices = [CGPoint]()
    //var coordinateLookupTable = [CGPoint]() //where all time slots should be
    var anchorView: UIView! //to allow all vertices to be move-able
    var anchorViewArray = [UIView]() //to allow all vertices to be move-able
    var polarOrigin : CGPoint!
    var polarRadius : CGFloat!
    
    var iconFrame : CGRect!  //location when the shape is an icon on the bottom
    var iconCenter : CGPoint!

    ///audio
    var timeArray = [AVAudioPlayer?](count:16, repeatedValue: nil)
    var soundIndex: Int!
    var nextSoundIndex: Int!
    //let swiftColor = UIColor(red: 255/255, green: 246/255, blue: 128/255, alpha: 1)
    
    //color
    //GREEN UIColor(red: 98/255, green: 163/255, blue: 126/255, alpha: 1)
    //BLUE UIColor(red: 120/255, green: 209/255, blue: 236/255, alpha: 1)
    //PURPLE rgb(155, 89, 182)
    //RED UIColor(red: 233/255, green: 117/255, blue: 126/255, alpha: 1)
    //ORANGE UIColor(red: 252/255, green: 171/255, blue: 117/255, alpha: 1)
    //YELLOW UIColor(red: 255/255, green: 246/255, blue: 128/255, alpha: 1)

    
    
    var soundDict  = [
        0: ["name":"hihat","extention":"wav","color": UIColor(red: 98/255, green: 163/255, blue: 126/255, alpha: 1)],
        1: ["name":"hihat","extention":"wav", "color": UIColor(red: 120/255, green: 209/255, blue: 236/255, alpha: 1)],
        2: ["name":"kick","extention":"wav", "color": UIColor(red: 155/255, green: 89/255, blue: 182/255, alpha: 1)],
        3: ["name":"clap","extention":"wav", "color": UIColor(red: 233/255, green: 117/255, blue: 126/255, alpha: 1)],
        4: ["name":"open_hihat","extention":"wav", "color": UIColor(red: 252/255, green: 171/255, blue: 117/255, alpha: 1)],
        5: ["name":"flash-2","extention":"mp3", "color": UIColor(red: 255/255, green: 246/255, blue: 128/255, alpha: 1)],
        
        
    ]

// original sounds
//    var soundDict  = [0: ["name":"crackle","extention":"mp3",
//        "color": UIColor(red: 98/255, green: 163/255, blue: 126/255, alpha: 1)],
//        1: ["name":"confetti","extention":"mp3", "color": UIColor(red: 120/255, green: 209/255, blue: 236/255, alpha: 1)],
//        2: ["name":"wipe","extention":"mp3", "color": UIColor(red: 155/255, green: 89/255, blue: 182/255, alpha: 1)],
//        3: ["name":"bubbles","extention":"mp3", "color": UIColor(red: 233/255, green: 117/255, blue: 126/255, alpha: 1)],
//        4: ["name":"prism-1","extention":"mp3", "color": UIColor(red: 252/255, green: 171/255, blue: 117/255, alpha: 1)],
//        5: ["name":"flash-2","extention":"mp3", "color": UIColor(red: 255/255, green: 246/255, blue: 128/255, alpha: 1)],
//        
//
//    ]

    
    
//    override init(frame: CGRect) {
    init(frame: CGRect , numVertices : Int, sound: Int) {
        super.init(frame: frame)
        self.iconFrame = frame
        self.soundIndex = sound
        self.nextSoundIndex = sound 
        self.numVertices = numVertices
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        switch (numVertices){
        case 3:
            defaultVerticeIndex = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
            break;
        case 4:
            defaultVerticeIndex = [0,2,4,6,8,10,12,14]
            break;
        case 5:
            defaultVerticeIndex = [0,7,8]
            break;
        case 6:
            defaultVerticeIndex = [2,4,10]
            break;
        case 8:
            defaultVerticeIndex = [1,3,5,7,9,11,13,15]
            break;
        default:
            print("error")
            defaultVerticeIndex = [0]
            break;
        }

//        switch (numVertices){
//        case 3:
//            defaultVerticeIndex = [0, 5, 11]
//            break;
//        case 4:
//            defaultVerticeIndex = [0,4,8,12]
//            break;
//        case 5:
//            defaultVerticeIndex = [0,3,6,10,13]
//            break;
//        case 6:
//            defaultVerticeIndex = [1,4,7,9,12,15]
//            break;
//        case 8:
//            defaultVerticeIndex = [1,3,5,7,9,11,13,15]
//            break;
//        default:
//            print("error")
//            defaultVerticeIndex = [0]
//            break;
//        }
        
        currentVerticeIndex = defaultVerticeIndex
        
        ///visual
        //calculate each vertex and add to array

        polarOrigin = CGPoint(x: frame.width/2, y:frame.height/2)
        appendAnchorPosition(polarOrigin, radius: frame.width/2) //inital icon size is small
        
        iconCenter = CGPointMake(iconFrame.origin.x + iconFrame.width/2, iconFrame.origin.y + iconFrame.height/2)
        
        backgroundColor = UIColor.clearColor()
//          backgroundColor = UIColor.magentaColor()
        
        ///audio
        //fill in the AVAudioPlayer
        fillTimeArrayWithAudio()
        
       
        
        

        
    }
    
  
    
    //called once to initialize 
    func appendAnchorPosition (origin: CGPoint , radius: CGFloat ) {
        //TODO NOTE THAT THE VERTICE IS NOT SCALING IWHT THE IAMGES!!!
        for var i = 0; i < defaultVerticeIndex.count ; ++i {
            var anchorView: UIView!
            //todo this may be wrong ?
            anchorView = UIView(frame: CGRect(x: origin.x - radius, y: origin.y - radius, width: radius * 2 , height: radius * 2 ))
            
            anchorView.backgroundColor = UIColor.clearColor()
            anchorView.center = Common.calCoordinateFromIndex(origin, r: radius , i: defaultVerticeIndex[i])
//            print("index \(i) .x \(anchorView.center.x) .y \(anchorView.center.y)")
            addSubview(anchorView)
            anchorViewArray.append(anchorView)
        }
        // Triggers drawRect
        setNeedsDisplay()
        
    }
    
    //this allows each vertex to be drag and dropped to ANY location...
    func enableAnchorLongPress(){
        for var i = 0; i < anchorViewArray.count ; ++i {
            anchorViewArray[i].userInteractionEnabled = true
            let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: "onLongPressAnchor:")
            gestureRecognizer.minimumPressDuration = 0
            anchorViewArray[i].addGestureRecognizer(gestureRecognizer)
            anchorViewArray[i].backgroundColor = UIColor.greenColor()
            
        }
    }
    

    func updateAnchorPosition(){
        for var i = 0; i < anchorViewArray.count ; ++i{
            //TODO frame need to be bigger
            anchorViewArray[i].frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            anchorViewArray[i].center = Common.calCoordinateFromIndex(polarOrigin, r: polarRadius , i: currentVerticeIndex[i])

            //            print("index \(i). point \(defaultVerticeIndex[i]). x \(anchorViewArray[i].center.x) .y \(anchorViewArray[i].center.y)")
            //
        }
        setNeedsDisplay()
    }
    
    func updatePosition (newO: CGPoint , newR: CGFloat ) {
        //loop through the vertices
        self.frame = CGRect(x: newO.x - newR ,y: newO.y - newR,
                            width: newR*2,height: newR*2)
        
        polarOrigin = CGPoint (x: (self.frame.width) * 0.5, y: (self.frame.height) / 2)
        polarRadius = newR
        updateAnchorPosition()
//        setNeedsDisplay()
        
    }


    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Draw this shape
        if (anchorViewArray.count > 1 ){
            let path = UIBezierPath()
            path.moveToPoint(anchorViewArray[0].center)
            for var i = 1 ; i < anchorViewArray.count ; ++i {
                path.addLineToPoint(anchorViewArray[i].center)
              //  print("draw index \(i) .x \(anchorViewArray[i].center.x) .y \(anchorViewArray[i].center.y)")
            }
            path.closePath()
//            UIColor.blueColor().setFill()
            (soundDict[soundIndex]!["color"]! as! UIColor).setFill()
            path.fill()
            
//            path.lineWidth = 2.0
//            UIColor.grayColor().setStroke()
//            path.stroke()
        }
    }
    
    func onLongPressAnchor(sender: UILongPressGestureRecognizer) {
        let v = sender.view!
        let location = sender.locationInView(self)
        v.center = location
        // Triggers drawRect
        setNeedsDisplay()
    }
    
    func turn(step: Int)  {
        //shift the index by the number of steps
        for var index = 0 ; index < anchorViewArray.count ; ++index {
            var temp = (currentVerticeIndex[index]+step) % TOTAL_TIME_SLOTS
            if (temp < 0 ){
                temp += timeArray.count //in case of CCW turns, temp would be a negative number
            }
            currentVerticeIndex[index] = temp
            
        }
        
        //refresh the timeArray
        fillTimeArrayWithAudio ()
        //refresh the visual
        updateAnchorPosition()
    }
    
    
    
    func fillTimeArrayWithAudio () {
        for var i=0 ; i < timeArray.count ; ++i {
            if currentVerticeIndex.contains( i ) {
                timeArray[i] = prepareAVAudioPlayer( soundDict[soundIndex]!["name"]! as! String, fileType: soundDict[soundIndex]!["extention"]! as! String )
            }
            else {
                timeArray[i] = nil
            }
            
        }
        
    }
    
    func updateAudio(){
        fillTimeArrayWithAudio()
        setNeedsDisplay() //audio changes color, hence redraw 
        
    }
    
    func play(index: Int) -> Bool {
        //check each of the slot in ticSlots and play the audio, if occupied, play the sound.
        if ( self.timeArray[index] != nil) {
            self.timeArray[index]?.play()
            // print ("playing index \(index) fileName \(fileName) ")
            
            return true
        }
        return false
    }

    
    //load the audio files given the file names
    func prepareAVAudioPlayer(fileName: String, fileType: String) -> AVAudioPlayer {
        let path = NSBundle.mainBundle().pathForResource(fileName, ofType: fileType)
        let fileURL = NSURL.fileURLWithPath(path!)
        
        
        let tempPlayer = try! AVAudioPlayer(contentsOfURL: fileURL)
        tempPlayer.delegate = self
        tempPlayer.prepareToPlay()
        return tempPlayer
    }


}
