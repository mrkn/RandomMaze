//
//  Maze.swift
//  RandomMaze
//
//  Created by Kenta Murata on 2019/01/26.
//  Copyright © 2019 mrkn.jp. All rights reserved.
//

import UIKit

class Maze: NSObject {
    public let width: Int
    public let height: Int

    var maxSite: Int { return width * height / 4 }

    let dx = [ 2, 0, -2, 0 ]
    let dy = [ 0, 2, 0, -2 ]
    let dirtable = [ [0,1,2,3], [0,1,3,2], [0,2,1,3], [0,2,3,1], [0,3,1,2], [0,3,2,1],
                     [1,0,2,3], [1,0,3,2], [1,2,0,3], [1,2,3,0], [1,3,0,2], [1,3,2,0],
                     [2,0,1,3], [2,0,3,1], [2,1,0,3], [2,1,3,0], [2,3,0,1], [2,3,1,0],
                     [3,0,1,2], [3,0,2,1], [3,1,0,2], [3,1,2,0], [3,2,0,1], [3,2,1,0] ]

    var area: [Bool]!
    var nsite: Int = 0
    var xx: [Int]!
    var yy: [Int]!

    let minVisibleX: Int = 2
    let minVisibleY: Int = 2
    var maxVisibleX: Int { return width - 2 }
    var maxVisibleY: Int { return height - 2 }

    init(_ width: Int, _ height: Int) {
        assert(width > 0, "width must be positive")
        assert(height > 0, "height must be positive")
        assert(width % 2 == 0, "width must be even")
        assert(height % 2 == 0, "height must be even")

        self.width = width
        self.height = height

        super.init()
        self.clear()
    }

    func linearIndex(_ x:Int, _ y:Int) -> Int {
        return x + y*(width+1)
    }

    func indexIsValid(_ x:Int, _ y:Int) -> Bool {
        return 0 <= x && x <= width && 0 <= y && y <= height
    }

    func isVisible(_ x: Int, _ y: Int) -> Bool {
        return minVisibleX <= x && x <= maxVisibleX && minVisibleY <= y && y <= maxVisibleY
    }

    var updateCallback: ((Int, Int) -> Void)?

    subscript(x:Int, y:Int) -> Bool {
        get {
            if indexIsValid(x, y) {
                return area[linearIndex(x, y)]
            }
            return true // all of out bound area are walls
        }
        set(newValue) {
            if indexIsValid(x, y) {
                area[linearIndex(x, y)] = newValue
                if updateCallback != nil && isVisible(x, y) {
                    updateCallback!(x, y)
                }
            }
        }
    }

    func addSite(_ i:Int, _ j:Int) {
        xx[nsite] = i
        yy[nsite] = j
        self.nsite += 1
    }
    
    func selectSite() -> (Bool, Int, Int) {
        if (nsite == 0) {
            return (false, -1, -1)
        }

        self.nsite -= 1
        let r = nsite == 0 ? 0 : Int.random(in: 0..<nsite)
        let i = xx[r]
        xx[r] = xx[nsite]
        let j = yy[r]
        yy[r] = yy[nsite]
        return (true, i, j)
    }

    private func withUpdateCallback(_ callback: @escaping (Int, Int) -> Void, block: @convention(block) () -> Void) {
        let last = updateCallback
        self.updateCallback = callback
        block()
        self.updateCallback = last
    }

    func clear() {
        self.area = [Bool](repeating: false, count: (width+1) * (height+1))
    }

    private func initMaze() {
        for i in 0..<self.area.count {
            self.area[i] = false
        }

        for i in minVisibleX...maxVisibleX {
            self[i, minVisibleY] = true
            self[i, maxVisibleY] = true
        }
        for j in minVisibleY...maxVisibleY {
            self[minVisibleX, j] = true
            self[maxVisibleX, j] = true
        }
        self[minVisibleX, minVisibleY + 1] = false
        self[maxVisibleX, maxVisibleY - 1] = false

        self.xx = [Int](repeating: 0, count: maxSite)
        self.yy = [Int](repeating: 0, count: maxSite)

        for i in stride(from: minVisibleX+2, to: maxVisibleX-2, by: 2) {
            addSite(i, minVisibleY)
            addSite(i, maxVisibleY)
        }

        for j in stride(from: minVisibleY+2, to: maxVisibleY-2, by: 2) {
            addSite(minVisibleX, j)
            addSite(maxVisibleX, j)
        }
    }

    private func makeMaze() {
        while true {
            print("nsite: %d", nsite)
            var (success, i, j) = selectSite()
            if !success { break }
            print("nsite: %d", nsite)

            while true {
                let tt = dirtable[Int.random(in: 0..<24)]

                var i1 = 0, j1 = 0
                var d = 3
                while d >= 0 {
                    let t = tt[d]
                    i1 = i + dx[t]
                    j1 = j + dy[t]
                    if (!self[i1, j1]) { break }
                    d -= 1
                }
                if (d < 0) { break }

                self[(i + i1) / 2, (j + j1) / 2] = true
                i = i1
                j = j1
                self[i, j] = true
                addSite(i, j)
            }
        }
    }

    public func resetMaze() {
        initMaze()
        makeMaze()
    }
}
