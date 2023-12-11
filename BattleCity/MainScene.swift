import SpriteKit

class MainScene: SKScene {

    private var button: SKSpriteNode!

    override func didMove(to view: SKView) {
        button = SKSpriteNode(color: .red, size: CGSize(width: 200, height: 100))
        button.position = CGPoint(x: size.width / 2, y: size.height / 2)

        let textLabel = SKLabelNode(text: "Start")
        textLabel.verticalAlignmentMode = .center
        button.addChild(textLabel)

        let highScoreText = SKLabelNode(text: "High Score: \(UserDefaults.standard.integer(forKey: "high_score"))")
        highScoreText.position = CGPoint(x: size.width / 2, y: size.height / 2 - 100)

        addChild(button)
        addChild(highScoreText)
    }

    override func mouseDown(with event: NSEvent) {
        if button.contains(event.location(in: self)) {
            let gameScene = GameScene(size: Constants.screenSize)
            scene?.scaleMode = .aspectFill

            self.view?.presentScene(gameScene, transition: .crossFade(withDuration: 0.5))
        }
    }
}
