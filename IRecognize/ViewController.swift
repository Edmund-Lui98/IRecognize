//
//  ViewController.swift
//  IRecognize
//
//  Created by Prism Student on 2020-04-22.
//  Copyright © 2020 Edmund Lui. All rights reserved.
//
import UIKit
import SceneKit
import ARKit
import AVKit
import Vision
import Speech

class ViewController: UIViewController, ARSCNViewDelegate, UITextFieldDelegate,AVCaptureVideoDataOutputSampleBufferDelegate {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var ItemName: UILabel!
    @IBOutlet weak var userEnter: UITextField!
    @IBOutlet weak var showButton: UIButton!
    
    let synthesizer = AVSpeechSynthesizer()
    var latestPrediction : String = ""

    @IBAction func keyboardTap(_ sender: Any) {
        userEnter.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    @IBAction func sayItem(_ sender: Any) {
        let utterance = AVSpeechUtterance(string: ItemName.text ?? "")
        utterance.rate = 0.5
        utterance.volume = 100
        
        synthesizer.speak(utterance)
    }
    var x = 0
    @IBAction func showItem(_ sender: Any) {
        if (x%2 == 0) {
            showButton.setTitleColor(.red, for: .normal)
            showButton.setTitle("Hide", for: .normal)
            ItemName.textColor = .black
        } else {
            showButton.setTitleColor(.blue, for: .normal)
            showButton.setTitle("Show", for: .normal)
            ItemName.textColor = .white
        }
        x += 1
    }
    var visionRequests = [VNRequest]()
    let dispatchQueueML = DispatchQueue(label: "videoQueue") // A Serial Queue
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        //let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        //sceneView.scene = scene
        
        self.userEnter.delegate = self
        
        guard let model = try? VNCoreMLModel(for: Resnet50().model) else { return }
        
        let classificationRequest = VNCoreMLRequest(model: model, completionHandler:  classificationCompleteHandler)
        classificationRequest.imageCropAndScaleOption = VNImageCropAndScaleOption.centerCrop
        visionRequests = [classificationRequest]
        
        loopUpdate()
        
        ItemName.textColor = .white
    }
    func loopUpdate() {
            dispatchQueueML.async {
                self.updateCoreML()
                self.loopUpdate()
            }
            
        }
        
        func classificationCompleteHandler(request: VNRequest, error: Error?) {
            guard let observations = request.results else {
                print("No results")
                return
            }
            
            let results = observations[0...1]
                .compactMap({ $0 as? VNClassificationObservation })
                .map({ "\($0.identifier) \(String(format:"- %.2f", $0.confidence))" })
                .joined(separator: "\n")
            
            
            DispatchQueue.main.async {
                print(results)
                
                var debugText:String = ""
                debugText += results
                self.ItemName.text = debugText
                
                var objectName:String = ""
                objectName = results.components(separatedBy: "-")[0]
                objectName = objectName.components(separatedBy: ",")[0]
                self.latestPrediction = objectName
            }
        }
        
        func updateCoreML() {
            let pixbuff : CVPixelBuffer? = (sceneView.session.currentFrame?.capturedImage)
            if pixbuff == nil { return }
            let ciImage = CIImage(cvPixelBuffer: pixbuff!)

            let imageRequestHandler = VNImageRequestHandler(ciImage: ciImage, options: [:])

            do {
                try imageRequestHandler.perform(self.visionRequests)
            } catch {
                print(error)
            }
            
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let results = sceneView.hitTest(touch.location(in: sceneView), types: [ARHitTestResult.ResultType.featurePoint])
        guard let hitFeature = results.last else { return }
        let hitTransform = SCNMatrix4.init(hitFeature.worldTransform)
        let hitPosition = SCNVector3Make(hitTransform.m41,
                                         hitTransform.m42,
                                         hitTransform.m43)
        createLabel(hitPosition: hitPosition)
    }
    func createLabel(hitPosition : SCNVector3) {
        var temp = latestPrediction
        if userEnter.text != "" {
            temp = userEnter.text ?? ""
            userEnter.text = ""
        }
        
        let label = SCNText(string: temp, extrusionDepth: 0.02)
        let font = UIFont(name: "Futura", size: 0.22)
        label.font = font
        label.alignmentMode = CATextLayerAlignmentMode.center.rawValue
        label.firstMaterial?.diffuse.contents = UIColor.white
        label.firstMaterial?.specular.contents = UIColor.white
        label.firstMaterial?.isDoubleSided = true
        label.chamferRadius = 0.01
        
        let (minBound, maxBound) = label.boundingBox
        
        let newLabel = SCNNode(geometry: label)
        newLabel.pivot = SCNMatrix4MakeTranslation((maxBound.x-minBound.x)/2,minBound.y,0.02/2)
        newLabel.scale = SCNVector3Make(0.1,0.1,0.1)
        newLabel.position = hitPosition
        
        self.sceneView.scene.rootNode.addChildNode(newLabel)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
//extension ViewController: ARSessionDelegate {
//    func session(_ session: ARSession, didUpdate frame: ARFrame) {
//
//    }
//}
