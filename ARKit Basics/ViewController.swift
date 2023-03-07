//
//  ViewController.swift
//  ARKit Basics
//
//  Created by Naman Alagh on 02/03/23.
//

import UIKit
import RealityKit
import ARKit

class ViewController: UIViewController {
    
  
    @IBOutlet var arView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.arView.debugOptions = [ARSCNDebugOptions.showFeaturePoints,ARSCNDebugOptions.showWorldOrigin]
        self.arView.session.run(configuration)
        // Load the "Box" scene from the "Experience" Reality File
        let boxAnchor = try! Experience.loadBox()
        
        // Add the box anchor to the scene
        // arView.scene.anchors.append(boxAnchor)
    }
}
