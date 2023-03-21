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
    
    var originalRotation: SCNVector3? = nil
    var modelNode: SCNNode!
    var currentAngleY: Float = 0.0
    
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
        modelNode = currentModel
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
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(rotation))
        //self.arView.addGestureRecognizer(rotationGesture)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panned))
        self.arView.addGestureRecognizer(panGesture)
    }

    @objc func pinched(_ gesture: UIPinchGestureRecognizer){
        if gesture.state == .changed{
            guard let arView = gesture.view as? ARSCNView else{
                return
            }
            
            let touch = gesture.location(in: arView)
            let hitTestResults = self.arView.hitTest(touch, options: nil)
            
            if let hitTest = hitTestResults.first {
                let modelNode = hitTest.node
                let pinchScaleX = Float(gesture.scale) * modelNode.scale.x
                let pinchScaleY = Float(gesture.scale) * modelNode.scale.y
                let pinchScaleZ = Float(gesture.scale) * modelNode.scale.z
                
                modelNode.scale = SCNVector3(x: pinchScaleX, y: pinchScaleY, z: pinchScaleZ)
                gesture.scale = 1
            }
        }
    }
    
    @objc func rotation(_ gesture: UIRotationGestureRecognizer){
        let location = gesture.location(in: self.arView)
        guard let node = nodeMethod(at: location) else { return }
            
        switch gesture.state {
        case .began:
            originalRotation = node.eulerAngles
            print("rot")
        case .changed:
            guard var originalRotation = originalRotation else { return }
            originalRotation.y -= Float(gesture.rotation)
            node.eulerAngles = originalRotation
            print("rot")
        default:
            originalRotation = nil
            print("rot")
        }
    }
    
    private func nodeMethod(at position: CGPoint) -> SCNNode? {
        let n = self.arView.hitTest(position, options: nil).first(where: {
            $0.node !== modelNode
        })?.node

        return n
    }
    
    @objc func panned(_ gesture: UIPanGestureRecognizer){
        guard let nodeToRotate = modelNode else { return }

                let translation = gesture.translation(in: gesture.view!)
                var newAngleY = (Float)(translation.x)*(Float)(Double.pi)/180.0
                newAngleY += currentAngleY

                nodeToRotate.eulerAngles.y = newAngleY

                if(gesture.state == .ended) { currentAngleY = newAngleY }

                print(nodeToRotate.eulerAngles)
        
    }
}
