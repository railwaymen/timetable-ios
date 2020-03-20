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
    func fetchSimpleListOfProjects(completion: @escaping ((Result<[SimpleProjectRecordDecoder], Error>) -> Void))
    func fetchTags(completion: @escaping (Result<ProjectTagsDecoder, Error>) -> Void)
}

extension ApiClient: ApiClientProjectsType {
    func fetchAllProjects(completion: @escaping ((Result<[ProjectRecordDecoder], Error>) -> Void)) {
        _ = self.restler
            .get(Endpoint.projects)
            .decode([ProjectRecordDecoder].self)
            .onCompletion(completion)
            .start()
    }
    
    func fetchSimpleListOfProjects(completion: @escaping ((Result<[SimpleProjectRecordDecoder], Error>) -> Void)) {
        _ = self.restler
            .get(Endpoint.projectsSimpleList)
            .decode([SimpleProjectRecordDecoder].self)
            .onCompletion(completion)
            .start()
    }
    
    func fetchTags(completion: @escaping (Result<ProjectTagsDecoder, Error>) -> Void) {
        _ = self.restler
            .get(Endpoint.tags)
            .decode(ProjectTagsDecoder.self)
            .onCompletion(completion)
            .start()
    }
}
