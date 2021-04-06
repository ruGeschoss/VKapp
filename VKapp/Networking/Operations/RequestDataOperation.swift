//
//  RequestDataOperation.swift
//  VKapp
//
//  Created by Alexander Andrianov on 06.04.2021.
//

import Foundation
import Alamofire

final class RequestDataOperation: AsyncOperation {
  
  private var request: DataRequest
  var target: String
  var data: Data?
  
  init(request: DataRequest, forUser: String) {
    self.request = request
    self.target = forUser
  }
  
  override func main() {
    request.responseData { [weak self] (response) in
      self?.data = response.data
      self?.state = .finished
    }
  }
  
  override func cancel() {
    request.cancel()
    super.cancel()
  }
}
