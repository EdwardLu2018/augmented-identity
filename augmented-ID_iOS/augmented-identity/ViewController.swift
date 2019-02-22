//
//  ViewController.swift
//  augmented-identity
//
//  Created by Edward on 2/9/19.
//  Copyright © 2019 Edward. All rights reserved.
//

import UIKit
import ARKit
import SpriteKit
import Foundation
import Firebase
import Alamofire

class ViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate {
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var directionsLabel: UILabel!
    
    let textRecognizer = Vision.vision().onDeviceTextRecognizer()
    var imageFromArkitScene: UIImage?
    
    let cardInfoScene: SKScene = SKScene(fileNamed: "card-info")!
    let skillsScene: SKScene = SKScene(fileNamed: "skills")!
    let gitScene: SKScene = SKScene(fileNamed: "github")!
    let gitInfoScene: SKScene = SKScene(fileNamed: "GHInfo")!
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
    let moveDuration: TimeInterval = 5
    
    lazy var fadeOutAction: SCNAction = {
        return .sequence([
            .fadeOpacity(by: -1, duration: fadeDuration)
            ])
    }()
    
    lazy var fadeInAction: SCNAction = {
        return .sequence([
            .fadeOpacity(by: 0.9, duration: fadeDuration)
            ])
    }()
    
