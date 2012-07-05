//
//  CardValuesEvaluator.m
//  Poker iPhone App
//
//  Created by Christian Klumpp on 16.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CardValuesEvaluator.h"

@implementation CardValuesEvaluator

@synthesize fiveBestCards;

//Sortierfunktion nach Wert
- (NSMutableArray* ) sortCards_Values:(NSMutableArray *)allCards
{
    NSArray* temporaryArray = allCards;
    temporaryArray = [temporaryArray sortedArrayUsingComparator:^(PlayingCard* card1, PlayingCard* card2) {
        if (card1.value < card2.value) return (NSComparisonResult) NSOrderedAscending;
        else if (card1.value > card2.value) return (NSComparisonResult) NSOrderedDescending;
        return (NSComparisonResult) NSOrderedSame;
    }];
    NSMutableArray* temporaryMutableArray = [NSMutableArray arrayWithArray:temporaryArray];
    return temporaryMutableArray;
}

- (NSMutableArray* ) sortCardsDescending_Values: (NSMutableArray* ) allCards
{
    NSArray* temporaryArray = allCards;
    temporaryArray = [temporaryArray sortedArrayUsingComparator:^(PlayingCard* card1, PlayingCard* card2) {
        if (card1.value > card2.value) return (NSComparisonResult) NSOrderedAscending;
        else if (card1.value < card2.value) return (NSComparisonResult) NSOrderedDescending;
        return (NSComparisonResult) NSOrderedSame;
    }];
    NSMutableArray* temporaryMutableArray = [NSMutableArray arrayWithArray:temporaryArray];
    return temporaryMutableArray;
}


//Sortierfunktion nach Suit
- (NSMutableArray* ) sortCards_Suits:(NSMutableArray *)allCards
{
    NSArray* temporaryArray = allCards;
    temporaryArray = [temporaryArray sortedArrayUsingComparator:^(PlayingCard* card1, PlayingCard* card2) {
        if (card1.suitType < card2.suitType) return (NSComparisonResult) NSOrderedAscending;
        else if (card1.suitType > card2.suitType) return (NSComparisonResult) NSOrderedDescending;
        return (NSComparisonResult) NSOrderedSame;
    }];
    NSMutableArray* temporaryMutableArray = [NSMutableArray arrayWithArray:temporaryArray];
    return temporaryMutableArray;
}

// Ueberpruefe, ob es sich um einen Flush handelt:
- (NSMutableArray* ) isFlush:(NSMutableArray *)allCards
{
    // falls weniger als fünf Karten in allCards enthalten => kein Flush möglich.
    if ([allCards count] < 5) {
        flush = NO;
        return allCards;
    }
    
    //Sortiere Karten noch Suit und nach Wert in zwei verschiedenen Arrays
    NSMutableArray* allCardsSortedSuits = [NSMutableArray arrayWithArray:allCards];
    allCardsSortedSuits = [self sortCards_Suits:allCardsSortedSuits];

    BOOL flushFound = NO;  //Flush gefunden?
    

    
    //falls ein Flush vorliegt, müssen im nach Suits sortierten Array nun fünf Karten nacheinander das gleiche Suit haben:
    
    //erstes Element im Array:
    PlayingCard* currentPlayingCard = (PlayingCard* ) [allCardsSortedSuits objectAtIndex:0];
    SuitType possiblyFlushedSuitType = currentPlayingCard.suitType;
    int countOfThisSuitType = 1;

    //vergleiche nun den Suittype schrittweise mit der jeweils nächsten Karte
    for (int i=1; i<[allCardsSortedSuits count]; i++) {
        int j = [allCardsSortedSuits count] - i; // Anzahl noch nicht gepruefter Elemente
        if (countOfThisSuitType + j < 5) {
            return allCards;    // kein Flush gefunden
        }
        else {
            //jeweils nächste Karte
            PlayingCard* nextPlayingCard = (PlayingCard* ) [allCardsSortedSuits objectAtIndex:i];
            SuitType suitTypeOfNextPlayingCard = nextPlayingCard.suitType;
            
            //Vergleich mit suitType von currentPlayingCard
            if (suitTypeOfNextPlayingCard == possiblyFlushedSuitType) {
                countOfThisSuitType += 1;
                
                //prüfe ob Flush gefunden wurde:
                if (countOfThisSuitType==5) {
                    flush = YES;
                    flushFound = YES;   // flush gefunden!
                    //falls vor Flush noch andere Karten da waren => rauslöschen
                    int elementsDeleted = 0;
                    for (int k=0; k<=i-5; k++) {
                        [allCardsSortedSuits removeObjectAtIndex:0];
                        elementsDeleted += 1;
                    }
                    i -= elementsDeleted;
                }
            }
            else {
                // wenn bereits ein Flush gefunden wurde, so können die anderen Karten gelöscht werden:
                if (flushFound) {
                    int counter = [allCardsSortedSuits count];
                    for (int k=i; k<counter; k++) {
                        [allCardsSortedSuits removeObjectAtIndex:i];
                    }
                }
                else {
                    possiblyFlushedSuitType = suitTypeOfNextPlayingCard;
                    countOfThisSuitType = 1;
                }
            }
        }
    }
    //wenn die Funktion diesen Punkt erreicht, wurde ein Flush gefunden. Sind im Flush noch mehr als fünf Elemente, so müssen die kleinsten Karten rausgelöscht werden:
    
    return allCardsSortedSuits;  //Flush nach Größe der karten sortiert.
}

