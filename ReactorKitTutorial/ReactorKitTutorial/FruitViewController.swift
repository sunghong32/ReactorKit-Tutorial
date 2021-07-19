//
//  FruitViewController.swift
//  ReactorKitTutorial
//
//  Created by 민성홍 on 2021/07/19.
//

import UIKit
import ReactorKit
import RxCocoa

class FruitViewController: UIViewController {

    // MARK: Properties
    private lazy var appleButton: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.system)
        btn.setTitle("사과", for: UIControl.State.normal)
        return btn
    }()

    private lazy var bananaButton: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.system)
        btn.setTitle("바나나", for: UIControl.State.normal)
        return btn
    }()

    private lazy var grapesButton: UIButton = {
        let btn = UIButton(type: UIButton.ButtonType.system)
        btn.setTitle("포도", for: UIControl.State.normal)
        return btn
    }()

    private lazy var selectedLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    private lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [appleButton, bananaButton, grapesButton, selectedLabel])
        stack.axis = .vertical
        stack.spacing = 20
        return stack
    }()

    // MARK: Binding Properties
    let disposBag = DisposeBag()
    let fruitReact = FruitReactor()

    // MARK: Lifecyles
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        bind(reactor: fruitReact)
    }

    // MARK: Configures
    func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stack.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    // MARK: Helpers
    func bind(reactor: FruitReactor) {
        appleButton.rx.tap.map { FruitReactor.Action.apple }
            .bind(to: reactor.action)
            .disposed(by: disposBag)

        bananaButton.rx.tap.map { FruitReactor.Action.banana }
            .bind(to: reactor.action)
            .disposed(by: disposBag)

        grapesButton.rx.tap.map { FruitReactor.Action.grapes }
            .bind(to: reactor.action)
            .disposed(by: disposBag)

        reactor.state.map { $0.fruitNavme }
            .distinctUntilChanged()
            .map { $0 }
            .subscribe(onNext: { val in
                self.selectedLabel.text = val
            })
            .disposed(by: disposBag)

        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .map { $0 }
            .subscribe(onNext: { val in
                if val == true {
                    self.selectedLabel.text = "로딩중입니다"
                }
            })
            .disposed(by: disposBag)
    }
}
