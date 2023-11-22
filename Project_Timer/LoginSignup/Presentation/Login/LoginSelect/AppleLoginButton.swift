//
//  AppleLoginButton.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2023/09/24.
//  Copyright © 2023 FDEE. All rights reserved.
//

import SwiftUI
import AuthenticationServices

enum AppleSigninError: Error {
    case failure(String)
    case noAuthorizationCode
    case passwordCredential
}

struct AppleLoginButton: View {
    var completion: (Result<(String, String?), AppleSigninError>) -> Void
    
    var body: some View {
        SignInWithAppleButton(.signIn) { request in
            request.requestedScopes = [.fullName, .email]
        } onCompletion: { result in
            switch result {
            case let .success(authorization):
                switch authorization.credential {
                case let appleIDCredential as ASAuthorizationAppleIDCredential:
                    if let authorizationCode = appleIDCredential.authorizationCode {
                        completion(.success((String(data: authorizationCode, encoding: .utf8)!, appleIDCredential.email)))
                    } else {
                        completion(.failure(.noAuthorizationCode))
                    }
                case _ as ASPasswordCredential:
                    completion(.failure(.passwordCredential))
                default:
                    completion(.failure(.failure("failure")))
                }
            case let .failure(error):
                completion(.failure(.failure("\(error.localizedDescription)")))
            }
        }
        .signInWithAppleButtonStyle(.white)
        .font(.system(size: 20, weight: .bold, design: .default))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.1), radius: 4, x: 1, y: 2)
        .frame(maxWidth: .infinity)
        .frame(height: 58)
        

//        Button {
//            action()
//        } label: {
//            ZStack{
//                RoundedRectangle(cornerRadius: 12)
//                    .foregroundColor(.white)
//                    .shadow(color: .gray.opacity(0.1), radius: 4, x: 1, y: 2)
//                    .frame(maxWidth: .infinity)
//                    .frame(height: 58)
//                
//                HStack(spacing: 12) {
//                    Text("")
//                        .font(.system(size: 30))
//                    Text("Sign in with \("Apple")")
//                        .font(.system(size: 20, weight: .bold, design: .default))
//                }
//            }
//        }
//        .foregroundColor(.black)
    }
}