//ueberpruefe, ob es sich um ein Straight handelt:
- (NSMutableArray* ) isStraight:(NSMutableArray *)allCards
{
    // falls weniger als fünf Karten in allCards enthalten => keine Straight möglich.
    if ([allCards count] < 5) return allCards;
    
    //Sortiere Karten nach Wert
    NSMutableArray* allCardsSortedValues = [NSMutableArray arrayWithArray:allCards];
    allCardsSortedValues = [self sortCards_Values:allCardsSortedValues];
    
    BOOL straightFound = NO;  //Straight gefunden?
    
    
    
    //falls ein Straight vorliegt müssen fünf der Karten aufeinanderfolgend sein
    
    //erstes Element im Array:
    PlayingCard* currentPlayingCard = (PlayingCard* ) [allCardsSortedValues objectAtIndex:0];   
    int lastValueInStraight = currentPlayingCard.value;
    int countOfStraightedElements = 1;
    //falls ein Straight voliegt müssten jetzt fuenf aufeinanderfolgende Karten im Array enthalten sein.

    //für die Sonderfall-Behandlung, dass die Straight Ass, 2, 3, 4, 5 ist:
    BOOL straightStartsWithTwo = (lastValueInStraight == 2);
    PlayingCard* highestCard = [allCardsSortedValues objectAtIndex:([allCardsSortedValues count] - 1)];
    BOOL aceAmongCards = (highestCard.value == 14);
    //Beginne Vergleiche:
    for (int i=1; i<[allCardsSortedValues count]; i++) {
        int j = [allCardsSortedValues count] - i; // Anzahl noch nicht gepruefter Elemente
        if (countOfStraightedElements + j < 5) {
            straight = NO;
            return allCards;
        }
        else {
            PlayingCard* nextPlayingCard = (PlayingCard* ) [allCardsSortedValues objectAtIndex:i];
            int nextValueInArray = nextPlayingCard.value;
            
            // gleiche können ignoriert werden:
            if (nextValueInArray == lastValueInStraight) {
               [allCardsSortedValues removeObjectAtIndex:i];
                i -= 1;
            }
            
            //aufeinadnerfolgende:
            else if (nextValueInArray == lastValueInStraight + 1) {
                lastValueInStraight = nextValueInArray;
                countOfStraightedElements += 1;
                
                //prüfe ob Flush gefunden wurde:
                if (countOfStraightedElements==5) {
                    straightFound = YES;  // straight gefunden!
                    straight = YES;
                    //falls vor der Straight noch andere Karten da waren => rauslöschen
                    int elementsDeleted = 0;
                    for (int k=0; k<=i-5; k++) {
                        [allCardsSortedValues removeObjectAtIndex:0];
                        elementsDeleted += 1;
                    }
                    i -= elementsDeleted;
                }
            }
            else {
                if (straightStartsWithTwo == YES && lastValueInStraight == 5 && aceAmongCards == YES && i>=4) {
                    straightFound = YES;
                    straight = YES;
                    //restliche aus Array löschen:
                    int counter = [allCardsSortedValues count];
                    for (int k=0; k<counter-5; k++) {
                        [allCardsSortedValues removeObjectAtIndex:5];
                    }
                }
                else {
                    if (straightFound) {
                        int counter = [allCardsSortedValues count];
                        for (int k=i;k<counter;k++) {
                            [allCardsSortedValues removeObjectAtIndex:i];
                        }
                    }
                    else {
                        straightStartsWithTwo = NO;
                        lastValueInStraight = nextValueInArray;
                        countOfStraightedElements = 1;
                    }
                }
            }
        }
    }
    for (int i=0; i<[allCardsSortedValues count] - 5; i++) {
        [allCardsSortedValues removeObjectAtIndex:0];
    }
    return allCardsSortedValues;  //Straight nach Größe der karten sortiert.
}

