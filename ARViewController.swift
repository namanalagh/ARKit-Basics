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
        
        // Add the box anchor to the scene
        // arView.scene.anchors.append(boxAnchor)
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
