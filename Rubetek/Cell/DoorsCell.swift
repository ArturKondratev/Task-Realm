//
//  DoorsCell.swift
//  Rubetek
//
//  Created by Артур Кондратьев on 10.07.2022.
//

import UIKit

class DoorsCell: UITableViewCell {
    
    static let identifier: String = "DoorsCell"
    
    lazy var whiteBottomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        // view.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        return view
    }()
    
    lazy var cameraName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.backgroundColor = .white
        return label
    }()
    
    lazy var lockView: LockView = {
        let lock = LockView()
        lock.translatesAutoresizingMaskIntoConstraints = false
        lock.backgroundColor = .white
        return lock
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews()
    }
    
}

extension DoorsCell {
    
    func setupViews() {
        contentView.backgroundColor = .lightGrayBackground
        
        contentView.addSubview(whiteBottomView)
        NSLayoutConstraint.activate([
            whiteBottomView.topAnchor.constraint(equalTo: contentView.topAnchor),
            whiteBottomView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            whiteBottomView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 30),
            whiteBottomView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -30),
            whiteBottomView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        whiteBottomView.addSubview(cameraName)
        NSLayoutConstraint.activate([
            cameraName.centerYAnchor.constraint(equalTo: whiteBottomView.centerYAnchor),
            cameraName.leftAnchor.constraint(equalTo: whiteBottomView.leftAnchor, constant: 20)
        ])
        
        whiteBottomView.addSubview(lockView)
        NSLayoutConstraint.activate([
            lockView.centerYAnchor.constraint(equalTo: whiteBottomView.centerYAnchor),
            lockView.rightAnchor.constraint(equalTo: whiteBottomView.rightAnchor),
            lockView.heightAnchor.constraint(equalToConstant: 50),
            lockView.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configure(model: DoorsRealmModel) {
        self.cameraName.text = model.name
        
        guard let url = model.snapshot, !url.isEmpty else { return }
        whiteBottomView.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        
    }
}
