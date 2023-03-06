// swiftlint:disable all
import Amplify
import Foundation

extension Pass {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case app_name
    case user_name
    case pass
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let pass = Pass.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.pluralName = "Passes"
    
    model.attributes(
      .primaryKey(fields: [pass.id])
    )
    
    model.fields(
      .field(pass.id, is: .required, ofType: .string),
      .field(pass.app_name, is: .optional, ofType: .string),
      .field(pass.user_name, is: .optional, ofType: .string),
      .field(pass.pass, is: .optional, ofType: .string),
      .field(pass.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(pass.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension Pass: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}