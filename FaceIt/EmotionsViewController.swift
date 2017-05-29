//
//  EmotionsViewController.swift
//  FaceIt
//
//  Created by Michel Deiman on 05/03/2017.
//  Copyright © 2017 Michel Deiman. All rights reserved.
//

import UIKit

class EmotionsViewController: VCLLoggingViewController {

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        var destinationVC = segue.destination
        
        if let navigationController = destinationVC as? UINavigationController {
            destinationVC = navigationController.visibleViewController ?? destinationVC
        }
        
        if  let faceViewController = destinationVC as? FaceViewController,
            let identifier = segue.identifier,
            let expression = emotionalFaces[identifier]
        {
            faceViewController.expression = expression
            faceViewController.navigationItem.title = (sender as? UIButton)?.currentTitle
        }
    
    }
    
    private let emotionalFaces: [String: FacialExpression] = [
        "sad": FacialExpression(eyes: .closed, mouth: .frown),
        "happy": FacialExpression(eyes: .open, mouth: .smile),
        "worried": FacialExpression(eyes: .open, mouth: .smirk)
    ]

}