- (NSMutableArray* ) isFourOfAKind:(NSMutableArray *)allCards
{
    if ([allCards count] < 4) return allCards;

    //Karten nach Werten sortieren:
    //Sortiere Karten nach Wert
    NSMutableArray* allCardsSortedValues = [NSMutableArray arrayWithArray:allCards];
    allCardsSortedValues = [self sortCards_Values:allCardsSortedValues];
    
    //falls ein Vierling vorliegt, muss vier mal der gleiche Wert nacheinander kommen.
    
    //erste Karte
    PlayingCard* currentPlayingCard = (PlayingCard* ) [allCardsSortedValues objectAtIndex:0];
    
    int possibleValueForFourOfAKind = currentPlayingCard.value;
    int countOfEqualElements = 1;
    
    for (int i=1; i<[allCardsSortedValues count]; i++) {
        int j = [allCardsSortedValues count] - i; // Anzahl noch nicht gepruefter Elemente
        if (countOfEqualElements + j < 4) {
            four_of_a_kind = NO;
            return allCards;
        }
        else {
            PlayingCard* nextPlayingCard = (PlayingCard* ) [allCardsSortedValues objectAtIndex:i];
            int nextValueInArray = nextPlayingCard.value;
            if (nextValueInArray == possibleValueForFourOfAKind) {
                countOfEqualElements += 1;
                if (countOfEqualElements == 4) {
                    // Vierling gefunden, jetzt muss noch der Kick gefunden werden:
                    NSMutableArray* temporaryArray = [[NSMutableArray alloc] initWithCapacity:5];
                    for (int k=1; k<=4; k++) {
                        // alle Karten des Vierlings rüberkopieren in das temporäre Array und dann aus dem sortierten Array löschen
                        [temporaryArray addObject:[allCardsSortedValues objectAtIndex:(i-3)]];
                        [allCardsSortedValues removeObjectAtIndex:(i-3)];
                    }
                    // danach ist die höchste Karte im sortierten Array der Kicker:
                    allCardsSortedValues = [self sortCards_Values:allCardsSortedValues];
                    [temporaryArray addObject:[allCardsSortedValues objectAtIndex:2]];
                    four_of_a_kind = YES;
                    return temporaryArray; //fertiges Array zurückgeben.
                }
            }
            else {
                possibleValueForFourOfAKind = nextValueInArray;
                countOfEqualElements = 1;
            }
        }
    }
    four_of_a_kind = NO;
    return allCards;
}

