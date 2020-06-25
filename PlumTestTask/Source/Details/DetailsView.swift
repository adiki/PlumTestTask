//
//  DetailsView.swift
//  PlumTestTask
//
//  Created by Adrian Śliwa on 23/06/2020.
//  Copyright © 2020 sliwa.adrian. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

struct DetailsView: View {
    @ObservedObject
    private var viewStore: ViewStore<DetailsState, DetailsAction>
    
    init(viewStore: ViewStore<DetailsState, DetailsAction>) {
        self.viewStore = viewStore
        viewStore.send(.fetchComicsImagesIfNeeded)
    }
    
    var body: some View {
        guard let hero = viewStore.selectedHero else {
            return EmptyView().eraseToAnyView()
        }
        return ZStack {
            Color.background.edgesIgnoringSafeArea(.all)
            GeometryReader { geometry in
                ScrollView {
                    VStack(alignment: .leading) {
                        self.image(forData: self.viewStore.herosToImageData[hero])
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width,
                                   height: geometry.size.width
                        )
                        Text(hero.name)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.leading, Insets.standard)
                        Button(action: {
                            self.viewStore.send(.recruitOrFireButtonTapped(hero))
                        }) {
                            Text(self.viewStore.state.buttonTitle(for: hero))
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(Insets.standard)
                        }
                        .frame(maxWidth: .infinity)
                        .style(for: hero, state: self.viewStore.state)
                        Text(hero.description)
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .padding([.leading, .bottom], Insets.standard)
                        if hero.latestComic != nil {
                            Text(Strings.lastAppearedIn)
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding([.leading, .trailing], Insets.standard)
                                .padding([.top, .bottom], Insets.small)
                            HStack(spacing: Insets.standard) {
                                ComicCell(
                                    comic: hero.latestComic!,
                                    imageData: self.viewStore.comicsToImageData[hero.latestComic!]
                                )
                                    .frame(width: self.comicViewWidth(rootSize: geometry.size))
                                if hero.comicJustBeforeLatest != nil {
                                    ComicCell(
                                        comic: hero.comicJustBeforeLatest!,
                                        imageData: self.viewStore.comicsToImageData[hero.comicJustBeforeLatest!]
                                    )
                                    .frame(width: self.comicViewWidth(rootSize: geometry.size))
                                }
                            }
                            .padding([.leading, .trailing], Insets.standard)
                        }
                        if hero.comics.available > 2 {
                            Text(Strings.andOtherComic(number: hero.comics.available - 2))
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(Insets.large)
                                .frame(minWidth: 0, maxWidth: .infinity)
                        }
                    }
                }
            }
        }
        .edgesIgnoringSafeArea([.top])    
        .alert(isPresented: self.viewStore.binding(
            get: { $0.isFiringHeroConfirmationPresented },
            send: .fireConfirmationAlertDismissed
        )) {
             Alert(
                title: Text(Strings.doYouWantToFire(name: hero.name)),
                primaryButton: .destructive(Text(Strings.delete)) {
                    self.viewStore.send(.fire(hero))
                },
                secondaryButton: .cancel(Text(Strings.cancel))
            )
        }
        .eraseToAnyView()
    }
    
    private func comicViewWidth(rootSize: CGSize) -> CGFloat {
        rootSize.width / 2 - Insets.standard * 1.5
    }
}

extension DetailsState {
    func buttonTitle(for hero: Hero) -> String {
        if doesSquadContain(hero: hero) {
            return Strings.fireFromSquad
        } else {
            return Strings.recruitToSquad
        }
    }
}

extension View {
    fileprivate func style(for hero: Hero, state: DetailsState) -> some View {
        if state.doesSquadContain(hero: hero) {
            return bordered().eraseToAnyView()
        } else {
            return filled().eraseToAnyView()
        }
    }
}


struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ZStack {
                DetailsView(
                    viewStore: Store(
                        initialState: AppState(),
                        reducer: appReducer,
                        environment: AppEnvironment(
                            mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
                            herosProvider: HerosNetworkProvider(),
                            persistency: FilePersistency()
                        )
                    ).detailStore.view
                )
            }
        }
    }
}

