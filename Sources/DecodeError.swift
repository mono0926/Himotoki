//
//  DecodeError.swift
//  Himotoki
//
//  Created by Syo Ikeda on 8/29/15.
//  Copyright © 2015 Syo Ikeda. All rights reserved.
//

public enum DecodeError: Error {
    case missingKeyPath(KeyPath)
    case typeMismatch(expected: String, actual: String, keyPath: KeyPath)
    case custom(String)
}

extension DecodeError: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case let .missingKeyPath(keyPath):
            return "DecodeError.missingKeyPath(\(keyPath))"

        case let .typeMismatch(expected, actual, keyPath):
            return "DecodeError.typeMismatch(expected: \(expected), actual: \(actual), keyPath: \(keyPath))"

        case let .custom(message):
            return "DecodeError.custom(\(message))"
        }
    }
}

extension DecodeError: Hashable {
    public static func == (lhs: DecodeError, rhs: DecodeError) -> Bool {
        switch (lhs, rhs) {
        case let (.missingKeyPath(l), .missingKeyPath(r)):
            return l == r

        case let (.typeMismatch(la, lb, lc), .typeMismatch(ra, rb, rc)):
            return la == ra && lb == rb && lc == rc

        case let (.custom(l), .custom(r)):
            return l == r

        default:
            return false
        }
    }

    public func hash(into hasher: inout Hasher) {
        switch self {
        case let .missingKeyPath(keyPath):
            hasher.combine(keyPath.hashValue)

        case let .typeMismatch(expected, actual, keyPath):
            hasher.combine(expected)
            hasher.combine(actual)
            hasher.combine(keyPath)

        case let .custom(message):
            hasher.combine(message)
        }
    }
}

public func missingKeyPath(_ keyPath: KeyPath) -> DecodeError {
    return DecodeError.missingKeyPath(keyPath)
}

public func typeMismatch<T>(_ expected: String, actual: T, keyPath: KeyPath = KeyPath.empty) -> DecodeError {
    return DecodeError.typeMismatch(expected: expected, actual: String(describing: actual), keyPath: keyPath)
}

public func customError(_ message: String) -> DecodeError {
    return DecodeError.custom(message)
}
