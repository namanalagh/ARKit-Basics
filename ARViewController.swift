//
//  ARViewController.swift
//  ARKit Basics
//
//  Created by Naman Alagh on 19/03/23.
//

import UIKit
import ARKit
import RealityKit

class ARViewController: UIViewController {

    @IBOutlet weak var arView: ARSCNView!
    
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.arView.debugOptions = [ARSCNDebugOptions.showFeaturePoints,ARSCNDebugOptions.showWorldOrigin]
        self.arView.session.run(configuration)
        // Load the "Box" scene from the "Experience" Reality File
        let boxAnchor = try! Experience.loadBox()
        
        
        let smokeDetScene = SCNScene(named: "Smoke Detector.dae")
        guard let currentModel = smokeDetScene?.rootNode.childNode(withName: "Smoke", recursively: true) else {
            fatalError("No model found.")
        }
        
        currentModel.position = SCNVector3(x: 0, y: 0, z: 0)
        self.arView.scene.rootNode.addChildNode(currentModel)
  
        // Add the box anchor to the scene
        // arView.scene.anchors.append(boxAnchor)
    }
    
    @IBAction func add(_ sender: Any) {
        let node = SCNNode()
        node.geometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.cyan
        node.position = SCNVector3(x: 0.1, y: 0.3, z: 0.1)
        self.arView.scene.rootNode.addChildNode(node)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
