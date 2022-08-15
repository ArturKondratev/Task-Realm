//
//  LockView.swift
//  Rubetek
//
//  Created by Артур Кондратьев on 10.07.2022.
//

import UIKit

class LockView: UIControl {
    
    var lockState: Bool = false
       
    private var lock: UIImageView = UIImageView()
    private var lockOpen: UIImageView = UIImageView()
    private var bgView: UIView = UIView()
    
    lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(onClick))
        recognizer.numberOfTapsRequired = 1 // Распознаем кол-во нажатий
        recognizer.numberOfTouchesRequired = 1 // Кол-во пальцев необходимых для реагирования
        return recognizer
    }()
    
    private func setupView() {
        
        self.backgroundColor = .white
        
        let imageCloseLock = UIImage(systemName: "lock.fill")
        lock.frame = CGRect(x: 10 , y: 15, width: 30, height: 20)
        lock.image = imageCloseLock
        lock.tintColor = .systemBlue
        
        let imageOpenLock = UIImage(systemName: "lock.open.fill")
        lockOpen.frame = CGRect(x: 10, y: 15, width: 30, height: 20)
        lockOpen.image = imageOpenLock
        lockOpen.tintColor = .systemBlue
        
        bgView.frame = bounds
        bgView.addSubview(lock)
        self.addSubview(bgView)
    }
    
    @objc func onClick() {
        if lockState {
            lockState = false
            UIView.transition(from: lock,
                              to: lockOpen,
                              duration: 0.2,
                              options: .transitionCrossDissolve)
        } else {
            lockState = true
            UIView.transition(from: lockOpen,
                              to: lock,
                              duration: 0.2,
                              options: .transitionCrossDissolve)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
        addGestureRecognizer(tapGestureRecognizer)
    }
    
}
