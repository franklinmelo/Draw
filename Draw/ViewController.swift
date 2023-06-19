//
//  ViewController.swift
//  Draw
//
//  Created by franklin melo on 06/06/23.
//

import UIKit

class Canvas: UIView {
    private var lines = [[CGPoint]]()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        lines.forEach {
            $0.enumerated().forEach {
                if $0 == 0 {
                    context.move(to: $1)
                } else {
                    context.addLine(to: $1)
                }
            }
        }
        context.strokePath()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        lines.append([CGPoint]())
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let points = touches.first?.location(in: self),
              var line = lines.popLast() else { return }
        
        line.append(points)
        lines.append(line)
        
        setNeedsDisplay()
    }
    
    func eraseAllLines() {
        lines = []
        setNeedsDisplay()
    }
    
    func eraseLastLine() {
        _ = lines.popLast()
        setNeedsDisplay()
    }
}

class ViewController: UIViewController {
    private lazy var canvas: Canvas = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(Canvas())
    
    private lazy var eraseAllButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("Clear Canva", for: .normal)
        $0.addTarget(self, action: #selector(eraseAllTap), for: .touchUpInside)
        $0.backgroundColor = UIColor.darkGray
        return $0
    }(UIButton(type: .system))
    
    private lazy var undoButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("Undo", for: .normal)
        $0.addTarget(self, action: #selector(eraseLastLine), for: .touchUpInside)
        $0.backgroundColor = UIColor.cyan
        return $0
    }(UIButton(type: .system))
    
    private lazy var stackButtons: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        return $0
    }(UIStackView())

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(canvas)
        view.addSubview(stackButtons)
        stackButtons.addArrangedSubview(eraseAllButton)
        stackButtons.addArrangedSubview(undoButton)
        
        canvas.backgroundColor = UIColor.lightGray
        
        NSLayoutConstraint.activate([
            canvas.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            canvas.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            canvas.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
        ])
        NSLayoutConstraint.activate([
            stackButtons.topAnchor.constraint(equalTo: canvas.bottomAnchor),
            stackButtons.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            stackButtons.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            stackButtons.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        NSLayoutConstraint.activate([
            eraseAllButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/2)
        ])
        NSLayoutConstraint.activate([
            undoButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/2)
        ])
    }
    
    @objc
    private func eraseAllTap() {
        canvas.eraseAllLines()
    }
    
    @objc
    private func eraseLastLine() {
        canvas.eraseLastLine()
    }
}
