//
//  NewsWebSocketClient.swift
//  Concepts
//
//  Created by Karthik Reddy on 06/10/24.
//

import Foundation

protocol NewsWebSocketClientDelegate: AnyObject {
    func didReceiveNewsUpdate(_ update: String)
    func didFailWithError(_ error: Error)
}

class NewsWebSocketClient {
    private var webSocketTask: URLSessionWebSocketTask?
    weak var delegate: NewsWebSocketClientDelegate?
    private let webSocketURL = URL(string: "wss://echo.websocket.org")!
    
    func connect() {
        let urlSession = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue())
        webSocketTask = urlSession.webSocketTask(with: webSocketURL)
        webSocketTask?.resume()
        
        listenForMessages()
        sendTestMessage()
    }
    
    private func sendTestMessage() {
        let testMessage = "Hello WebSocket Echo Server!"
        let message = URLSessionWebSocketTask.Message.string(testMessage)
        
        webSocketTask?.send(message) { error in
            if let error = error {
                print("Error sending message: \(error)")
            } else {
                print("Test message sent successfully")
            }
        }
    }
    
    private func listenForMessages() {
        guard let webSocketTask = webSocketTask else { return }
        
        webSocketTask.receive { [weak self] result in
            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    self?.delegate?.didReceiveNewsUpdate(text)
                case .data(let data):
                    print("Received binary data: \(data)")
                @unknown default:
                    print("Unknown message received")
                }
                self?.listenForMessages()
                
            case .failure(let error):
                self?.delegate?.didFailWithError(error)
                self?.reconnect()
            }
        }
    }
    
    private func reconnect() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
            print("Reconnecting to WebSocket...")
            self.connect()
        }
    }
    
    func disconnect() {
        webSocketTask?.cancel(with: .normalClosure, reason: nil)
    }
}
