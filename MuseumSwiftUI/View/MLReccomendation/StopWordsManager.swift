//
//  StopWordsManager.swift
//  MuseumSwiftUI
//
//  Created by Никита Савенко on 12.04.2024.
//

import Foundation

class StopWordsManager {
    var stopWords: Set<String>

    init() {
        // Вихідний список стоп-слів, який може включати загальні стоп-слова
        self.stopWords = ["та", "в", "з", "для", "що", "є", "у", "із", "від", "під", "на", "і", "зв", "ст", "якого", "той"]
        
        // Додавання українських літер від 'а' до 'я' та 'ї', 'ґ', 'є', 'і'
        let ukrainianAlphabet = ["а", "б", "в", "г", "ґ", "д", "е", "є", "ж", "з", "и", "і", "ї", "й", "к", "л", "м", "н", "о", "п", "р", "с", "т", "у", "ф", "х", "ц", "ч", "ш", "щ", "ь", "ю", "я"]
        self.stopWords = self.stopWords.union(ukrainianAlphabet)
    }
}


