//
//  RestlerMock.swift
//  TimeTableTests
//
//  Created by Bartłomiej Świerad on 09/03/2020.
//  Copyright © 2020 Railwaymen. All rights reserved.
//

import XCTest
import Restler
@testable import TimeTable

class RestlerMock {
    var encoder: RestlerJSONEncoderType = JSONEncoder()
    
    var decoder: RestlerJSONDecoderType = JSONDecoder()
    
    var errorParser: RestlerErrorParserType = RestlerErrorParserMock()
    
    var header: Restler.Header = .init()
    
    var getReturnValue: RestlerRequestBuilderMock = RestlerRequestBuilderMock()
    private(set) var getParams: [GetParams] = []
    struct GetParams {
        let endpoint: RestlerEndpointable
    }
    
    var postReturnValue: RestlerRequestBuilderMock = RestlerRequestBuilderMock()
    private(set) var postParams: [PostParams] = []
    struct PostParams {
        let endpoint: RestlerEndpointable
    }
    
    var putReturnValue: RestlerRequestBuilderMock = RestlerRequestBuilderMock()
    private(set) var putParams: [PutParams] = []
    struct PutParams {
        let endpoint: RestlerEndpointable
    }
    
    var patchReturnValue: RestlerRequestBuilderMock = RestlerRequestBuilderMock()
    private(set) var patchParams: [PatchParams] = []
    struct PatchParams {
        let endpoint: RestlerEndpointable
    }
    
    var deleteReturnValue: RestlerRequestBuilderMock = RestlerRequestBuilderMock()
    private(set) var deleteParams: [DeleteParams] = []
    struct DeleteParams {
        let endpoint: RestlerEndpointable
    }
}

// MARK: - RestlerType
extension RestlerMock: RestlerType {
    func get(_ endpoint: RestlerEndpointable) -> RestlerRequestBuilderType {
        self.getParams.append(GetParams(endpoint: endpoint))
        return self.getReturnValue
    }
    
    func post(_ endpoint: RestlerEndpointable) -> RestlerRequestBuilderType {
        self.postParams.append(PostParams(endpoint: endpoint))
        return self.postReturnValue
    }
    
    func put(_ endpoint: RestlerEndpointable) -> RestlerRequestBuilderType {
        self.putParams.append(PutParams(endpoint: endpoint))
        return self.putReturnValue
    }
    
    func patch(_ endpoint: RestlerEndpointable) -> RestlerRequestBuilderType {
        self.patchParams.append(PatchParams(endpoint: endpoint))
        return self.patchReturnValue
    }
    
    func delete(_ endpoint: RestlerEndpointable) -> RestlerRequestBuilderType {
        self.deleteParams.append(DeleteParams(endpoint: endpoint))
        return self.deleteReturnValue
    }
}
