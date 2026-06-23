import Foundation

enum CountryCodeLoader {
    private static var cached: [CountryCodeItem]?

    static func load() -> [CountryCodeItem] {
        if let cached {
            return cached
        }
        let loaded = loadFromBundle()
        cached = loaded
        return loaded
    }

    static func loadAsync(completion: @escaping ([CountryCodeItem]) -> Void) {
        if let cached {
            completion(cached)
            return
        }

        DispatchQueue.global(qos: .userInitiated).async {
            let loaded = loadFromBundle()
            DispatchQueue.main.async {
                cached = loaded
                completion(loaded)
            }
        }
    }

    private static func loadFromBundle() -> [CountryCodeItem] {
        let bundle = Bundle(for: PhoneEntryPlatformView.self)
        guard let url = bundle.url(forResource: "country_code", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let items = try? JSONDecoder().decode([CountryCodeItem].self, from: data)
        else {
            return [
                CountryCodeItem(name: "Canada", flag: "🇨🇦", code: "CA", dial_code: "+1"),
            ]
        }
        return items
    }
}
