// swiftlint:disable all
import Amplify
import Foundation

public struct Pass: Model {
  public let id: String
  public var app_name: String
  public var user_name: String
  public var pass: String
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      app_name: String = "",
      user_name: String = "",
      pass: String = "") {
    self.init(id: id,
      app_name: app_name,
      user_name: user_name,
      pass: pass,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      app_name: String = "",
      user_name: String = "",
      pass: String = "",
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.app_name = app_name
      self.user_name = user_name
      self.pass = pass
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}
