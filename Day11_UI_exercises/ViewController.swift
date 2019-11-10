//
//  ViewController.swift
//  Day11_UI_exercises
//
//  Created by Hoang Tung on 11/8/19.
//  Copyright © 2019 Hoang Tung. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var ball: BallView!
    let radius: CGFloat = 50.0
    var y: CGFloat = 100.0
    var timer: Timer!

    var isGoingDown: Bool = true
    
    var speed: Float! = 0.0
    var acceleration: Float = 9.8
    var seconds: Float = 0.01

    var maxHeight: CGFloat! = 0
    let ratio: Float = 200.0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ball = BallView(
            center: CGPoint(x: view.bounds.midX, y: y),
            radius: radius,
            color: UIColor.systemRed,
            boundary: CGPoint(x: self.view.frame.maxX, y: self.view.frame.maxY))
        view.addSubview(ball)
        
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(dropBall), userInfo: nil, repeats: true)
    }
    
    @objc func dropBall() {
        if self.isGoingDown {
            speed += acceleration * seconds
            self.ball.center.y += CGFloat(speed * seconds * ratio)
            if self.ball.center.y >= self.view.bounds.maxY - self.radius {
                self.isGoingDown = !self.isGoingDown
                if maxHeight >= self.view.frame.maxY - self.radius {
                    self.ball.center.y = self.view.frame.maxY - self.radius
                    timer.invalidate()
                }
            }
        } else {
            speed -= acceleration * seconds
            self.ball.center.y -= CGFloat(speed * seconds * ratio * 0.8)
            if self.speed <= 0 {
                speed = 0
                self.isGoingDown = !self.isGoingDown
                maxHeight = self.ball.center.y
            }
        }
    }
}

