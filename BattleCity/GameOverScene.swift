import Foundation
import SpriteKit

final class GameOverScene: SKScene {

    private var button: SKSpriteNode!
    private let score: Int

    init(size: CGSize, score: Int) {
        self.score = score
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        button = SKSpriteNode(color: .red, size: CGSize(width: 200, height: 100))
        button.position = CGPoint(x: size.width / 2, y: size.height / 2)

        let textLabel = SKLabelNode(text: "Main Menu")
        textLabel.verticalAlignmentMode = .center
        button.addChild(textLabel)

        let highScoreText = SKLabelNode(text: "Score: \(score)")
        highScoreText.position = CGPoint(x: size.width / 2, y: size.height / 2 - 100)

        addChild(button)
        addChild(highScoreText)
    }

    override func mouseDown(with event: NSEvent) {
        if button.contains(event.location(in: self)) {
            let mainScene = MainScene(size: Constants.screenSize)
            scene?.scaleMode = .aspectFill

            self.view?.presentScene(mainScene, transition: .crossFade(withDuration: 0.5))
        }
    }
}
