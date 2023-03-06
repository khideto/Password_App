// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "e3fc16399a0557969be0dfe18dcab727"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: Pass.self)
  }
}