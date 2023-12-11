import SpriteKit

final class MainScene: SKScene {

    private var easyButton: SKSpriteNode!
    private var normalButton: SKSpriteNode!
    private var hardButton: SKSpriteNode!

    override func didMove(to view: SKView) {
        easyButton = SKSpriteNode(color: .red, size: CGSize(width: 150, height: 50))
        easyButton.position = CGPoint(x: size.width / 2, y: size.height / 2 + 100)

        normalButton = SKSpriteNode(color: .red, size: CGSize(width: 150, height: 50))
        normalButton.position = CGPoint(x: size.width / 2, y: size.height / 2)

        hardButton = SKSpriteNode(color: .red, size: CGSize(width: 150, height: 50))
        hardButton.position = CGPoint(x: size.width / 2, y: size.height / 2 - 100)

        let easyTextLabel = SKLabelNode(text: "Easy")
        easyTextLabel.verticalAlignmentMode = .center
        easyButton.addChild(easyTextLabel)

        let normalTextLabel = SKLabelNode(text: "Normal")
        normalTextLabel.verticalAlignmentMode = .center
        normalButton.addChild(normalTextLabel)

        let hardTextLabel = SKLabelNode(text: "Hard")
        hardTextLabel.verticalAlignmentMode = .center
        hardButton.addChild(hardTextLabel)

        let highScoreText = SKLabelNode(text: "High Score: \(UserDefaults.standard.integer(forKey: "highScore"))")
        highScoreText.position = CGPoint(x: size.width / 2, y: size.height / 2 + 200)

        addChild(easyButton)
        addChild(normalButton)
        addChild(hardButton)
        addChild(highScoreText)
    }

    override func mouseDown(with event: NSEvent) {
        if easyButton.contains(event.location(in: self)) {
            let gameScene = GameScene(size: Constants.screenSize, difficulty: .easy)
            scene?.scaleMode = .aspectFill

            self.view?.presentScene(gameScene, transition: .crossFade(withDuration: 0.5))
        } else if normalButton.contains(event.location(in: self)) {
            let gameScene = GameScene(size: Constants.screenSize, difficulty: .normal)
            scene?.scaleMode = .aspectFill

            self.view?.presentScene(gameScene, transition: .crossFade(withDuration: 0.5))
        } else if hardButton.contains(event.location(in: self)) {
            let gameScene = GameScene(size: Constants.screenSize, difficulty: .hard)
            scene?.scaleMode = .aspectFill

            self.view?.presentScene(gameScene, transition: .crossFade(withDuration: 0.5))
        }
    }
}
