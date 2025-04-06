//
//  JsonReader.swift
//  ForestCast
//
//  Created by Marie Harmsen on 06/04/2025.
//

import Testing
import ForestCast
import UIKit
import XCTest
import SwiftUI
@testable import ForestCast

class FileReader: XCTestCase {
    
    func readJSONFile(fileName: String) -> Data? {
        guard let url = Bundle(for: type(of: self)).url(forResource: fileName, withExtension: "json") else {
            XCTFail("Can't read JSON file")
            return nil
        }
        do {
            return try Data(contentsOf: url)
        }
        catch {
            XCTFail("Can't read JSON file")
        }
        return nil
    }
}
