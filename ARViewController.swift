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
        //self.arView.debugOptions = [ARSCNDebugOptions.showFeaturePoints,ARSCNDebugOptions.showWorldOrigin]
        self.arView.session.run(configuration)
        registerGestureRecognizers()
        self.arView.autoenablesDefaultLighting = true
        let smokeDetScene = SCNScene(named: "Smoke Detector.dae")
        guard let currentModel = smokeDetScene?.rootNode.childNode(withName: "Smoke", recursively: true) else {
            fatalError("No model found.")
        }
        
        currentModel.position = SCNVector3(x: 0, y: 0, z: -0.4)
        self.arView.scene.rootNode.addChildNode(currentModel)
    }
    
    @IBAction func add(_ sender: Any) {
        let node = SCNNode()
        node.geometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.cyan
        node.position = SCNVector3(x: 0.1, y: 0.3, z: 0.1)
        self.arView.scene.rootNode.addChildNode(node)
    }
    
    private func registerGestureRecognizers(){
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinched))
        self.arView.addGestureRecognizer(pinchGestureRecognizer)
    }

    @objc func pinched(recognizer: UIPinchGestureRecognizer){
        if recognizer.state == .changed{
            guard let arView = recognizer.view as? ARSCNView else{
                return
            }
            
            let touch = recognizer.location(in: arView)
            let hitTestResults = self.arView.hitTest(touch, options: nil)
            
            if let hitTest = hitTestResults.first {
                let modelNode = hitTest.node
                let pinchScaleX = Float(recognizer.scale) * modelNode.scale.x
                let pinchScaleY = Float(recognizer.scale) * modelNode.scale.y
                let pinchScaleZ = Float(recognizer.scale) * modelNode.scale.z
                
                modelNode.scale = SCNVector3(x: pinchScaleX, y: pinchScaleY, z: pinchScaleZ)
                recognizer.scale = 1
            }
        }
    }
}
