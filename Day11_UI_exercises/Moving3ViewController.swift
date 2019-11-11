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
    let radius: CGFloat = 20.0
    var timer: Timer!
    
    var oneThirdHeight: CGFloat {
        return CGFloat(Int(self.view.frame.maxY / 3))
    }
    var TwoThirdHeight: CGFloat {
        return CGFloat(Int(self.view.frame.maxY / 3 * 2))
    }
    
    var changedDirectPoints: [CGPoint] {
        return [
            CGPoint(x: self.radius, y: self.radius),
            CGPoint(x: self.view.frame.maxX - self.radius, y: self.oneThirdHeight),
            CGPoint(x: self.radius, y: self.TwoThirdHeight),
            CGPoint(x: self.view.frame.maxX - self.radius, y: self.view.frame.maxY - self.radius),
            CGPoint(x: self.radius, y: self.view.frame.maxY - self.radius),
            CGPoint(x: self.view.frame.maxX - self.radius, y: self.TwoThirdHeight),
            CGPoint(x: self.radius, y: self.oneThirdHeight),
            CGPoint(x: self.view.frame.maxX - self.radius, y: self.radius)
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
        
        // Cài đặt đoạn đường di chuyển đầu tiên cho đối tượng.
        // Lý do:
        // Khi khởi tạo đối tượng, đối tượng được cài đặt mặc định đoạn đường di chuyển từ góc trên bên trái sang góc trên bên phải màn hình. Nếu muốn di chuyển theo hướng khác, phải cài đặt lại điểm bắt đầu, điểm kết thúc và mảng các điểm trên đường đi chuyển.
        ball.startPoint = ball.changedDirectionPoints[0]
        ball.endPoint = ball.changedDirectionPoints[1]
        ball.line = ball.drawLine(startPoint: ball.startPoint, endPoint: ball.endPoint)
        
        timer = Timer.scheduledTimer(timeInterval: 0.007, target: self, selector: #selector(runTimer), userInfo: nil, repeats: true)
    }
    
    @objc func runTimer() {
        self.ball.move()
    }

}
