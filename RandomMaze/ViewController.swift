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

    var maze: Maze!
    var mazeWidth: Int = 0
    var mazeHeight: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let mazeView = self.mazeView else { return }
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.tripleTapDetected(_:)))
        gestureRecognizer.numberOfTapsRequired = 5
        mazeView.addGestureRecognizer(gestureRecognizer)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard let mazeView = self.mazeView else { return }

        self.mazeWidth = 2 * (Int(mazeView.bounds.width / MazeView.blockWidth) / 2)
        self.mazeHeight = 2 * (Int(mazeView.bounds.height / MazeView.blockWidth) / 2)
        self.maze = Maze(mazeWidth, mazeHeight)
        self.maze.reset()
        mazeView.maze = self.maze

        self.mazeView.setNeedsDisplay()
    }

    @objc func tripleTapDetected(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            self.maze.reset()
            self.mazeView.setNeedsDisplay()
        }
    }
}

