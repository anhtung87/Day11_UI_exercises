//
//  BallView.swift
//  Day11_UI_exercises
//
//  Created by Hoang Tung on 11/8/19.
//  Copyright © 2019 Hoang Tung. All rights reserved.
//

import UIKit

class BallView: UIView {
    // khởi tạo thuộc tính bán kính và màu sắc của hình tròn.
    // 2 thuộc tính này sẽ được khai báo khi khai báo đối tượng BallView.
    var radius: CGFloat!
    var color: UIColor!

    // thuộc tính boundaryLines lưu trữ các đường ranh giới. Nếu quả bóng chạm vào các đường này sẽ xảy ra hiệu ứng lăn.
    var boundaryLines: [[CGPoint]] = []
    
    // thuộc tính lưu trữ điểm đầu và điểm cuối của đoạn thẳng mà quả bóng đang di chuyển. Thuộc tính này sẽ thay đổi nếu quả bóng chuyển qua 1 đoạn thẳng khác.
    var startPoint: CGPoint!
    var endPoint: CGPoint!
    
    // Mảng toạ độ mà quả bóng sẽ thay đổi hướng đi khi chạm vào.
    var changedDirectionPoints: [CGPoint]!
    
    // thứ tự của toạ độ trong mảng toạ độ đổi hướng.
    // toạ độ này chính là điểm endPoint trên đoạn đường quả bóng đang đi.
    // lưu lại vị trí của toạ độ này để quả bóng biết cách lấy giá trị của toạ độ tiếp theo.
    // giá trị ban đầu của thuộc tính này bằng 1 vì điểm startPoint có thứ tự 0, và điểm endPoint có thứ tự 1 trong mảng toạ độ.
    var directPointIndex: Int = 1
    
    // góc nghiêng của quả bóng.
    var arcBall: CGFloat = 0.0
    
    // Mảng các điểm trên đoạn thẳng mà quả bóng sẽ di chuyển.
    // giá trị x, y của từng toạ độ là các số nguyên.
    var line: [CGPoint] = []
    
    // thứ tự của toạ độ mà quả bóng đang đứng đó.
    // thuộc tính này được sử dụng để tìm toạ độ tiếp theo của quả bóng.
    var lineIndex: Int = 0
    
    // toạ độ vị trí trước đó của tâm quả bóng.
    // giá trị này được lưu lại để vẽ vector hướng di chuyển của quả bóng.
    var periousCenter: CGPoint!
    
    // toạ độ vị trí sẽ va chạm với đường thẳng nếu đường thẳng nằm phía bên trái hướng đi của quả bóng.
    var leftPoint: CGPoint!
    
    // toạ độ vị trí sẽ va chạm với đường thẳng nếu đường thẳng nằm phía bên phải hướng đi của quả bóng.
    var rightPoint: CGPoint!
    
