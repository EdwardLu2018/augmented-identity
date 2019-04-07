//
//  MiddleViewController.swift
//  slideMenu
//
//  Created by Edward on 3/17/19.
//  Copyright © 2019 Edward. All rights reserved.
//

import UIKit
import ARKit
import SpriteKit
import Foundation
import Firebase
import FirebaseDatabase

class MiddleViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate  {
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var directionsLabel: UILabel!
    
    let textRecognizer = Vision.vision().onDeviceTextRecognizer()
    var ref: DatabaseReference!
    
    let cardInfoScene: SKScene = SKScene(fileNamed: "card-info")!
    let skillsScene: SKScene = SKScene(fileNamed: "skills")!
    let gitScene: SKScene = SKScene(fileNamed: "github")!
//    let gitInfoScene: SKScene = SKScene(fileNamed: "GHInfo")!
    var gitPressed: Bool = false
    let FBScene: SKScene = SKScene(fileNamed: "facebook")!
    let LIScene: SKScene = SKScene(fileNamed: "linkedIn")!
    let personalScene: SKScene = SKScene(fileNamed: "personal")!
    
    var gitTitle: String = ""
    var gitDescript: String = ""
    var gitLink: String = ""
    var FBLink: String = ""
    var LInk: String = ""
    var personalLink: String = ""
    
//    var skills = [String]()
    
    var foundCard: Bool = false
    var foundAnchor: Bool = false
    var name: String = "Press And Hold"
    var major: String = "To Scan Card"
    
    var skill1: String = ""
    var skill2: String = ""
    var skill3: String = ""
    var skill4: String = ""
    var skill5: String = ""
    
