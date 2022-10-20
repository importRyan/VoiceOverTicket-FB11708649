import SwiftUI

@main
struct VoiceOverPlaygroundApp: App {
  var body: some Scene {
    WindowGroup {
      // VoiceOver unexpectedly verbalizes: "SeedFee".
      // The accessibilitySpeechPhoneticNotation attribute is not respected.
      Text(.attemptedPronunciationOverrideA)
      Text(.attemptedPronunciationOverrideB)
      // Not available: https://developer.apple.com/documentation/swiftui/text/speechphoneticrepresentation(_:)
    }
  }
}

/// Goal: Achieve same effect as the Info.plist "Accessibility Bundle Name" key,
/// but on all usages of our company name throughout our app.
///
extension AttributedString {

  static let attemptedPronunciationOverrideA: AttributedString = {
    var text = AttributedString(
      localized: "^[SeedFi](accessibilitySpeechPhoneticNotation: true)",
      including: \.accessibility
    )
    debugPrint(text)
    // Is there documentation for the correct notation? (Above is incorrect.)
    // SeedFi {
    //  NSLanguage = en
    // }

    text = text.transformingAttributes(\.accessibilitySpeechPhoneticNotation, { run in
      run.replace(with: \.accessibilitySpeechPhoneticNotation, value: String(localized: "SeedFiPronunciation"))
      // run.attrName: "UIAccessibilitySpeechAttributeIPANotation", attr: nil
    })
    debugPrint(text)
    // SeedFi {
    //   NSLanguage = en
    //   UIAccessibilitySpeechAttributeIPANotation = SeedFigh
    // }
    return text
  }()

  static let attemptedPronunciationOverrideB: AttributedString = {
    var text = AttributedString(localized: "SeedFi")
    debugPrint(text)
    // SeedFi {
    //  NSLanguage = en
    // }

    text.accessibilitySpeechPhoneticNotation = .init(localized: "SeedFiPronunciation")
    debugPrint(text)
    // SeedFi {
    //   UIAccessibilitySpeechAttributeIPANotation = SeedFigh
    //   NSLanguage = en
    // }
    return text
  }()
}
