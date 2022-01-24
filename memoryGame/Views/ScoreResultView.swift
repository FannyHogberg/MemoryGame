//
//  ScoreResultView.swift
//  Flush The Toilet
//
//  Created by Fanny Högberg on 2022-01-23.
//  Copyright © 2022 Fanny Högberg. All rights reserved.
//

import Foundation
import UIKit

class ScoreResultView: UIView {
    
    // MARK: - Views
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "playAgain"), for: .normal)
        button.addTarget(self, action: #selector(didPressButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var verticalContainerStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 20
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            stack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20)
        ])
        return stack
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 30)
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            label.heightAnchor.constraint(equalToConstant: 50)
        ])
        return label
    }()
    
    
    // MARK: - Images
    
    private let unfilledImage = UIImage(named: "grayToScore")
    private let filledImage = UIImage(named: "golden")
    
    
    // MARK: - Private Properties
    
    private var timer: Timer?
    private var buttonAction: EmptyAction?
    
    
    deinit {
        timer?.invalidate()
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        layer.cornerRadius = 10
        backgroundColor = .white
    }
    
    func setupButtonAction(_ action: @escaping EmptyAction) {
        buttonAction = action
    }
    
    //TODO: Refactor Level... and take in levels instead
    func showScores(title: String, levels: [Level], time: TimeInterval) {
        resetView()
        titleLabel.text = title
        showTitle()

        createLevelStack(level: levels[0])
        var i = 1
        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            guard i < levels.count else {
                self.timer?.invalidate()
                self.timer = nil
                self.handleHighestScore()
                self.showTimeAndButton(time: time)
                return
            }
            self.createLevelStack(level: levels[i])
            i += 1
        }
    }
}


private extension ScoreResultView {
    
    func createLevelStack(level: Level) {
        let label = UILabel()
        label.text = level.displayName //Animate this one.a
        label.alpha = 0

        let horizontalContainer = UIStackView()
        verticalContainerStack.addArrangedSubview(horizontalContainer)
        horizontalContainer.addArrangedSubview(label)
        UIView.animate(withDuration: 0.5) {
            label.alpha = 1
        }
        
        let scoreStack = UIStackView()
        scoreStack.axis = .horizontal
        scoreStack.distribution = .equalCentering
        horizontalContainer.addArrangedSubview(scoreStack)
        NSLayoutConstraint.activate([
            scoreStack.widthAnchor.constraint(equalTo: horizontalContainer.widthAnchor, multiplier: 0.5)
        ])
        
        for i in 0 ..< 3 { //FIXME
            let imageView = UIImageView(image: level.score > i ? filledImage : unfilledImage)
            imageView.contentMode = .scaleAspectFit
            imageView.transform = CGAffineTransform.identity.scaledBy(x: 0, y: 0)
            scoreStack.addArrangedSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalTo: verticalContainerStack.widthAnchor, multiplier: 0.1),
                imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
            ])
            UIView.animate(withDuration: 1, delay: Double(i) * 0.5 + 0.4, usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: .curveEaseInOut) {
                imageView.transform = CGAffineTransform.identity
            }
        }
    }
    
    @objc func didPressButton() {
        buttonAction?()
    }
    
    func handleHighestScore() {
        // guard //highest score
        // TODO: Add confetti
    }
    
    func resetView() {
        verticalContainerStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
    
    func showTimeAndButton(time: TimeInterval) {
        let label = UILabel()
        label.alpha = 0
        label.text = "\(NSLocalizedString ("TIMER_RESULTS", comment: "")) \(String(format:"%.02f", time))"
        button.alpha = 0
        verticalContainerStack.addArrangedSubview(label)
        verticalContainerStack.addArrangedSubview(button)
        UIView.animate(withDuration: 1) {
            label.alpha = 1
            self.button.alpha = 1
        }
    }
    
    func showTitle() {
        titleLabel.isHidden = true
        titleLabel.transform = CGAffineTransform.identity.scaledBy(x: 0, y: 0)
        titleLabel.isHidden = false
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: .curveEaseInOut) {
            self.titleLabel.transform = CGAffineTransform.identity
        }
    }
}
