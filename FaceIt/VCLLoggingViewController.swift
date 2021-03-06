//
//  VCLLoggingViewController.swift
//  FaceIt
//
//  Created by Michel Deiman on 06/03/2017.
//  Copyright © 2017 Michel Deiman. All rights reserved.
//

import UIKit

class VCLLoggingViewController: UIViewController
{
    private struct LogGlobals {
        var prefix = ""
        var instanceCounts = [String:Int]()
        var lastLogTime = Date()
        var indentationInterval: TimeInterval = 1
        var indentationString = "__"
    }
    
    private static var logGlobals = LogGlobals()
    
    private static func logPrefix(for className: String) -> String {
        if logGlobals.lastLogTime.timeIntervalSinceNow < -logGlobals.indentationInterval {
            logGlobals.prefix += logGlobals.indentationString
            print("") }
        logGlobals.lastLogTime = Date()
        return logGlobals.prefix + className
    }
    
    private static func bumpInstanceCount(for className: String) -> Int {
        logGlobals.instanceCounts[className] = (logGlobals.instanceCounts[className] ?? 0) + 1
        return logGlobals.instanceCounts[className]!
    }
    
    private var instanceCount: Int!
    
    private func logVCL(_ msg: String) {
        let className = String(describing: type(of: self))
        if instanceCount == nil {
            instanceCount =  VCLLoggingViewController.bumpInstanceCount(for: className)
        }
        print("\(VCLLoggingViewController.logPrefix(for: className))(\(instanceCount!)) \(msg)")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        logVCL("init(coder:) - created via InterfaceBuilder ")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        logVCL("init(nibName:bundle:) - create in code")
    }
    
    deinit {
        logVCL("left the heap")
    }
    
    /// happens before outlets are set(before the mvc loaded)
    override func awakeFromNib() {
        logVCL("awakeFromNib()")
    }
    
    /// after instantiation and outlet-setting, viewdidload is called
    override func viewDidLoad() {
        super.viewDidLoad()
        // do some setup of my MVC
        logVCL("viewDidLoad()")
    }
    /// Just before your view appears on screen, you get notified
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        logVCL("viewWillAppear(animated = \(animated))")
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logVCL("viewDidAppear(animated = \(animated))")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        logVCL("viewWillDisappear(animated = \(animated))")
        // do some clean up now that we've been removed from the screen
        // but be careful not to do anything time-consuming here, or app will be sluggish
        // maybe

    }
    
    /// you get notified when you will disappear off screen
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        logVCL("viewDidDisappear(animated = \(animated))")
    }
    
    ///
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        logVCL("didReceiveMemoryWarning()")
    }
    
    ///  Geometry changed; They are called any time a view's frame changed and its subviews were thus re-layed out
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        logVCL("viewWillLayoutSubviews() bounds.size = \(view.bounds.size)")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        logVCL("viewDidLayoutSubviews() bounds.size = \(view.bounds.size)")
    }
    
    ///
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        logVCL("viewWillTransition(to: \(size), with: coordinator)")
        coordinator.animate(alongsideTransition: {
            (context: UIViewControllerTransitionCoordinatorContext!) -> Void in
            self.logVCL("begin animate(alongsideTransition:completion:)")
        }, completion: { context -> Void in
            self.logVCL("end animate(alongsideTransition:completion:)")
        })
    }
}

/*
 
 View Controller Lifecycle
 
 Instantiated (from storyboard usually)
 awakeFromNib
 segue preparation happens
 outlets get set
 viewDidLoad
 These pairs will be called each time your Controller's view goes on/off screen
    viewWillAppear and viewDidAppear
    viewWillDIsappear and viewDidDisappear
 These "geometry changed" method might be called at any time after viewDidLoad 
    viewWillLayoutSubviews(... then autolayout happens, then ...) viewDidLayoutSubviews 
 If memory gets low, you might get ...
    didReceiveMemoryWarning
 
 
 
 */
