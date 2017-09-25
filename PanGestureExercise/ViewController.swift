//
//  ViewController.swift
//  PanGestureExercise
//
//  Created by Gilbert Lo on 9/23/17.
//  Copyright © 2017 Gilbert Lo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var fileView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "file")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        imageView.addGestureRecognizer(pan)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let trashView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "tashCan")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Reset", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.backgroundColor = UIColor(red: 0, green: 146/255, blue: 244/255, alpha: 1)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        
        button.addTarget(self, action: #selector(handleResetTouch), for: .touchUpInside)
        return button
    }()
    
    var fileViewOriginalPos: CGPoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = .white
        
        view.addSubview(fileView)
        view.addSubview(trashView)
        view.addSubview(resetButton)
        
        view.bringSubview(toFront: fileView)
        layoutView()
    }
    
    private func layoutView() {
        NSLayoutConstraint.activate([
            fileView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            fileView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            fileView.widthAnchor.constraint(equalToConstant: 100),
            fileView.heightAnchor.constraint(equalToConstant: 100),
            
            trashView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            trashView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8),
            trashView.widthAnchor.constraint(equalToConstant: 100),
            trashView.heightAnchor.constraint(equalToConstant: 150),
            
            resetButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            resetButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            resetButton.widthAnchor.constraint(equalToConstant: 96),
            resetButton.heightAnchor.constraint(equalToConstant: 32)
        ])
        fileViewOriginalPos = CGPoint(x: 70, y: 70)
    }
    
    @objc func handleResetTouch() {
        fileView.alpha = 1
        fileView.center = self.fileViewOriginalPos!
    }
    
    @objc func handlePan(sender: UIPanGestureRecognizer) {
        let view = sender.view!
        
        switch sender.state {
        case .began, .changed:
            movingTheFile(view: view, sender: sender)
        case .ended:
            handleEnd()
        default:
            break
        }
    }
    
    private func movingTheFile(view: UIView, sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: view)
    }
    
    private func handleEnd() {
        if fileView.frame.intersects(trashView.frame) {
            UIView.animate(withDuration: 0.5) {
                self.fileView.alpha = 0
            }
        } else {
            UIView.animate(withDuration: 0.5) {
                self.fileView.center = self.fileViewOriginalPos!
            }
        }
    }
    
}

