//
//  ViewModel.swift
//  Combine-Api-tutorial
//
//  Created by Jeff Jeong on 2022/06/03.
//

import Foundation
import Combine

class ViewModel: ObservableObject {
    var subcriptions = Set<AnyCancellable>()
    
    func fetchTodos() {
        ApiService.fetchTodos()
            .sink { completion in
                switch completion {
                case .failure(let err):
                    print("ViewModel - fetchTodos: err: \(err)")
                case .finished:
                    print("ViewModel - fetchTodos: finished")
                }
            } receiveValue: { (todos : [Todo]) in
                print("ViewModel - fetchTodos / todos.count: \(todos.count)")
            }.store(in: &subcriptions)
    }
    
    func fetchPosts() {
        ApiService.fetchPosts()
            .sink { completion in
                switch completion {
                case .failure(let err):
                    print("ViewModel - fetchPosts: err: \(err)")
                case .finished:
                    print("ViewModel - fetchPosts: finished")
                }
            } receiveValue: { (posts : [Post]) in
                print("ViewModel - fetchPosts / posts.count: \(posts.count)")
            }.store(in: &subcriptions)
    }
    
    // todos + posts 동시 호출
    func fetchTodosAndPostsAtTheSameTime() {
        ApiService.fetchTodosAndPostsAtTheSameTime()
            .sink { completion in
                switch completion {
                case .failure(let err):
                    print("ViewModel - fetchTodosAndPostsAtTheSameTime: err: \(err)")
                case .finished:
                    print("ViewModel - fetchTodosAndPostsAtTheSameTime: finished")
                }
            } receiveValue: { (todos: [Todo], posts : [Post]) in
                print("ViewModel - fetchTodosAndPostsAtTheSameTime / todos.count: \(todos.count)/ posts.count: \(posts.count)")
            }.store(in: &subcriptions)
    }
    
    // todos 호출후 응답으로 posts 호출
    func fetchTodosAndThenPost() {
        ApiService.fetchTodosAndThenPosts()
            .sink { completion in
                switch completion {
                case .failure(let err):
                    print("ViewModel - fetchTodosAndThenPost: err: \(err)")
                case .finished:
                    print("ViewModel - fetchTodosAndThenPost: finished")
                }
            } receiveValue: { (posts : [Post]) in
                print("ViewModel - fetchTodosAndThenPost / posts.count: \(posts.count)")
            }.store(in: &subcriptions)
    }
    
    // todos 호출후 응답에 따른 조건으로 posts 호출
    func fetchTodosAndPostApiCallConditionally() {
        ApiService.fetchTodosAndPostApiCallConditionally()
            .sink { completion in
                switch completion {
                case .failure(let err):
                    print("ViewModel - fetchTodosAndPostApiCallConditionally: err: \(err)")
                case .finished:
                    print("ViewModel - fetchTodosAndPostApiCallConditionally: finished")
                }
            } receiveValue: { (posts : [Post]) in
                print("ViewModel - fetchTodosAndPostApiCallConditionally / posts.count: \(posts.count)")
            }.store(in: &subcriptions)
    }
    
    // todos 호출후 응답에 따른 조건으로 다음 api 호출 결정
    // todos.count < 200 : 포스트 호출 ? 유저 호출
    func fetchTodosAndApiCallConditionally() {
        
        let shouldFetchPosts : AnyPublisher<Bool, Error> =
            ApiService.fetchTodos()
                .map{ todos in
                    return todos.count >= 200
                }.eraseToAnyPublisher()
        
        shouldFetchPosts
            .filter{ $0 == true }
            .flatMap{ _ in
                return ApiService.fetchPosts()
            }.sink { completion in
                switch completion {
                case .failure(let err):
                    print("ViewModel - fetchTodosAndApiCallConditionally: err: \(err)")
                case .finished:
                    print("ViewModel - fetchTodosAndApiCallConditionally: finished")
                }
            } receiveValue: { (posts : [Post]) in
                print("ViewModel - fetchTodosAndApiCallConditionally / posts.count: \(posts.count)")
            }.store(in: &subcriptions)
        
        shouldFetchPosts
            .filter{ $0 != true }
            .flatMap{ _ in
                return ApiService.fetchUsers()
            }.sink { completion in
                switch completion {
                case .failure(let err):
                    print("ViewModel - fetchTodosAndApiCallConditionally: err: \(err)")
                case .finished:
                    print("ViewModel - fetchTodosAndApiCallConditionally: finished")
                }
            } receiveValue: { (users : [User]) in
                print("ViewModel - fetchTodosAndApiCallConditionally / users.count: \(users.count)")
            }.store(in: &subcriptions)
        
    }
}