    lazy var fadeInAction: SCNAction = {
        return .sequence([
            .wait(duration: 1.0),
            .fadeOpacity(by: 0.9, duration: 0.25)
            ])
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.directionsLabel.center.x  -= view.bounds.width
        
        sceneView.delegate = self
        sceneView.session.delegate = self
        
        configureLighting()
        
        UIView.animate(withDuration: 2.5) {
            self.directionsLabel.center.x += self.view.bounds.width
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetTrackingConfiguration()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    func configureLighting() {
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let cardAnchor = anchor as? ARImageAnchor else { return }
        let referenceImage = cardAnchor.referenceImage
        
        DispatchQueue.main.async {
            if let nameLabel = self.cardInfoScene.childNode(withName: "name") as? SKLabelNode {
                nameLabel.text = self.name
            }
            if let majorLabel = self.cardInfoScene.childNode(withName: "major") as? SKLabelNode {
                majorLabel.text = self.major
            }
            
            let info = ARPlane(scene: self.cardInfoScene, width: referenceImage.physicalSize.width, height: referenceImage.physicalSize.height * 0.6, x: 0, y: 0, z: -0.048)
            info.node.runAction(self.fadeInAction)
            node.addChildNode(info.node)
            
            if (cardAnchor.isTracked) {
                self.foundAnchor = true
                if (self.foundCard) {
                    self.getDataFromDatabase(name: self.name)
                    if let skill1Label = self.skillsScene.childNode(withName: "skill1") as? SKLabelNode {
                        skill1Label.text = self.skill1
                    }
                    if let skill2Label = self.skillsScene.childNode(withName: "skill2") as? SKLabelNode {
                        skill2Label.text = self.skill2
                    }
                    if let skill3Label = self.skillsScene.childNode(withName: "skill3") as? SKLabelNode {
                        skill3Label.text = self.skill3
                    }
                    if let skill4Label = self.skillsScene.childNode(withName: "skill4") as? SKLabelNode {
                        skill4Label.text = self.skill4
                    }
                    if let skill5Label = self.skillsScene.childNode(withName: "skill5") as? SKLabelNode {
                        skill5Label.text = self.skill5
                    }
                    
                    let skills = ARPlane(scene: self.skillsScene, width: referenceImage.physicalSize.width, height: referenceImage.physicalSize.height * 3.15, x: 0.093, y: 0, z: 0.0216)
                    skills.node.runAction(self.fadeInAction)
                    node.addChildNode(skills.node)
                    
    //                if let gitTitleLabel = gitInfoScene.childNode(withName: "projectName") as? SKLabelNode {
    //                    gitTitleLabel.text = self.gitTitle
    //                }
    //
    //                if let gitDescriptionLabel = gitInfoScene.childNode(withName: "projectDescription") as? SKLabelNode {
    //                    gitDescriptionLabel.text = self.gitDescript
    //                }
                    
                    let github = ARPlane(scene: self.gitScene, width: 0.015, height: 0.015, x: -0.034, y: 0, z: 0.040)
                    github.plane.cornerRadius = 4.5
                    github.node.runAction(self.fadeInAction)
                    node.addChildNode(github.node)
                    
    //                let gitInfoPlane = SCNPlane(width: referenceImage.physicalSize.width, height: referenceImage.physicalSize.height)
    //                gitInfoPlane.cornerRadius = gitInfoPlane.width / 25
    //
    //                gitInfoPlane.firstMaterial?.diffuse.contents = gitInfoScene
    //                gitInfoPlane.firstMaterial?.isDoubleSided = true
    //                gitInfoPlane.firstMaterial?.diffuse.contentsTransform = SCNMatrix4Translate(SCNMatrix4MakeScale(1, -1, 1), 0, 1, 0)
    //
    //                let gitInfoPlaneNode = SCNNode(geometry: gitInfoPlane)
    //                gitInfoPlaneNode.name = "gitInfoNode"
    //                gitInfoPlaneNode.eulerAngles.x = -.pi / 2
    //                gitInfoPlaneNode.opacity = 0.10
    //                gitInfoPlaneNode.position.z = Float(0.052 + (gitInfoPlane.height / 2.0))
    //
    //                if (self.gitPressed) {
    //                    gitInfoPlaneNode.runAction(self.fadeInAction)
    //
    //                    node.addChildNode(gitInfoPlaneNode)
    //                }
                    let facebook = ARPlane(scene: self.FBScene, width: 0.015, height: 0.015, x: -0.012, y: 0, z: 0.040)
                    facebook.plane.cornerRadius = 4.5
                    facebook.node.runAction(self.fadeInAction)
                    node.addChildNode(facebook.node)
                    
                    let linkedIn = ARPlane(scene: self.LIScene, width: 0.015, height: 0.015, x: 0.010, y: 0, z: 0.040)
                    linkedIn.plane.cornerRadius = 4.5
                    linkedIn.node.runAction(self.fadeInAction)
                    node.addChildNode(linkedIn.node)
                    
                    let personal = ARPlane(scene: self.personalScene, width: 0.015, height: 0.015, x: 0.032, y: 0, z: 0.040)
                    personal.plane.cornerRadius = 4.5
                    personal.node.runAction(self.fadeInAction)
                    node.addChildNode(personal.node)
                }
            }
            else {
    //            print("removed anchor")
                self.foundCard = false
                self.foundAnchor = false
                self.name = "Press And Hold"
                self.major = "To Scan Card"
                self.sceneView.session.remove(anchor: anchor)
            }
        }
    }
    
    func resetTrackingConfiguration() {
        let configuration = ARImageTrackingConfiguration()
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else { return }
        configuration.trackingImages = referenceImages
        let options: ARSession.RunOptions = [.resetTracking, .removeExistingAnchors]
        sceneView.session.run(configuration, options: options)
    }
    
    func getText(image: UIImage) {
        self.directionsLabel.text = "Scanning..."
        let visionImage = VisionImage(image: image)
        textRecognizer.process(visionImage) { result, error in
            guard error == nil, let result = result else { return }
            
            if (result.text.contains("University") || result.text.contains("Student") || result.text.contains("UserID")) {
                if let lowerRange = result.text.range(of: "University\n"),
                    let upperRange = result.text.range(of: " Student") {
                    self.name =  String(result.text[lowerRange.upperBound...upperRange.lowerBound])
                    self.name = self.name.trimmingCharacters(in: .whitespaces)
                    self.foundCard = true
                    self.directionsLabel.text = "Name Found!"
                }
            }
        }
    }
    
    @IBAction func longPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            if (self.foundAnchor) {
                self.foundCard = false
                let imageFromArkitScene: UIImage? = sceneView.snapshot()
                self.getText(image: imageFromArkitScene!)
            }
        }
        if gestureRecognizer.state == .ended {
            self.directionsLabel.text = "Hold ID In Front Of Camera & Press"
        }
    }
    
    func getDataFromDatabase(name: String) {
        self.ref = Database.database().reference()
        self.ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value as? NSDictionary {
                for each in value {
                    let dict = each.1 as? NSDictionary
                    guard let firstName = dict?["firstName"] as? String else { return }
                    guard let lastName = dict?["lastName"] as? String else { return }
                    let fullName = firstName + " " + lastName
                    
                    if name == fullName {
                        self.gitTitle = dict?["github"] as? String ?? "N/A"
                        self.FBLink = dict?["facebook"] as? String ?? "N/A"
                        self.LInk = dict?["github"] as? String ?? "N/A"
                        self.personalLink = dict?["personalSite"] as? String ?? "N/A"
                        self.major = dict?["major"] as? String ?? "N/A"
                        self.skill1 = dict?["skill1"] as? String ?? "N/A"
                        self.skill2 = dict?["skill2"] as? String ?? "N/A"
                        self.skill3 = dict?["skill3"] as? String ?? "N/A"
                        self.skill4 = dict?["skill4"] as? String ?? "N/A"
                        self.skill5 = dict?["skill5"] as? String ?? "N/A"
                    }
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}
