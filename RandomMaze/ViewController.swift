//
//  ViewController.swift
//  RandomMaze
//
//  Created by Kenta Murata on 2019/01/16.
//  Copyright © 2019 mrkn.jp. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var mazeView: MazeView!
    @IBOutlet var drawingImageView: UIImageView!

    let drawingWait = 0.01
    let strokeWidth: CGFloat = 12.0
    let strokeColor = UIColor(hue: 85/360.0, saturation: 0.7, brightness: 0.7, alpha: 1.0)

    var maze: Maze!
    var mazeWidth: Int = 0
    var mazeHeight: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let mazeView = self.mazeView else { return }
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.tripleTapDetected(_:)))
        gestureRecognizer.numberOfTapsRequired = 3
        gestureRecognizer.numberOfTouchesRequired = 2
        mazeView.addGestureRecognizer(gestureRecognizer)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        initDrawingImage()

        guard let mazeView = self.mazeView else { return }

        self.mazeWidth = 2 * (Int(mazeView.bounds.width / MazeView.blockWidth) / 2)
        self.mazeHeight = 2 * (Int(mazeView.bounds.height / MazeView.blockWidth) / 2)
        self.maze = Maze(mazeWidth, mazeHeight)
        mazeView.maze = self.maze

        self.maze.resetMaze()
        mazeView.setNeedsDisplay()
    }

    @objc func tripleTapDetected(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            guard let mazeView = self.mazeView else { return }

            initDrawingImage()

            self.maze.clear()
            self.maze.resetMaze()
            mazeView.setNeedsDisplay()
        }
    }

    func initDrawingImage() {
        guard let mazeView = self.mazeView else { return }
        guard let imageView = self.drawingImageView else { return }

        UIGraphicsBeginImageContextWithOptions(mazeView.bounds.size, true, 0.0)
        UIColor.white.setFill()
        UIRectFill(imageView.bounds)
        imageView.image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
    }

    var lastLocation: CGPoint?

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let mazeView = self.mazeView else { return }
        let touch = touches.first!
        lastLocation = touch.location(in: mazeView)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let lastLocation = self.lastLocation else { return }
        guard let mazeView = self.mazeView else { return }
        guard let imageView = self.drawingImageView else { return }
        guard let lastImage = imageView.image else { return }

        UIGraphicsBeginImageContextWithOptions(mazeView.bounds.size, true, 0.0)
        lastImage.draw(at: CGPoint(x: 0, y: 0))

        let path = UIBezierPath()
        path.move(to: lastLocation)

        let touch = touches.first!
        let currentLocation = touch.location(in: mazeView)
        path.addLine(to: currentLocation)
        self.lastLocation = currentLocation

        strokeColor.setStroke()
        path.lineWidth = strokeWidth
        path.lineCapStyle = .round
        path.lineJoinStyle = .round
        path.stroke()

        imageView.image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
    }
}
