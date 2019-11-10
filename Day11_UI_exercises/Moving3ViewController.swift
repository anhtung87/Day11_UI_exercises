//
//  Moving3ViewController.swift
//  Day11_UI_exercises
//
//  Created by Hoang Tung on 11/10/19.
//  Copyright © 2019 Hoang Tung. All rights reserved.
//

import UIKit

class Moving3ViewController: UIViewController {

    var ball: BallView!
    let radius: CGFloat = 50.0
    var timer: Timer!
    
    var quarterHeight: CGFloat {
        return CGFloat(Int(self.view.frame.maxY / 4))
    }
    var halfHeight: CGFloat {
        return CGFloat(Int(self.view.frame.maxY / 2))
    }
    var threePartFourHeight: CGFloat {
        return CGFloat(Int(self.view.frame.maxY / 4 * 3))
    }
    
    var changedDirectPoints: [CGPoint] {
        return [
            CGPoint(x: self.radius, y: self.radius),
//            CGPoint(x: self.view.frame.maxX - self.radius, y: self.radius),
            CGPoint(x: self.view.frame.maxX - self.radius, y: self.quarterHeight),
//            CGPoint(x: self.radius, y: self.quarterHeight),
            CGPoint(x: self.radius, y: self.halfHeight),
//            CGPoint(x: self.view.frame.maxX - self.radius, y: self.halfHeight),
            CGPoint(x: self.view.frame.maxX - self.radius, y: self.threePartFourHeight),
//            CGPoint(x: self.radius, y: self.threePartFourHeight),
            CGPoint(x: self.radius, y: self.view.frame.maxY - self.radius),
            CGPoint(x: self.view.frame.maxX - self.radius, y: self.view.frame.maxY - self.radius),
//            CGPoint(x: self.view.frame.maxX - self.radius, y: self.threePartFourHeight),
            CGPoint(x: self.radius, y: self.threePartFourHeight),
//            CGPoint(x: self.radius, y: self.halfHeight),
            CGPoint(x: self.view.frame.maxX - self.radius, y: self.halfHeight),
//            CGPoint(x: self.view.frame.maxX - self.radius, y: self.quarterHeight),
            CGPoint(x: self.radius, y: self.quarterHeight),
            CGPoint(x: self.view.frame.maxX - self.radius, y: self.radius),
        ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Tạo và hiển thị hình ảnh quả bóng với bán kính = radius.
        // Vị trí quả bóng được tạo là ở trên cùng bên trái màn hình.
        ball = BallView(
            center: CGPoint(x: radius, y: radius),
            radius: radius,
            color: UIColor.systemBlue,
            boundary: CGPoint(x: self.view.frame.maxX, y: self.view.frame.maxY))
        view.addSubview(ball)
        ball.changedDirectionPoints = self.changedDirectPoints
        ball.startPoint = ball.changedDirectionPoints[0]
        ball.endPoint = ball.changedDirectionPoints[1]
        ball.line = ball.drawLine(startPoint: ball.startPoint, endPoint: ball.endPoint)
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(runTimer), userInfo: nil, repeats: true)
    }
    
    @objc func runTimer() {
        self.ball.move()
    }

}
