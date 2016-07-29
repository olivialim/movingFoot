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
    
    private var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var iv: UIImageView = {
        let imageView = UIImageView(frame: CGRectMake(0, 0, 450, 330))
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

//MARK: - DeltaPanGestureRecognizer -
extension ShoeController {
    
    func createPanGestureRecognizer(targetView: UIView) {
        let panGesture = UIPanGestureRecognizer(target: self, action:(#selector(panGestureRecognized(_:))))
        targetView.addGestureRecognizer(panGesture)
    }
    
    func panGestureRecognized(sender: UIPanGestureRecognizer) {
        

        if sender.state == .Changed {
            
            //where photo should change according to x!
            let newTranslation = sender.locationInView(view)
            print(newTranslation)
            
            let translationPercent = newTranslation.x/UIScreen.mainScreen().bounds.width
            let imageIndex = Int(translationPercent * CGFloat(ShoeController.ImageCount))
            
            let currentImage: UIImage = shoeImages[imageIndex]
            
            iv.image = currentImage
            
//            print(imageIndex)
        }
        else if sender.state == .Ended {
            
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

