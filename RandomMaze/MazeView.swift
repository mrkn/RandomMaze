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

    func drawBlock(_ i: Int, _ j: Int, _ north: Bool, _ south: Bool, _ west: Bool, _ east: Bool) {
        let x = CGFloat(i) * blockWidth
        let y = CGFloat(j) * blockWidth
        let d = blockWidth / 3

        // center
        UIRectFill(CGRect(x: x+d, y: y+d, width: d, height: d))

        if (north) {
            UIRectFill(CGRect(x: x+d, y: y-2*d, width: d, height: 4*d))
        }
        if (south) {
            UIRectFill(CGRect(x: x+d, y: y+d, width: d, height: 4*d))
        }
        if (west) {
            UIRectFill(CGRect(x: x-2*d, y: y+d, width: 4*d, height: d))
        }
        if (east) {
            UIRectFill(CGRect(x: x+d, y: y+d, width: 4*d, height: d))
        }
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
                    let n = maze[i, j-1] && maze.isVisible(i, j-1)
                    let s = maze[i, j+1] && maze.isVisible(i, j+1)
                    let w = maze[i-1, j] && maze.isVisible(i-1, j)
                    let e = maze[i+1, j] && maze.isVisible(i+1, j)

                    drawBlock(i, j, n, s, w, e)
                }
            }
        }
    }
}