    convenience init(center: CGPoint, radius: CGFloat, color: UIColor, boundary: CGPoint) {
        self.init(
            frame: CGRect(
                x: center.x - radius,
                y: center.y - radius,
                width: radius * 2,
                height: radius * 2
            )
        )
        
        // Khai báo màu sắc và bán kính của đường tròn.
        self.color = color
        self.radius = radius
        
        // Khai báo toạ độ bắt đầu, toạ độ kết thúc và tập hợp các toạ độ nằm trên đoạn thẳng mà quả bóng sẽ di chuyển.
        self.startPoint = CGPoint(x: self.radius, y: self.radius)
        self.endPoint = CGPoint(x: boundary.x - self.radius, y: self.radius)
        self.line = self.drawLine(startPoint: self.startPoint, endPoint: self.endPoint)
        
        // Khai báo tập hợp các toạ độ trên các đoạn thẳng cho trước. Nếu quả bóng chạm vào các đoạn thẳng này sẽ xảy ra hiện tượng lăn.
        self.boundaryLines.append(self.drawLine(startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: boundary.x, y: 0)))
        self.boundaryLines.append(self.drawLine(startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 0, y: boundary.y)))
        self.boundaryLines.append(self.drawLine(startPoint: CGPoint(x: boundary.x, y: 0), endPoint: CGPoint(x: boundary.x, y: boundary.y)))
        self.boundaryLines.append(self.drawLine(startPoint: CGPoint(x: 0, y: boundary.y), endPoint: CGPoint(x: boundary.x, y: boundary.y)))
    }
    
    override func draw(_ rect: CGRect) {
        // Vẽ hình dạng cho quả bóng.
        let path = UIBezierPath(
            ovalIn: CGRect(x: 0, y: 0, width: radius * 2, height: radius * 2))
        let smallPath = UIBezierPath(
            ovalIn: CGRect(x: radius - radius / 6, y: 0, width: radius / 3, height: radius / 3))
        
        let circle = CAShapeLayer()
        circle.path = path.cgPath
        circle.fillColor = color.cgColor
        self.layer.addSublayer(circle)
        
        let smallCircle = CAShapeLayer()
        smallCircle.path = smallPath.cgPath
        smallCircle.fillColor = UIColor.white.cgColor
        
        self.layer.addSublayer(smallCircle)
    }
    
    // tập hợp và trình tự các phương thức mà đối tượng BallView phải thực hiện để đối tượng di chuyển từ điểm này sang điểm khác.
    func move() {
        // lưu lại giá trị toạ độ cuối cùng của tâm đường tròn.
        // toạ độ này được sử dụng đễ vẽ vector hướng di chuyển của đối tượng.
        self.rememberLastCenterPoint()
        
        // di chuyển hình ảnh của đối tượng từ toạ độ hiện tại sang toạ độ tiếp theo.
        self.moveToNextPoint()
        
        // Tìm 2 điểm va chạm với đoạn thẳng của đối tượng.
        self.findTouchPoints()
        
        // Tạo hiệu ứng lăn cho đối tượng bằng cách thay đổi góc nghiêng của hình ảnh.
        self.rotate()
        
        // Khi kết thúc đoạn thẳng, chuyển sang đoạn thẳng tiếp theo.
        if self.isFinishedLine() {
            self.switchToNextLine()
        }
    }
    
    // Thuật toán thay đổi toạ độ hình ảnh của đối tượng.
    // Đối tượng tính toán để chuyển toạ độ hình ảnh sang điểm tiếp theo trên đoạn thẳng mà đối tượng đã tính toán.
    func moveToNextPoint() {
        self.lineIndex += 1
        self.center = self.line[self.lineIndex]
    }
    
    // Phương thức tìm 2 điểm va chạm.
    // Phương thức này sẽ tính toán 2 toạ độ được dự đoán là có thể va chạm với đoạn thẳng đã tính.
    // 2 toạ độ này được tính toán bằng cách sử dụng công thức tính 2 vector vuông góc.
    // Với 2 toạ độ đã biết là toạ độ tâm hình tròn hiện tại và toạ độ tâm hình tròn trước đó (đã lưu trong thuộc tính periousCenter) => tìm ra vector biểu diễn hướng đi của đối tượng.
    // Khi đối tượng di chuyển, đối tượng được coi là di chuyển trên đoạn thẳng nếu:
    // - có 1 toạ độ trên đoạn thẳng (A) == toạ độ của hình tròn (B).
    // - vector được tạo bởi A và B vuông góc với vector hướng đi của quả bóng.
    // Với các dữ kiện đã có, để kiểm tra xem hình tròn có va chạm với đường thẳng không. Ta sẽ kiểm tra xem 1 trong 2 điểm va chạm có nằm trong mảng toạ độ đoạn thẳng không.
    // Công thức để tìm 2 vector vuông góc của 1 vector cho trước (vector A (x: a, y: b)) là:
    // - vector B1 (x: -b, y: a)
    // - vector B2 (x: b, y: -a)
    func findTouchPoints() {
        let vector: CGVector = CGVector(
            dx: self.center.x - self.periousCenter.x,
            dy: self.center.y - self.periousCenter.y)
        let vectorLeft: CGVector = CGVector(
            dx: self.radius * vector.dy,
            dy: -vector.dx * self.radius)
        let vectorRight: CGVector = CGVector(
            dx: self.radius * -vector.dy,
            dy: vector.dx * self.radius)
        let leftPoint: CGPoint = CGPoint(
            x: self.center.x + vectorLeft.dx,
            y: self.center.y + vectorLeft.dy)
        let rightPoint: CGPoint = CGPoint(
            x: self.center.x + vectorRight.dx,
            y: self.center.y + vectorRight.dy)
        self.leftPoint = leftPoint
        self.rightPoint = rightPoint
    }
    
    func isFinishedLine() -> Bool {
        return self.center == self.endPoint
    }
    
    func switchToNextLine() {
        if self.directPointIndex < self.changedDirectionPoints.count - 1 {
            self.directPointIndex += 1
        } else if self.directPointIndex == self.changedDirectionPoints.count - 1 {
            self.directPointIndex = 0
        }
        self.startPoint = self.endPoint
        self.endPoint = self.changedDirectionPoints[self.directPointIndex]
        self.line = self.drawLine(startPoint: self.startPoint, endPoint: self.endPoint)
        self.lineIndex = 0
    }
    
    func rotate() {
        if self.isTouchLeft() {
            self.rotateCounterClockwise()
        }
        if self.isTouchRight() {
            self.rotateClockwise()
        }
    }
    
    func rotateCounterClockwise() {
        self.arcBall -= CGFloat(1) / self.radius
        self.transform = CGAffineTransform(rotationAngle: self.arcBall)
    }
    
    func rotateClockwise() {
        self.arcBall += CGFloat(1) / self.radius
        self.transform = CGAffineTransform(rotationAngle: self.arcBall)
    }
    
    func isTouchLeft() -> Bool {
        for line in self.boundaryLines {
            for point in line {
                if self.leftPoint == point {
                    return true
                }
            }
        }
        return false
    }
    
    func isTouchRight() -> Bool {
        for line in self.boundaryLines {
            for point in line {
                if self.rightPoint == point {
                    return true
                }
            }
        }
        return false
    }
    
    func rememberLastCenterPoint() {
        self.periousCenter = self.center
    }
    
    func drawLine(startPoint: CGPoint, endPoint: CGPoint) -> [CGPoint] {
        let startX = Int(startPoint.x)
        let startY = Int(startPoint.y)
        let endX = Int(endPoint.x)
        let endY = Int(endPoint.y)
        var x = startX
        var y = startY
        let dX = abs(endX - startX)
        let dY = abs(endY - startY)
        var lineArray: [CGPoint] = []
        if startX < endX && startY <= endY && dX >= dY {
            var d = 2 * dY - dX
            while x < endX {
                x += 1
                if d < 0 {
                    d += 2 * dY
                } else {
                    y += 1
                    d += 2 * (dY - dX)
                }
                lineArray.append(CGPoint(x: x, y: y))
            }
        } else if startX <= endX && startY < endY && dX < dY {
            var d = 2 * dX - dY
            while y < endY {
                y += 1
                if d < 0 {
                    d += 2 * dX
                } else {
                    x += 1
                    d += 2 * (dX - dY)
                }
                lineArray.append(CGPoint(x: x, y: y))
            }
        } else if startX > endX && startY <= endY && dX > dY {
            var d = 2 * dY - dX
            while x > endX {
                x -= 1
                if d < 0 {
                    d += 2 * dY
                } else {
                    y += 1
                    d += 2 * (dY - dX)
                }
                lineArray.append(CGPoint(x: x, y: y))
            }
        } else if startX > endX && startY < endY && dX <= dY {
            var d = 2 * dX - dY
            while y < endY {
                y += 1
                if d < 0 {
                    d += 2 * dX
                } else {
                    x -= 1
                    d += 2 * (dX - dY)
                }
                lineArray.append(CGPoint(x: x, y: y))
            }
        } else if startX <= endX && startY > endY && dX >= dY {
            var d = 2 * dY - dX
            while x < endX {
                x += 1
                if d < 0 {
                    d += 2 * dY
                } else {
                    y -= 1
                    d += 2 * (dY - dX)
                }
                lineArray.append(CGPoint(x: x, y: y))
            }
        } else if startX <= endX && startY > endY && dX < dY {
            var d = 2 * dX - dY
            while y > endY {
                y -= 1
                if d < 0 {
                    d += 2 * dX
                } else {
                    x += 1
                    d += 2 * (dX - dY)
                }
                lineArray.append(CGPoint(x: x, y: y))
            }
        } else if startX > endX && startY > endY && dX >= dY {
            var d = 2 * dY - dX
            while x > endX {
                x -= 1
                if d < 0 {
                    d += 2 * dY
                } else {
                    y -= 1
                    d += 2 * (dY - dX)
                }
                lineArray.append(CGPoint(x: x, y: y))
            }
        } else if startX > endX && startY > endY && dX < dY {
            var d = 2 * dX - dY
            while y > endY {
                y -= 1
                if d < 0 {
                    d += 2 * dX
                } else {
                    x -= 1
                    d += 2 * (dX - dY)
                }
                lineArray.append(CGPoint(x: x, y: y))
            }
        }
        return lineArray
    }
}