- (NSMutableArray* ) isThreeOfAKind:(NSMutableArray *)allCards
{
    if ([allCards count] < 3) return allCards;
    //Karten nach Werten sortieren:
    //Sortiere Karten nach Wert
    NSMutableArray* allCardsSortedValues = [NSMutableArray arrayWithArray:allCards];
    allCardsSortedValues = [self sortCards_Values:allCardsSortedValues];
    
    //falls ein Vierling vorliegt, muss vier mal der gleiche Wert nacheinander kommen.
    
    //Theoretisch ist es möglich, dass man zwei verschiedene Drillinge hat, dann wollen wir natürlich nur den größeren Drilling, daher macht es Sinn, den Durchlauf von hinten zu starten:
    PlayingCard* currentPlayingCard = (PlayingCard* ) [allCardsSortedValues objectAtIndex:([allCardsSortedValues count]-1)];
    int possibleValueForThreeOfAKind = currentPlayingCard.value;
    int countOfEqualElements = 1;
    
    
    for (int i=([allCardsSortedValues count] - 2); i>=0; i--) {
        int j = i+1; // Anzahl noch nicht gepruefter Elemente
        if (countOfEqualElements + j < 3) {
            three_of_a_kind = NO; //dies ist nur eine Kennzeichnung, dass kein Drilling gefunden wurde
            return allCards; // bedeutet: kein Drilling gefunden!
        }
        else {
            PlayingCard* nextPlayingCard = (PlayingCard* ) [allCardsSortedValues objectAtIndex:i];
            int nextValueInArray = nextPlayingCard.value;
            if (nextValueInArray == possibleValueForThreeOfAKind) {
                countOfEqualElements += 1;
                if (countOfEqualElements == 3) {
                    NSMutableArray* temporaryArray = [[NSMutableArray alloc] initWithCapacity:2];
                    [temporaryArray addObject:[allCardsSortedValues objectAtIndex:i]];
                    [temporaryArray addObject:[allCardsSortedValues objectAtIndex:i+1]];
                    [temporaryArray addObject:[allCardsSortedValues objectAtIndex:i+2]];
                    three_of_a_kind = YES;
                    return temporaryArray;
                }
            }
            else {
                possibleValueForThreeOfAKind = nextValueInArray;
                countOfEqualElements = 1;
            }
        }
    }
    three_of_a_kind = NO;
    return allCards;
}

- (NSMutableArray* ) isOnePair:(NSMutableArray *)allCards
{
    one_pair = NO;
    if ([allCards count] < 3) return allCards;
    //Karten nach Werten sortieren:
    //Sortiere Karten nach Wert
    NSMutableArray* allCardsSortedValues = [NSMutableArray arrayWithArray:allCards];
    allCardsSortedValues = [self sortCards_Values:allCardsSortedValues];
    
    //falls ein Vierling vorliegt, muss vier mal der gleiche Wert nacheinander kommen.
    
    //Theoretisch ist es möglich, dass man drei verschiedene Paare hat, dann wollen wir natürlich nur die beiden größten Paare, daher macht es Sinn, den Durchlauf von hinten zu starten:
    PlayingCard* currentPlayingCard = (PlayingCard* ) [allCardsSortedValues objectAtIndex:([allCardsSortedValues count]-1)];

    int possibleValueForPair = currentPlayingCard.value;
    int countOfEqualElements = 1;
    for (int i=[allCardsSortedValues count]-2; i>=0; i--) {
        int j = i+1; // Anzahl noch nicht gepruefter Elemente
        if (countOfEqualElements + j < 2) {
            one_pair = NO; //dies ist eine Kennzeichnung, dass kein Paar gefunden wurde.
            return allCards;
        }
        else {
            PlayingCard* nextPlayingCard = (PlayingCard* ) [allCardsSortedValues objectAtIndex:i];
            int nextValueInArray = nextPlayingCard.value;
            if (nextValueInArray == possibleValueForPair) {
                countOfEqualElements += 1;
                if (countOfEqualElements == 2) {
                    NSMutableArray* temporaryArray = [[NSMutableArray alloc] initWithCapacity:2];
                    [temporaryArray addObject:[allCardsSortedValues objectAtIndex:i]];
                    [temporaryArray addObject:[allCardsSortedValues objectAtIndex:(i+1)]];
                    one_pair = YES;
                    return temporaryArray;
                }
            }
            else {
                possibleValueForPair = nextValueInArray;
                countOfEqualElements = 1;
            }
        }
    }
    one_pair = NO;
    return allCards;
}


/*Idee: Pruefe zunaechst, ob ein Flush vorliegt:
        - wenn ja: pruefe, ob straight flush
        - wenn nein: => flush
        Pruefe dann ob, straight vorliegt:
        - wenn ja: straight
        Pruefe, ob vierlingt
        - wenn ja: vierling
        Pruefe, ob FullHouse
        ...
        usw.
 */


