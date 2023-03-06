//
//  FaceAuth.swift
//  Password_App
//
//  Created by 近藤秀人 on 2023/03/06.
//

import Foundation
import LocalAuthentication

class FaceAuth {

    // 生体認証を管理クラスを生成
    var context: LAContext = LAContext()
    // 認証ポップアップに表示するメッセージ
    let reason = "パスワードを入力してください"

    // 顔認証処理
    func auth(complation:@escaping(String) -> Void) {
        // 顔認証が利用できるかチェック
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil) {
            // 認証処理の実行
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, error in
                if success {
                    DispatchQueue.main.async {
                        complation("認証が成功しました")
                    }
                } else if let laError = error as? LAError {
                    switch laError.code {
                    case .authenticationFailed:
                        complation("認証に失敗しました")
                        break
                    case .userCancel:
                        complation("認証がキャンセルされました")
                        break
                    case .userFallback:
                        complation("認証に失敗しました")
                        break
                    case .systemCancel:
                        complation("認証が自動キャンセルされました")
                        break
                    case .passcodeNotSet:
                        complation("パスコードが入力されませんでした")
                        break
                    case .touchIDNotAvailable:
                        complation("指紋認証の失敗上限に達しました")
                        break
                    case .touchIDNotEnrolled:
                        complation("指紋認証が許可されていません")
                        break
                    case .touchIDLockout:
                        complation("指紋が登録されていません")
                        break
                    case .appCancel:
                        complation("アプリ側でキャンセルされました")
                        break
                    case .invalidContext:
                        complation("不明なエラー")
                        break
                    case .notInteractive:
                        complation("システムエラーが発生しました")
                        break
                    @unknown default:
                        // 何もしない
                        break
                    }
                }
            }
        } else {
            // 生体認証ができない場合の認証画面表示など
        }
    }
}
