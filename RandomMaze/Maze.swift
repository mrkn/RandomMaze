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

    init(_ width: Int, _ height: Int) {
        assert(width > 0, "width must be positive")
        assert(height > 0, "height must be positive")
        assert(width % 2 == 0, "width must be even")
        assert(height % 2 == 0, "height must be even")

        self.width = width
        self.height = height

        super.init()
    }

    func linearIndex(_ x:Int, _ y:Int) -> Int {
        return x + y*(width+1)
    }

    func indexIsValid(_ x:Int, _ y:Int) -> Bool {
        return 0 <= x && x <= width && 0 <= y && y <= height
    }

    subscript(x:Int, y:Int) -> Bool {
        get {
            if indexIsValid(x, y) {
                return area[linearIndex(x, y)]
            }
            return true
        }
        set(newValue) {
            if indexIsValid(x, y) {
                area[linearIndex(x, y)] = newValue
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
    
    func initMaze() {
        self.area = [Bool](repeating: false, count: (width+1) * (height+1))

        for i in 2...(width-2) {
            self[i, 2] = true
            self[i, height-2] = true
        }
        for j in 2...(height-2) {
            self[2, j] = true
            self[width-2, j] = true
        }
        self[2, 3] = false
        self[width-2, height-3] = false

        self.xx = [Int](repeating: 0, count: maxSite)
        self.yy = [Int](repeating: 0, count: maxSite)

        for i in stride(from: 4, to: width-4, by: 2) {
            addSite(i, 2)
            addSite(i, height-2)
        }

        for j in stride(from: 4, to: height-4, by: 2) {
            addSite(2, j)
            addSite(width-2, j)
        }
    }
    
    func makeMaze() {
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

    public func reset() {
        initMaze()
        makeMaze()
    }
}