//Straight flush noch fehlerhaft, da Bestimmung nach fünftem Flush element abbricht!

- (void) defineValueOfFiveBestCards:(NSMutableArray *)allCards
{
    // noch nichts gefunden:
    flush = NO;
    straight = NO;
    four_of_a_kind = NO;
    three_of_a_kind = NO;
    one_pair = NO;
    
    //Überprüfe, ob Flush:
    NSMutableArray* possiblyBestFiveCards = [NSMutableArray arrayWithArray:allCards];
    possiblyBestFiveCards = [self isFlush:possiblyBestFiveCards];
    if (flush == YES) {
        possiblyBestFiveCards = [self isStraight:possiblyBestFiveCards];
        //Überprüfe ob Straight Flush
        if (straight == YES) {
            possiblyBestFiveCards = [self sortCardsDescending_Values:possiblyBestFiveCards];
            PlayingCard* highestCard = (PlayingCard* ) [possiblyBestFiveCards objectAtIndex:0];
            self.fiveBestCards.arrayOfFiveBestCards = possiblyBestFiveCards;
            if (highestCard.value == 14) {
                self.fiveBestCards.valueOfFiveBestCards = ROYAL_FLUSH;
                self.fiveBestCards.cardValuesAsString = @"Royal Flush";
                return;
            }
            self.fiveBestCards.valueOfFiveBestCards = STRAIGHT_FLUSH;
            self.fiveBestCards.cardValuesAsString = @"Straight Flush";
            return;
        }
        else {
            possiblyBestFiveCards = [self sortCards_Values:possiblyBestFiveCards];
            for (int i=0;i<[possiblyBestFiveCards count]-5;i++) {
                [possiblyBestFiveCards removeObjectAtIndex:0];
            }
            possiblyBestFiveCards = [self sortCardsDescending_Values:possiblyBestFiveCards];
            self.fiveBestCards.arrayOfFiveBestCards = possiblyBestFiveCards;
            self.fiveBestCards.valueOfFiveBestCards = FLUSH;
            self.fiveBestCards.cardValuesAsString = @"Flush";
            return;
        }
    }
    
    //Überprüfe, ob Straight:
    possiblyBestFiveCards = [NSMutableArray arrayWithArray:allCards];
    possiblyBestFiveCards = [self isStraight:possiblyBestFiveCards];
    if (straight == YES) {
        possiblyBestFiveCards = [self sortCardsDescending_Values:possiblyBestFiveCards];
        self.fiveBestCards.arrayOfFiveBestCards = possiblyBestFiveCards;
        self.fiveBestCards.valueOfFiveBestCards = STRAIGHT;
        self.fiveBestCards.cardValuesAsString = @"Straight";
        return;
    }
    
    //Überprüfe, ob Vierling:
    possiblyBestFiveCards = [NSMutableArray arrayWithArray:allCards];
    possiblyBestFiveCards = [self isFourOfAKind:possiblyBestFiveCards];
    if (four_of_a_kind == YES) {
        self.fiveBestCards.arrayOfFiveBestCards = possiblyBestFiveCards;
        self.fiveBestCards.valueOfFiveBestCards = FOUR_OF_A_KIND;
        self.fiveBestCards.cardValuesAsString = @"Four of a Kind";
        return;
    }
    
    //Überprüfe, ob Drilling:
    // Rückgabe von Drillingsuche nur 3 Elemente, daher:
    possiblyBestFiveCards = [NSMutableArray arrayWithArray:allCards];
    NSMutableArray* highestThreeOfAKind = [self isThreeOfAKind:possiblyBestFiveCards];
    if (three_of_a_kind == YES) {
        [possiblyBestFiveCards removeObject:[highestThreeOfAKind objectAtIndex:0]];
        [possiblyBestFiveCards removeObject:[highestThreeOfAKind objectAtIndex:1]];
        [possiblyBestFiveCards removeObject:[highestThreeOfAKind objectAtIndex:2]];
        NSMutableArray* highestPair = [self isOnePair:possiblyBestFiveCards];
        //Überprüfe, ob Full House!
        if (one_pair == YES) {
            [possiblyBestFiveCards removeAllObjects];
            [possiblyBestFiveCards addObjectsFromArray:highestPair];
            [possiblyBestFiveCards addObjectsFromArray:highestThreeOfAKind];
            self.fiveBestCards.arrayOfFiveBestCards = possiblyBestFiveCards;
            self.fiveBestCards.valueOfFiveBestCards = FULL_HOUSE;
            self.fiveBestCards.cardValuesAsString =@"Full House";
            return;
        }
        possiblyBestFiveCards = [self sortCards_Values:possiblyBestFiveCards];
        [highestThreeOfAKind addObject:[possiblyBestFiveCards objectAtIndex:([possiblyBestFiveCards count] - 1)]];
        [highestThreeOfAKind addObject:[possiblyBestFiveCards objectAtIndex:([possiblyBestFiveCards count] - 2)]];
        self.fiveBestCards.arrayOfFiveBestCards = highestThreeOfAKind;
        self.fiveBestCards.valueOfFiveBestCards = THREE_OF_A_KIND;
        self.fiveBestCards.cardValuesAsString = @"Three of a Kind";
        return;
    }
    
    //Überprüfe, ob Paar
    possiblyBestFiveCards = [NSMutableArray arrayWithArray:allCards];
    NSMutableArray* highestPair = [self isOnePair:possiblyBestFiveCards];
    if (one_pair == YES) {
        [possiblyBestFiveCards removeObject:[highestPair objectAtIndex:0]];
        [possiblyBestFiveCards removeObject:[highestPair objectAtIndex:1]];
        NSMutableArray* secondHighestPair = [self isOnePair:possiblyBestFiveCards];
        //Überprüfe, ob 2 Paare
        if (one_pair == YES) {
            [possiblyBestFiveCards removeObject:[secondHighestPair objectAtIndex:0]];
            [possiblyBestFiveCards removeObject:[secondHighestPair objectAtIndex:1]];
            possiblyBestFiveCards = [self sortCards_Values:possiblyBestFiveCards];
            PlayingCard* kicker = (PlayingCard* ) [possiblyBestFiveCards objectAtIndex:([possiblyBestFiveCards count] - 1)];
            NSMutableArray* temporaryArray = [[NSMutableArray alloc] initWithCapacity:5];
            [temporaryArray addObjectsFromArray:highestPair];
            [temporaryArray addObjectsFromArray:secondHighestPair];
            [temporaryArray addObject:kicker];
            self.fiveBestCards.arrayOfFiveBestCards = temporaryArray;
            self.fiveBestCards.valueOfFiveBestCards = TWO_PAIRS;
            self.fiveBestCards.cardValuesAsString = @"Two Pairs";
            return;
        }
        possiblyBestFiveCards = [self sortCards_Values:possiblyBestFiveCards];
        [highestPair addObject:[possiblyBestFiveCards objectAtIndex:([possiblyBestFiveCards count] - 1)]];
        if ([possiblyBestFiveCards count] > 3) {
            [highestPair addObject:[possiblyBestFiveCards objectAtIndex:([possiblyBestFiveCards count] - 2)]];
        }
        if ([possiblyBestFiveCards count] > 4) {
            [highestPair addObject:[possiblyBestFiveCards objectAtIndex:([possiblyBestFiveCards count] - 3)]];
        }
        self.fiveBestCards.arrayOfFiveBestCards = highestPair;
        self.fiveBestCards.valueOfFiveBestCards = ONE_PAIR;
        self.fiveBestCards.cardValuesAsString = @"One Pair";
        return;
    }
    
    //High Card
    possiblyBestFiveCards = [self sortCardsDescending_Values:allCards];
    while ([possiblyBestFiveCards count] > 5) {
        [possiblyBestFiveCards removeObjectAtIndex:5];
    }
    self.fiveBestCards.arrayOfFiveBestCards = possiblyBestFiveCards;
    self.fiveBestCards.valueOfFiveBestCards = HIGH_CARD;
    self.fiveBestCards.cardValuesAsString = @"High Card";
    return;
}

- (id) init
{
    self = [super init];
    fiveBestCards = [[FiveBestCards alloc] init];
    return self;
}

@end
