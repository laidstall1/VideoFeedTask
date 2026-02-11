//
//  APIError.swift
//  VideoFeedTask
//
//  Created by DIGITAL VENTURES on 07/02/2026.
//


enum APIError: Error {
    case invalidEndpoint
    case networkError(error: Error)
    case parsing(error: Error)
    case clientError(message: String)
    case serverError(message: String)
    case unexpectedResponse
   
   var userMessage: String? {
       switch self {
       case .invalidEndpoint:
           return "Something went wrong. Please try again."

       case .networkError:
           return "Please check your internet connection and try again."

       case .clientError(let message):
           return message

       case .serverError:
           return "We’re experiencing issues on our end. Please try again later."

       case .parsing:
           return "Could not process the server response. Try again later."

       case .unexpectedResponse:
           return "Unexpected error occurred. Please try again."
       }
   }
}
