//
//  ApiService.swift
//  Combine-Api-tutorial
//
//  Created by Jeff Jeong on 2022/06/03.
//

import Foundation
import Combine
import Alamofire

enum API {
    case fetchTodos // 할일 가져오기
    case fetchPosts // 포스트 가져오기
    case fetchUsers // 유저 가져오기
    
    var url : URL {
        
        switch self {
        case .fetchTodos: return URL(string: "https://jsonplaceholder.typicode.com/todos")!
        case .fetchPosts: return URL(string: "https://jsonplaceholder.typicode.com/posts")!
        case .fetchUsers: return URL(string: "https://jsonplaceholder.typicode.com/users")!
        }
    }
}

enum ApiService {
    
    static func fetchUsers() -> AnyPublisher<[User], Error> {
        print("ApiService - fetchUsers()")
//        return URLSession.shared.dataTaskPublisher(for: API.fetchUsers.url)
//            .map{ $0.data }
//            .decode(type: [User].self, decoder: JSONDecoder())
//            .eraseToAnyPublisher()
        
        return AF.request(API.fetchUsers.url)
                .publishDecodable(type: [User].self)
                .value()
                .mapError({ (afError : AFError) in
                    return afError as Error
                })
                .eraseToAnyPublisher()
    }
    
    static func fetchTodos() -> AnyPublisher<[Todo], Error> {
        print("ApiService - fetchTodos()")
//        return URLSession.shared.dataTaskPublisher(for: API.fetchTodos.url)
//            .map{ $0.data }
//            .decode(type: [Todo].self, decoder: JSONDecoder())
//            .eraseToAnyPublisher()
        
        return AF.request(API.fetchTodos.url)
                .publishDecodable(type: [Todo].self)
                .value()
                .mapError({ (afError : AFError) in
                    return afError as Error
                })
                .eraseToAnyPublisher()
    }
    
    static func fetchPosts(_ todosCount : Int = 0) -> AnyPublisher<[Post], Error> {
        print("fetchPosts todosCount : \(todosCount)")
//        return URLSession.shared.dataTaskPublisher(for: API.fetchPosts.url)
//            .map{ $0.data }
//            .decode(type: [Post].self, decoder: JSONDecoder())
//            .eraseToAnyPublisher()
        
        return AF.request(API.fetchPosts.url)
                .publishDecodable(type: [Post].self)
                .value()
                .mapError({ (afError : AFError) in
                    return afError as Error
                })
                .eraseToAnyPublisher()
    }
    
    
    
    /// Todos + Posts 동시호출
    /// - Returns:
    static func fetchTodosAndPostsAtTheSameTime() -> AnyPublisher<([Todo],[Post]), Error> {
        let fetchedTodos = fetchTodos()
        let fetchedPosts = fetchPosts()
        
        return Publishers
            .CombineLatest(fetchedTodos, fetchedPosts)
            .eraseToAnyPublisher()
    }
    
    
    /// Todos 호출 뒤에 그 결과로 Posts 호출하기
    /// - Returns:
    static func fetchTodosAndThenPosts() -> AnyPublisher<[Post], Error> {
        return fetchTodos().flatMap{ posts in
            return fetchPosts(posts.count).eraseToAnyPublisher()
        }.eraseToAnyPublisher()
    }
    
    /// Todos 호출 뒤에 그 결과로 특정 조건이 성립되면 Posts 호출하기
    /// - Returns:
    static func fetchTodosAndPostApiCallConditionally() -> AnyPublisher<[Post], Error> {
        return fetchTodos()
            .map{ $0.count } // todos.count
            .filter{ $0 >= 200 } // 만약 200보다 작을 때
            .flatMap{ _ in
                return fetchPosts().eraseToAnyPublisher()
            }.eraseToAnyPublisher()
    }
    
}
