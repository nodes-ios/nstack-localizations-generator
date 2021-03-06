// ----------------------------------------------------------------------
// File generated by NStack Translations Generator.
//
// Copyright (c) 2018 Nodes ApS
//
// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to
// the following conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
// CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
// SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
// ----------------------------------------------------------------------

import Foundation
import TranslationManager

public final class Translations: LocalizableModel {
    public var otherSection = OtherSection()
    public var oneMoreSection = OneMoreSection()
    public var defaultSection = DefaultSection()

    enum CodingKeys: String, CodingKey {
        case otherSection
        case oneMoreSection
        case defaultSection = "default"
    }

    public override init() { super.init() }

    public required init(from decoder: Decoder) throws {
        super.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        otherSection = try container.decodeIfPresent(OtherSection.self, forKey: .otherSection) ?? otherSection
        oneMoreSection = try container.decodeIfPresent(OneMoreSection.self, forKey: .oneMoreSection) ?? oneMoreSection
        defaultSection = try container.decodeIfPresent(DefaultSection.self, forKey: .defaultSection) ?? defaultSection
    }

    public override subscript(key: String) -> LocalizableSection? {
        switch key {
        case CodingKeys.otherSection.stringValue: return otherSection
        case CodingKeys.oneMoreSection.stringValue: return oneMoreSection
        case CodingKeys.defaultSection.stringValue: return defaultSection
        default: return nil
        }
    }

    public final class OtherSection: LocalizableSection {
        public var otherString = ""

        enum CodingKeys: String, CodingKey {
            case otherString
        }

        public override init() { super.init() }

        public required init(from decoder: Decoder) throws {
            super.init()
            let container = try decoder.container(keyedBy: CodingKeys.self)
            otherString = try container.decodeIfPresent(String.self, forKey: .otherString) ?? "__otherString"
        }

        public override subscript(key: String) -> String? {
            switch key {
            case CodingKeys.otherString.stringValue: return otherString
            default: return nil
            }
        }
    }

    public final class OneMoreSection: LocalizableSection {
        public var soManyKeys = ""
        public var test2 = ""
        public var testURL = ""
        public var test1 = ""

        enum CodingKeys: String, CodingKey {
            case soManyKeys
            case test2
            case testURL
            case test1
        }

        public override init() { super.init() }

        public required init(from decoder: Decoder) throws {
            super.init()
            let container = try decoder.container(keyedBy: CodingKeys.self)
            soManyKeys = try container.decodeIfPresent(String.self, forKey: .soManyKeys) ?? "__soManyKeys"
            test2 = try container.decodeIfPresent(String.self, forKey: .test2) ?? "__test2"
            testURL = try container.decodeIfPresent(String.self, forKey: .testURL) ?? "__testURL"
            test1 = try container.decodeIfPresent(String.self, forKey: .test1) ?? "__test1"
        }

        public override subscript(key: String) -> String? {
            switch key {
            case CodingKeys.soManyKeys.stringValue: return soManyKeys
            case CodingKeys.test2.stringValue: return test2
            case CodingKeys.testURL.stringValue: return testURL
            case CodingKeys.test1.stringValue: return test1
            default: return nil
            }
        }
    }

    public final class DefaultSection: LocalizableSection {
        public var successKey = ""
        public var keyys = ""
        public var emptyKey = ""

        enum CodingKeys: String, CodingKey {
            case successKey
            case keyys
            case emptyKey
        }

        public override init() { super.init() }

        public required init(from decoder: Decoder) throws {
            super.init()
            let container = try decoder.container(keyedBy: CodingKeys.self)
            successKey = try container.decodeIfPresent(String.self, forKey: .successKey) ?? "__successKey"
            keyys = try container.decodeIfPresent(String.self, forKey: .keyys) ?? "__keyys"
            emptyKey = try container.decodeIfPresent(String.self, forKey: .emptyKey) ?? "__emptyKey"
        }

        public override subscript(key: String) -> String? {
            switch key {
            case CodingKeys.successKey.stringValue: return successKey
            case CodingKeys.keyys.stringValue: return keyys
            case CodingKeys.emptyKey.stringValue: return emptyKey
            default: return nil
            }
        }
    }
}

