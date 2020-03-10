//
//  ApiClient+Projects.swift
//  TimeTable
//
//  Created by Piotr Pawluś on 02/01/2019.
//  Copyright © 2019 Railwaymen. All rights reserved.
//

import Foundation

protocol ApiClientProjectsType: class {
    func fetchAllProjects(completion: @escaping ((Result<[ProjectRecordDecoder], Error>) -> Void))
    func fetchSimpleListOfProjects(completion: @escaping ((Result<SimpleProjectDecoder, Error>) -> Void))
}

extension ApiClient: ApiClientProjectsType {
    func fetchAllProjects(completion: @escaping ((Result<[ProjectRecordDecoder], Error>) -> Void)) {
        _ = self.restler
            .get(Endpoint.projects)
            .decode([ProjectRecordDecoder].self)
            .onCompletion(completion)
            .start()
    }
    
    func fetchSimpleListOfProjects(completion: @escaping ((Result<SimpleProjectDecoder, Error>) -> Void)) {
        _ = self.restler
            .get(Endpoint.projectsSimpleList)
            .decode(SimpleProjectDecoder.self)
            .onCompletion(completion)
            .start()
    }
}
