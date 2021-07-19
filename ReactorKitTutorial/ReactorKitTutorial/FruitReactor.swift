//
//  FruitReactor.swift
//  ReactorKitTutorial
//
//  Created by 민성홍 on 2021/07/19.
//

import Foundation
import ReactorKit

class FruitReactor: Reactor {

    // MARK: Actions
    enum Action {
        case apple
        case banana
        case grapes
    }

    // MARK: State
    struct State {
        var fruitNavme: String
        var isLoading: Bool
    }

    // MARK: Mutations
    enum Mutation {
        case changeLabelApple
        case changeLabelBanana
        case changeLabelGrapes
        case setLoading(Bool)
    }

    let initialState: State

    init() {
        self.initialState = State(fruitNavme: "선택된 과일이 없음.", isLoading: false)
    }

    // MARK: Action -> Mutation
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .apple:
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                Observable.just(Mutation.changeLabelApple).delay(RxTimeInterval.microseconds(500), scheduler: MainScheduler.instance),
                Observable.just(Mutation.setLoading(false))
            ])
        case .banana:
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                Observable.just(Mutation.changeLabelBanana).delay(RxTimeInterval.microseconds(500), scheduler: MainScheduler.instance),
                Observable.just(Mutation.setLoading(false))
            ])
        case .grapes:
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                Observable.just(Mutation.changeLabelGrapes).delay(RxTimeInterval.microseconds(500), scheduler: MainScheduler.instance),
                Observable.just(Mutation.setLoading(false))
            ])
        }
    }

    // MARK: Mutation -> State
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .changeLabelApple:
            state.fruitNavme = "사과"
        case .changeLabelBanana:
            state.fruitNavme = "바나나"
        case .changeLabelGrapes:
            state.fruitNavme = "포도"
        case .setLoading(let val):
            state.isLoading = val
        }
        return state
    }
}
