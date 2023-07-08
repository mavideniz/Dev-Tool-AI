//
//  Service.swift
//  Dev Tool AI
//
//  Created by Doğancan Mavideniz on 8.07.2023.
//

import Foundation
import Alamofire

class OpenAiService {
    private let endpointUrl = "https://api.openai.com/v1/chat/completions"

    func sendMessage(messages: [Message]) async -> OpenAIChatResponse? {

        let openAIMessages = messages.map({ OpenAIChatMessage(role: $0.role, content: $0.content) })

        let body = OpenAIChatBody(model: "gpt-3.5-turbo", messages: openAIMessages)

        let hearders: HTTPHeaders = [
            "Authorization": "Bearer \(AppConstants.openApiKey)"
        ]

        return try? await AF.request(endpointUrl, method: .post, parameters: body, encoder: .json, headers: hearders).serializingDecodable(OpenAIChatResponse.self).value

    }
}

struct OpenAIChatBody: Encodable {
    let model: String
    let messages: [OpenAIChatMessage]
}

struct OpenAIChatMessage: Codable {
    let role: SenderRole
    let content: String
}

enum SenderRole: String, Codable {
    case system
    case user
    case assistant
}

struct OpenAIChatResponse: Decodable {
    let choices: [OpenAIChatChoice]
}

struct OpenAIChatChoice: Decodable {
    let message: OpenAIChatMessage
}
