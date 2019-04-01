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

class MiddleViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate  {
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var directionsLabel: UILabel!
    
    let textRecognizer = Vision.vision().onDeviceTextRecognizer()
    var imageFromArkitScene: UIImage?
    
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
    
    var skills = [String]()
    
    var foundCard: Bool = false
    var foundAnchor: Bool = false
    var name: String = "Press And Hold"
    var major: String = "To Scan Card"
    
    var skill1: String = ""
    var skill2: String = ""
    var skill3: String = ""
    var skill4: String = ""
    var skill5: String = ""
    
    let fadeDuration: TimeInterval = 7
    
    lazy var fadeInAction: SCNAction = {
        return .sequence([
            .fadeOpacity(by: 0.9, duration: fadeDuration)
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
        guard let imageAnchor = anchor as? ARImageAnchor else { return }
        let referenceImage = imageAnchor.referenceImage
        self.foundAnchor = true
        
        if let nameLabel = cardInfoScene.childNode(withName: "name") as? SKLabelNode {
            nameLabel.text = self.name
        }
        if let nameLabel = cardInfoScene.childNode(withName: "major") as? SKLabelNode {
            nameLabel.text = self.major
        }
        
        let info = ARPlane(scene: cardInfoScene, width: referenceImage.physicalSize.width, height: referenceImage.physicalSize.height * 0.6, x: 0, y: 0, z: -0.048)
        info.node.runAction(self.fadeInAction)
        node.addChildNode(info.node)
        
        if (self.foundCard) {
            if let skill1Label = skillsScene.childNode(withName: "skill1") as? SKLabelNode {
                skill1Label.text = self.skill1
            }
            if let skill2Label = skillsScene.childNode(withName: "skill2") as? SKLabelNode {
                skill2Label.text = self.skill2
            }
            if let skill3Label = skillsScene.childNode(withName: "skill3") as? SKLabelNode {
                skill3Label.text = self.skill3
            }
            if let skill4Label = skillsScene.childNode(withName: "skill4") as? SKLabelNode {
                skill4Label.text = self.skill4
            }
            if let skill5Label = skillsScene.childNode(withName: "skill5") as? SKLabelNode {
                skill5Label.text = self.skill5
            }
            
            let skills = ARPlane(scene: skillsScene, width: referenceImage.physicalSize.width, height: referenceImage.physicalSize.height * 3.15, x: 0.093, y: 0, z: 0.0216)
            skills.node.runAction(self.fadeInAction)
            node.addChildNode(skills.node)
            
//            if let gitTitleLabel = gitInfoScene.childNode(withName: "projectName") as? SKLabelNode {
//                gitTitleLabel.text = self.gitTitle
//            }
//
//            if let gitDescriptionLabel = gitInfoScene.childNode(withName: "projectDescription") as? SKLabelNode {
//                gitDescriptionLabel.text = self.gitDescript
//            }
            
            let github = ARPlane(scene: gitScene, width: 0.015, height: 0.015, x: -0.034, y: 0, z: 0.040)
            github.plane.cornerRadius = 4.5
            github.node.runAction(self.fadeInAction)
            node.addChildNode(github.node)
            
//            let gitInfoPlane = SCNPlane(width: referenceImage.physicalSize.width, height: referenceImage.physicalSize.height)
//            gitInfoPlane.cornerRadius = gitInfoPlane.width / 25
//
//            gitInfoPlane.firstMaterial?.diffuse.contents = gitInfoScene
//            gitInfoPlane.firstMaterial?.isDoubleSided = true
//            gitInfoPlane.firstMaterial?.diffuse.contentsTransform = SCNMatrix4Translate(SCNMatrix4MakeScale(1, -1, 1), 0, 1, 0)
//
//            let gitInfoPlaneNode = SCNNode(geometry: gitInfoPlane)
//            gitInfoPlaneNode.name = "gitInfoNode"
//            gitInfoPlaneNode.eulerAngles.x = -.pi / 2
//            gitInfoPlaneNode.opacity = 0.10
//            gitInfoPlaneNode.position.z = Float(0.052 + (gitInfoPlane.height / 2.0))
//
//            if (self.gitPressed) {
//                gitInfoPlaneNode.runAction(self.fadeInAction)
//
//                node.addChildNode(gitInfoPlaneNode)
//            }
            let facebook = ARPlane(scene: FBScene, width: 0.015, height: 0.015, x: -0.012, y: 0, z: 0.040)
            facebook.plane.cornerRadius = 4.5
            facebook.node.runAction(self.fadeInAction)
            node.addChildNode(facebook.node)
            
            let linkedIn = ARPlane(scene: LIScene, width: 0.015, height: 0.015, x: 0.010, y: 0, z: 0.040)
            linkedIn.plane.cornerRadius = 4.5
            linkedIn.node.runAction(self.fadeInAction)
            node.addChildNode(linkedIn.node)
            
            let personal = ARPlane(scene: personalScene, width: 0.015, height: 0.015, x: 0.032, y: 0, z: 0.040)
            personal.plane.cornerRadius = 4.5
            personal.node.runAction(self.fadeInAction)
            node.addChildNode(personal.node)
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
        let visionImage = VisionImage(image: image)
        textRecognizer.process(visionImage) { result, error in
            guard error == nil, let result = result else { return }
            
            if (result.text.contains("University") || result.text.contains("Student") || result.text.contains("UserID")) {
                if let lowerRange = result.text.range(of: "University\n"),
                    let upperRange = result.text.range(of: " Student") {
                    self.name =  String(result.text[lowerRange.upperBound...upperRange.lowerBound])
                    self.name = self.name.trimmingCharacters(in: .whitespaces)
                    self.foundCard = true
                    self.getDataFromDatabase(name: self.name)
                    self.directionsLabel.text = "Name Found!"
                }
            }
        }
    }
    
    @IBAction func longPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            self.directionsLabel.text = "Scanning..."
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
                    }
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}
