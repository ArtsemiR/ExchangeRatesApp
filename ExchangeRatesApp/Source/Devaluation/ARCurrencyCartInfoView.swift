//
//  ARCurrencyCartInfoView.swift
//  ExchangeRatesApp
//
//  Created by Artsemi Ryzhankou on 7/28/20.
//  Copyright © 2020 Artsemi Ryzhankou. All rights reserved.
//

import SwiftUI

struct ARCurrencyCartInfoView: View {

    private let title: String = "Белорусская валютная корзина"

    private let firstP: String = "    Как правило, для расчета корзины выбирают валюты, на которые завязана наибольшая часть торгового оборота страны. Для Беларуси это российский рубль, доллар и евро. На российский рубль приходится самая большая часть торгового оборота, поэтому в нашей корзине российский рубль занимает 50%, доллар - 30% и евро - 20%."

    private let secondP: String = "    Такой метод оценки национальных валют используют Центробанки многих стран с целью понять, что происходит с национальной валютой по отношению к основным валютам."

    private let thirdP: String = "    Рассмотрим пример: если на биржевых торгах растут сразу все основные валюты — доллар, евро и российский рубль, то очевидно, что белорусский рубль обесценивается. Важна динамика изменения стоимости корзины. Если в течение месяца стоимость корзины растет, то мы становимся беднее, а сбережения лучше хранить в валюте. И наоборот, если стоимость корзины падает, то мы становимся богаче и сбережения предпочтительнее хранить в рублях."

    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                Text(self.title)
                    .fontWeight(.semibold)
                    .font(.subheadline)
                Text(self.firstP)
                    .font(.footnote)
                Image("pie-chart-icon").resizable()                    .frame(width: 150, height: 150)
                Text(self.secondP)
                    .font(.footnote)
                Text(self.thirdP)
                    .fontWeight(.light)
                    .font(.footnote)
                    .italic()
            }
            .padding(EdgeInsets(top: 16, leading: 8, bottom: 8, trailing: 8))
        }.navigationBarTitle("", displayMode: .inline)
    }
}
