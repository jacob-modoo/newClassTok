//
//  SnowScene.swift
//  modooClass
//
//  Created by 조현민 on 2019/12/12.
//  Copyright © 2019 조현민. All rights reserved.
//

import Foundation
import SpriteKit

class SnowScene: SKScene {

    private var presentingView: SKView?
    private var emitter: SKEmitterNode?

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        scaleMode = .resizeFill
        backgroundColor = UIColor.clear
        presentingView = view
    }

    // 눈 내리는 효과 시작
    func startEmitter() {
        emitter = SKEmitterNode(fileNamed: "Snow.sks")
        guard
            let emitter = emitter,
            let presentingView = presentingView
            else { return }

        emitter.particlePositionRange = CGVector(dx: presentingView.bounds.width, dy: 0)
        emitter.position = CGPoint(x:presentingView.bounds.midX, y:presentingView.bounds.height)
        emitter.targetNode = self

        addChild(emitter)
    }

    // 눈 내리는 효과 정지
    func stopEmitter() {
        guard let emitter = emitter else { return }
        emitter.particleBirthRate = 0.0
        emitter.targetNode = nil
        emitter.removeFromParent()
        self.emitter = nil
    }
}

////그리고 메인 ViewController에서 SnowScene을 보여줄 SKView, SnowScene 변수를 선언합니다.
//

//@IBOutlet weak private var snowView: UIView!
//private var sceneView: SKView?
//private var snowScene: SnowScene?

////이제 sceneView와 snowScene을 생성하여 UIView인 snowView에 붙여줍니다.
//

//override func viewDidLoad() {
//    super.viewDidLoad()
//
//    sceneView = SKView(frame: self.view.frame)
//    snowScene = SnowScene()
//    guard
//        let sceneView = sceneView,
//        let snowScene = snowScene
//        else { return }
//    sceneView.backgroundColor = UIColor.clearColor()
//    sceneView.presentScene(snowScene)
//    snowView.addSubview(sceneView)
//
//    // 밑에 있는 뷰가 터치를 먹도록 설정
//    sceneView.userInteractionEnabled = false
//    snowView.userInteractionEnabled = false
//}

////그리고 화면이 나타나면 눈 내리는 효과를 시작하도록 합니다.

//
//override func viewDidAppear(animated: Bool) {
//    super.viewDidAppear(animated)
//
//    guard let snowScene = snowScene else { return }
//    snowScene.startEmitter()
//}
