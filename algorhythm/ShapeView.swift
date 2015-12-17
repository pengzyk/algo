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
//    var vertices = [CGPoint]()
    //var coordinateLookupTable = [CGPoint]() //where all time slots should be
    var anchorView: UIView! //to allow all vertices to be move-able
    var anchorViewArray = [UIView]() //to allow all vertices to be move-able
    
    ///audio
//    var soundFile: String!
    var timeArray = [AVAudioPlayer?](count:16, repeatedValue: nil)
    var soundIndex: Int!
    //TODO change this to a index that links to a look up table 
//    var soundDict = [Int: [String:String]]()
    var soundDict  = [0: ["name":"just blaze hipsnare","extention":"WAV", "color": UIColor.blueColor()],
        1: ["name":"just blaze bksnare2","extention":"WAV", "color": UIColor.orangeColor()],
        2: ["name":"just blaze &ound10","extention":"WAV", "color": UIColor.yellowColor()],
        3: ["name":"just blaze &ound10","extention":"WAV", "color": UIColor.purpleColor()],
        4: ["name":"just blaze &ound10","extention":"WAV", "color": UIColor.cyanColor()]
        
        
    ]

   
    
    
//    override init(frame: CGRect) {
    init(frame: CGRect , numVertices : Int, sound: Int) {
        super.init(frame: frame)
        self.soundIndex = sound
        self.numVertices = numVertices
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func calCoordinateFromIndex( index: Int) -> CGPoint {
        //index is offset by a quarter
        //hence the treatment
        let newIndex =  index - TOTAL_TIME_SLOTS/4
        let rad = Double(newIndex) * M_PI * 2.0 / Double(TOTAL_TIME_SLOTS)
        let x = cos(rad)
        let y = sin(rad)
       // print("index \(index) .x \(x) .y \(y)")
    
        return CGPoint(x: x, y: y)
        
    }
    
    func calCoordinateFromIndex( o: CGPoint, r: CGFloat, i: Int) -> CGPoint{
        let x = calCoordinateFromIndex(i).x * r + o.x
        let y = calCoordinateFromIndex(i).y * r + o.y
        return CGPoint(x: x, y: y)
        
    }
    func setup() {

        switch (numVertices){
        case 3:
            defaultVerticeIndex = [0, 5, 11]
            break;
        case 4:
            defaultVerticeIndex = [0,4,8,12]
            break;
        case 5:
            defaultVerticeIndex = [0,3,6,10,13]
            break;
        case 6:
            defaultVerticeIndex = [1,4,7,9,12,15]
            break;
        case 8:
            defaultVerticeIndex = [1,3,5,7,9,11,13,15]
            break;
        default:
            print("error")
            defaultVerticeIndex = [0]
            break;
            
        }
        
        //fill in the AVAudioPlayer
        fillSlots()
        
        //calculate each vertex and add to array
        let origin = CGPoint(x: 33, y: 33)
//        for var i = 0; i < defaultVerticeIndex.count ; ++i {
//            vertices.append (calCoordinateFromIndex(origin, r: 30, i: defaultVerticeIndex[i]))
//        }

        //NOTE THAT THE VERTICE IS NOT SCALING IWHT THE IAMGES!!!
        for var i = 0; i < defaultVerticeIndex.count ; ++i {
            var anchorView: UIView!
            anchorView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            anchorView.userInteractionEnabled = true

            anchorView.backgroundColor = UIColor.clearColor()
            anchorView.center = calCoordinateFromIndex(origin, r: 30, i: defaultVerticeIndex[i])
            addSubview(anchorView)
            
            let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: "onLongPressAnchor:")
            gestureRecognizer.minimumPressDuration = 0
            //TODO ADD THIS WHEN IN LOOP
//            anchorView.addGestureRecognizer(gestureRecognizer)
            anchorViewArray.append(anchorView)
        }

        backgroundColor = UIColor.clearColor()
//          backgroundColor = UIColor.orangeColor()
        
        
      
        
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
                //                print("index \(i) .x \(vertices[i].x) .y \(vertices[i].y)")
            }
            path.closePath()
//            UIColor.blueColor().setFill()
            (soundDict[soundIndex]!["color"]! as! UIColor).setFill()
            path.fill()
//            path.lineWidth = 2.0
//            UIColor.grayColor().setStroke()
//            path.stroke()
        }

        //// if we just need static image, use this !
        
//        if (vertices.count > 1 ){
//            let path = UIBezierPath()
//            path.moveToPoint(vertices[0])
//            for var i = 1 ; i < vertices.count ; ++i {
//                path.addLineToPoint(vertices[i])
////                print("index \(i) .x \(vertices[i].x) .y \(vertices[i].y)")
//            }
//            path.closePath()
//            UIColor.blueColor().setFill()
//            path.fill()
//            path.lineWidth = 2.0
//            UIColor.grayColor().setStroke()
//            path.stroke()
//        }
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
            var temp = (defaultVerticeIndex[index]+step) % timeArray.count
            if (temp < 0 ){
                temp += timeArray.count //in case of CCW turns, temp would be a negative number
            }
            defaultVerticeIndex[index] = temp
            
        }
        
        //refresh the timeArray
        fillSlots ()
    }
    

    
    func fillSlots () {
        for var i=0 ; i < timeArray.count ; ++i {
            if defaultVerticeIndex.contains( i ) {
              
//                
                timeArray[i] = prepareAVAudioPlayer( soundDict[soundIndex]!["name"]! as! String, fileType: soundDict[soundIndex]!["extention"]! as! String )
            }
            else {
                timeArray[i] = nil
            }
            
        }
        
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
