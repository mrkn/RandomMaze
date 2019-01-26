//
//  MazeView.swift
//  RandomMaze
//
//  Created by Kenta Murata on 2019/01/26.
//  Copyright © 2019 mrkn.jp. All rights reserved.
//

import UIKit

class MazeView: UIView {
    public static let blockWidth: CGFloat = 36
    
    var blockWidth: CGFloat { return MazeView.blockWidth }
    
    public var maze: Maze!

    func drawBlock(_ i: Int, _ j: Int) {
        let x = CGFloat(i) * blockWidth
        let y = CGFloat(j) * blockWidth
        UIRectFill(CGRect(x: x, y: y, width: blockWidth, height: blockWidth))
    }
    
    func updateBlock(_ i: Int, _ j: Int) {
        let x = CGFloat(i) * blockWidth
        let y = CGFloat(j) * blockWidth
        setNeedsDisplay(CGRect(x: x, y: y, width: blockWidth, height: blockWidth))
    }
    
    override func draw(_ rect: CGRect) {
        UIColor.white.setFill()
        UIRectFill(rect)

        guard let maze = self.maze else { return }

        UIColor.black.setFill()
        let minI = max(maze.minVisibleX, Int(floor(rect.minX / blockWidth)))
        let maxI = min(maze.maxVisibleX, Int(ceil(rect.maxX / blockWidth)))
        let minJ = max(maze.minVisibleY, Int(floor(rect.minY / blockWidth)))
        let maxJ = min(maze.maxVisibleY, Int(ceil(rect.maxY / blockWidth)))
        for j in minJ...maxJ {
            for i in minI...maxI {
                if maze[i, j] {
                    drawBlock(i, j)
                }
            }
        }
    }
}