    lazy var move: SCNAction = {
        return .sequence([
            .moveBy(x: 1, y: 0, z: 0, duration: moveDuration)
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.sceneView.addGestureRecognizer(tapGesture)
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
        
        let infoPlane = SCNPlane(width: referenceImage.physicalSize.width, height: referenceImage.physicalSize.height * 0.6)
        infoPlane.cornerRadius = infoPlane.width / 25
        
        infoPlane.firstMaterial?.diffuse.contents = cardInfoScene
        infoPlane.firstMaterial?.isDoubleSided = true
        infoPlane.firstMaterial?.diffuse.contentsTransform = SCNMatrix4Translate(SCNMatrix4MakeScale(1, -1, 1), 0, 1, 0)
        
        let infoPlaneNode = SCNNode(geometry: infoPlane)
        infoPlaneNode.name = "infoPlaneNode"
        infoPlaneNode.eulerAngles.x = -.pi / 2
        infoPlaneNode.opacity = 0.10
        infoPlaneNode.position.z = -0.048
        
        infoPlaneNode.runAction(self.fadeInAction)
        
        node.addChildNode(infoPlaneNode)
        
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
            
            let skillsPlane = SCNPlane(width: referenceImage.physicalSize.width, height: referenceImage.physicalSize.height * 3.15)
            skillsPlane.cornerRadius = skillsPlane.width / 25
            
            skillsPlane.firstMaterial?.diffuse.contents = skillsScene
            skillsPlane.firstMaterial?.isDoubleSided = true
            skillsPlane.firstMaterial?.diffuse.contentsTransform = SCNMatrix4Translate(SCNMatrix4MakeScale(1, -1, 1), 0, 1, 0)
            
            let skillsPlaneNode = SCNNode(geometry: skillsPlane)
            skillsPlaneNode.name = "skillsNode"
            skillsPlaneNode.eulerAngles.x = -.pi / 2
            skillsPlaneNode.opacity = 0.10
            skillsPlaneNode.position.z = 0.0216
            skillsPlaneNode.position.x = 0.093
            
            skillsPlaneNode.runAction(self.fadeInAction)
            
            node.addChildNode(skillsPlaneNode)
            
            if let gitTitleLabel = gitInfoScene.childNode(withName: "projectName") as? SKLabelNode {
                gitTitleLabel.text = self.gitTitle
            }
            
            if let gitDescriptionLabel = gitInfoScene.childNode(withName: "projectDescription") as? SKLabelNode {
                gitDescriptionLabel.text = self.gitDescript
            }
            
            let gitPlane = SCNPlane(width: 0.015, height: 0.015)
            gitPlane.cornerRadius = 4.5
            
            gitPlane.firstMaterial?.diffuse.contents = gitScene
            gitPlane.firstMaterial?.isDoubleSided = true
            gitPlane.firstMaterial?.diffuse.contentsTransform = SCNMatrix4Translate(SCNMatrix4MakeScale(1, -1, 1), 0, 1, 0)
            
            let gitPlaneNode = SCNNode(geometry: gitPlane)
            gitPlaneNode.name = "gitNode"
            gitPlaneNode.eulerAngles.x = -.pi / 2
            gitPlaneNode.opacity = 0.10
            gitPlaneNode.position.x = -0.034
            gitPlaneNode.position.z = 0.040
            
            gitPlaneNode.runAction(self.fadeInAction)
            
            node.addChildNode(gitPlaneNode)
            
            let gitInfoPlane = SCNPlane(width: referenceImage.physicalSize.width, height: referenceImage.physicalSize.height)
            gitInfoPlane.cornerRadius = gitInfoPlane.width / 25
        
            gitInfoPlane.firstMaterial?.diffuse.contents = gitInfoScene
            gitInfoPlane.firstMaterial?.isDoubleSided = true
            gitInfoPlane.firstMaterial?.diffuse.contentsTransform = SCNMatrix4Translate(SCNMatrix4MakeScale(1, -1, 1), 0, 1, 0)
        
            let gitInfoPlaneNode = SCNNode(geometry: gitInfoPlane)
            gitInfoPlaneNode.name = "gitInfoNode"
            gitInfoPlaneNode.eulerAngles.x = -.pi / 2
            gitInfoPlaneNode.opacity = 0.10
            gitInfoPlaneNode.position.z = Float(0.052 + (gitInfoPlane.height / 2.0))
            
            if (self.gitPressed) {
                gitInfoPlaneNode.runAction(self.fadeInAction)
                
                node.addChildNode(gitInfoPlaneNode)
            }
            
            let FBPlane = SCNPlane(width: 0.015, height: 0.015)
            FBPlane.cornerRadius = 4.5
            
            FBPlane.firstMaterial?.diffuse.contents = FBScene
            FBPlane.firstMaterial?.isDoubleSided = true
            FBPlane.firstMaterial?.diffuse.contentsTransform = SCNMatrix4Translate(SCNMatrix4MakeScale(1, -1, 1), 0, 1, 0)
            
            let FBPlaneNode = SCNNode(geometry: FBPlane)
            FBPlaneNode.name = "FBNode"
            FBPlaneNode.eulerAngles.x = -.pi / 2
            FBPlaneNode.opacity = 0.10
            FBPlaneNode.position.x = -0.012
            FBPlaneNode.position.z = 0.040
            
            FBPlaneNode.runAction(self.fadeInAction)
            
            node.addChildNode(FBPlaneNode)
            
            let LIPlane = SCNPlane(width: 0.015, height: 0.015)
            LIPlane.cornerRadius = 4.5
            
            LIPlane.firstMaterial?.diffuse.contents = LIScene
            LIPlane.firstMaterial?.isDoubleSided = true
            LIPlane.firstMaterial?.diffuse.contentsTransform = SCNMatrix4Translate(SCNMatrix4MakeScale(1, -1, 1), 0, 1, 0)
            
            let LIPlaneNode = SCNNode(geometry: LIPlane)
            LIPlaneNode.name = "LINode"
            LIPlaneNode.eulerAngles.x = -.pi / 2
            LIPlaneNode.opacity = 0.10
            LIPlaneNode.position.x = 0.010
            LIPlaneNode.position.z = 0.040
            
            LIPlaneNode.runAction(self.fadeInAction)
            
            node.addChildNode(LIPlaneNode)
            
            let personalPlane = SCNPlane(width: 0.015, height: 0.015)
            personalPlane.cornerRadius = 4.5
            
            personalPlane.firstMaterial?.diffuse.contents = personalScene
            personalPlane.firstMaterial?.isDoubleSided = true
            personalPlane.firstMaterial?.diffuse.contentsTransform = SCNMatrix4Translate(SCNMatrix4MakeScale(1, -1, 1), 0, 1, 0)
            
            let personalPlaneNode = SCNNode(geometry: personalPlane)
            personalPlaneNode.name = "personalNode"
            personalPlaneNode.eulerAngles.x = -.pi / 2
            personalPlaneNode.opacity = 0.10
            personalPlaneNode.position.x = 0.032
            personalPlaneNode.position.z = 0.040
            
            personalPlaneNode.runAction(self.fadeInAction)
            
            node.addChildNode(personalPlaneNode)
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
                    self.sendAndReceiveFromServer(params: ["name": self.name], url: "server/tasks") // server address goes here
                    self.directionsLabel.text = "Name Recognized!"
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
    
    @objc
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {let location = gestureRecognize.location(in: self.sceneView)
        let hitResults = self.sceneView.hitTest(location, options: [:])
        
        if hitResults.count > 0 {
            let tappedNode = hitResults[0].node
            if (tappedNode.name == "gitNode") {
                if (self.gitPressed){
                    UIApplication.shared.openURL(NSURL(string: self.gitLink)! as URL)
                }
                self.gitPressed = true
            }
            else if (tappedNode.name == "FBNode") {
                UIApplication.shared.openURL(NSURL(string: self.FBLink)! as URL)
            }
            else if (tappedNode.name == "LINode") {
                UIApplication.shared.openURL(NSURL(string: self.LInk)! as URL)
            }
            else if (tappedNode.name == "personalNode") {
                UIApplication.shared.openURL(NSURL(string: self.personalLink)! as URL)
            }
        }
    }
    
    func sendAndReceiveFromServer(params : Dictionary<String, String>, url : String) {
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default)
            .responseJSON { response in
                //to get status code
                if let status = response.response?.statusCode {
                    switch(status){
                    case 201:
                        print("example success")
                    default:
                        print("error with response status: \(status)")
                    }
                }
                //to get JSON return value
                if let result = response.result.value {
                    let JSONDict = result as! NSDictionary
                    let JSONArr: NSArray = Array(JSONDict)[0].value as! NSArray
                    
                    let gitArr: NSArray = JSONArr[2] as! NSArray
                    self.gitTitle = gitArr[0] as! String
                    self.gitDescript = gitArr[1] as! String
                    self.gitLink = gitArr[2] as! String

                    self.FBLink = JSONArr[3] as! String
                    self.LInk = JSONArr[4] as! String
                    self.personalLink = JSONArr[5] as! String
                    
                    let skills = JSONArr[6] as! NSArray
                    self.skill1 = skills[0] as! String
                    self.skill2 = skills[1] as! String
                    self.skill3 = skills[2] as! String
                    self.skill4 = skills[3] as! String
                    self.skill5 = skills[4] as! String
                    
                    if (JSONArr[0] as! String == "") {
                        self.major = "No Profile"
                        self.foundCard = false
                    }
                    else {
                        self.major = JSONArr[7] as! String
                    }
                }
        }
    }

}
