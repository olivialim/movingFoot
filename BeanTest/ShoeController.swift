//
//  ViewController.swift
//  BeanBlinkOnButtonPRess
//
//  Created by Olivia Lim on 7/15/16.
//  Copyright © 2016 Olivia Lim. All rights reserved.
//

import UIKit
import Bean_iOS_OSX_SDK

class ShoeController: UIViewController, PTDBeanManagerDelegate, PTDBeanDelegate {
    static let ImageCount = 62
    
    var beanManager = PTDBeanManager?()
    var yourBean = PTDBean?()
    
    var shoeImages: [UIImage] = []
    var currentIndex: Int = 0
    
    var timerInitiated = false;
    var timer: NSTimer?
    
    var imageIndex: Int = 0
    
    private var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var iv: UIImageView = {
        let imageView = UIImageView(frame: CGRectZero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    func storeImages() {
        for i in 0..<ShoeController.ImageCount {
            let assetName = "AllCutsLast00\(i + 1)"
            if let image = UIImage(named: assetName) {
                shoeImages.append(image)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        beanManager = PTDBeanManager()
        beanManager!.delegate = self
        
        
        storeImages()
        
        layout()
        wire()
    }
    
    override func viewDidAppear(animated: Bool) {
        startScanning()
    }
    
    
}

//MARK: - PanGestureRecognizer -
extension ShoeController {
    
    func createPanGestureRecognizer(targetView: UIView) {
        let panGesture = UIPanGestureRecognizer(target: self, action:(#selector(panGestureRecognized(_:))))
        targetView.addGestureRecognizer(panGesture)
    }
    
    func findIndex(newTranslation: CGPoint) {
        let translationPercent = newTranslation.x/UIScreen.mainScreen().bounds.width
        imageIndex = Int(translationPercent * CGFloat(ShoeController.ImageCount))
    }
    
    func animateFrame() {
        currentIndex += Int(round(Double(imageIndex-currentIndex)/10))
        
        if currentIndex < 0 {
            currentIndex = 0
        }
        if currentIndex > 61 {
            currentIndex = 61
        }
        
        print (currentIndex)
        let currentImage: UIImage = shoeImages[currentIndex]
        iv.image = currentImage
    }

    
    func panGestureRecognized(sender: UIPanGestureRecognizer) {
        
        /*
         NSTimer happens when the gesture is first recgonized
         The animation then starts when the timer starts
         invalidate when you end the timer

         */
        
        if sender.state == .Began {
            
            findIndex(sender.locationInView(view))
            timer?.invalidate()
            
            timer = NSTimer.scheduledTimerWithTimeInterval(
                0.05,
                target: self,
                selector: #selector(ShoeController.animateFrame),
                userInfo: nil,
                repeats: true)
        }

        
        if sender.state == .Changed {
            
            //where photo changes according to x!
            findIndex(sender.locationInView(view))

            //EASING OUT
            //
            let finalImage: UIImage = shoeImages[imageIndex]
            iv.frame = CGRect(x: 0, y: 0, width: finalImage.size.width, height: finalImage.size.height)
//            var changedImage = imageIndex/3
//            var newIndex: Int = 0
            
//            while imageIndex > currentIndex {
//                currentIndex += Int(ceil(Double(((imageIndex-currentIndex)/3))))
//                print (currentIndex)
//                let currentImage: UIImage = shoeImages[currentIndex]
//                iv.image = currentImage
//            }
            
            iv.image = finalImage
        }
    }
    
}

//MARK: - Layout -
extension ShoeController {
    
    private func layout() {
        view.backgroundColor = .whiteColor()
        
        containerView.backgroundColor = .redColor()
        iv.backgroundColor = .blueColor()
        
        view.addSubview(containerView)
        view.addConstraint(NSLayoutConstraint(
            item: containerView,
            attribute: .Width,
            relatedBy: .Equal,
            toItem: view,
            attribute: .Width,
            multiplier: 1.0,
            constant: 0)
        )
        view.addConstraint(NSLayoutConstraint(
            item: containerView,
            attribute: .Height,
            relatedBy: .Equal,
            toItem: view,
            attribute: .Height,
            multiplier: 1.0,
            constant: 0)
        )
        view.addConstraint(NSLayoutConstraint(
            item: containerView,
            attribute: .CenterX,
            relatedBy: .Equal,
            toItem: view,
            attribute: .CenterX,
            multiplier: 1.0,
            constant: 0)
        )
        view.addConstraint(NSLayoutConstraint(
            item: containerView,
            attribute: .CenterY,
            relatedBy: .Equal,
            toItem: view,
            attribute: .CenterY,
            multiplier: 1.0,
            constant: 0)
            )
        
        view.addSubview(iv)
        view.addConstraint(NSLayoutConstraint(
            item: iv,
            attribute: .Width,
            relatedBy: .Equal,
            toItem: containerView,
            attribute: .Width,
            multiplier: 1.0,
            constant: 0)
        )
        view.addConstraint(NSLayoutConstraint(
            item: iv,
            attribute: .Height,
            relatedBy: .Equal,
            toItem: containerView,
            attribute: .Height,
            multiplier: 1.0,
            constant: 0)
        )
        view.addConstraint(NSLayoutConstraint(
            item: iv,
            attribute: .CenterX,
            relatedBy: .Equal,
            toItem: containerView,
            attribute: .CenterX,
            multiplier: 1.0,
            constant: 0)
        )
        view.addConstraint(NSLayoutConstraint(
            item: iv,
            attribute: .CenterY,
            relatedBy: .Equal,
            toItem: containerView,
            attribute: .CenterY,
            multiplier: 1.0,
            constant: 0)
        )
    }
}

//MARK: - Layout -
extension ShoeController {

    private func wire() {
        createPanGestureRecognizer(containerView)
    }

}

//MARK: - BLUETOOTH -
extension ShoeController {
    func beanManager(beanManager: PTDBeanManager!, didDiscoverBean bean: PTDBean!, error: NSError!) {
        
        if let e = error {
            print("SCAN ERROR for Bean: \(e)")
        }
        
        
        let alertController = UIAlertController(title: "Found a Bean: \(bean.name)", message: "", preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
        if bean.name == "Bean" {
            yourBean = bean
            connectToBean(yourBean!)
        }
    }
    
    func connectToBean(bean: PTDBean) {
        var error: NSError?
        beanManager?.connectToBean(bean, error: &error)
    }
    
    func sendSerialData(beanState: NSData) {
        yourBean?.sendSerialData(beanState)
    }
}

//MARK: - BEAN -
extension ShoeController {
    func beanManagerDidUpdateState(beanManager: PTDBeanManager!) {
        var scanError: NSError?
        
        if beanManager!.state == BeanManagerState.PoweredOn {
            startScanning()
            if let e = scanError {
                
                print("SCAN ERROR for Bluetooth1: \(e)")
                
            } else {
                print ("Please turn on your Bluetooth")
            }
        }
    }
    
    func startScanning() {
        var error: NSError?
        beanManager!.startScanningForBeans_error(&error)
        if let e = error {
            print("SCAN ERROR for Bluetooth2: \(e)")
        }
    }
    
}

