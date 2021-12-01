//
// Copyright (c) 2021-Present, Okta, Inc. and/or its affiliates. All rights reserved.
// The Okta software accompanied by this notice is provided pursuant to the Apache License, Version 2.0 (the "License.")
//
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0.
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
// WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//
// See the License for the specific language governing permissions and limitations under the License.
//

import Foundation
import AuthFoundation

struct TokenRequest {
    let clientId: String
    let clientSecret: String?
    let redirectUri: String
    let grantType: Authentication.GrantType
    let grantValue: String
    let pkce: PKCE?
}

extension TokenRequest: APIRequest, APIRequestBody {
    var httpMethod: APIHTTPMethod { .post }
    var path: String { "token" }
    var contentType: APIContentType? { .formEncoded }
    var bodyParameters: [String : Any]? {
        var result = [
            "client_id": clientId,
            "redirect_uri": redirectUri,
            "grant_type": grantType.rawValue,
            grantType.responseKey: grantValue
        ]
        
        if let clientSecret = clientSecret {
            result["client_secret"] = clientSecret
        }
        
        if let pkce = pkce {
            result["code_verifier"] = pkce.codeVerifier
        }
        
        return result
    }
}
