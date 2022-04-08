

    // Inicjator
    begin:
        jmp init // Odniesienie do petli systemu

        // Przerwania
        jmp keysets // Przerwanie 0x1
        jmp keyboard // Przerwanie 0x2
        ret // Przerwanie 0x3
        jmp grphstart // Przerwanie 0x4
        jmp grphcleared // Przerwanie 0x5
        ret // Przerwanie 0x6
        jmp exception // Wyjatki

    clearreg:
        set eax 0x0 // Czyszczenie rejestrow
        set ebx 0x0
        set ecx 0x0
        set edx 0x0
        ret

    regcopyn: // Kopia rejestrów w pamięci
        ram 0x1ff0
            save eax // Zapis rejestru a
        ram 0x1ff1
            save ebx // Zapis rejestru a
        ram 0x1ff2
            save ecx // Zapis rejestru a
        ram 0x1ff3
            save edx // Zapis rejestru a

        ret

    regcopy: // Kopia rejestrów w pamięci
        ram 0x1ff0
            save eax // Zapis rejestru a
        ram 0x1ff1
            save ebx // Zapis rejestru a
        ram 0x1ff2
            save ecx // Zapis rejestru a
        ram 0x1ff3
            save edx // Zapis rejestru a

        call clearreg

        ret

    regcopyinter: // Kopia rejestrów w pamięci
        ram 0x1ff4
            save eax // Zapis rejestru a
        ram 0x1ff5
            save ebx // Zapis rejestru a
        ram 0x1ff6
            save ecx // Zapis rejestru a
        ram 0x1ff7
            save edx // Zapis rejestru a

        call clearreg

        ret

    regback: // Powrót pierwornych rejestrów
        ram 0x1ff0
            read eax // Odzysk rejestru a
        ram 0x1ff1
            read ebx // Odzysk rejestru b
        ram 0x1ff2
            read ecx // Odzysk rejestru c
        ram 0x1ff3
            read edx // Odzysk rejestru d

        ret

    regbackinter: // Powrót pierwornych rejestrów
        ram 0x1ff4
            read eax // Odzysk rejestru a
        ram 0x1ff5
            read ebx // Odzysk rejestru b
        ram 0x1ff6
            read ecx // Odzysk rejestru c
        ram 0x1ff7
            read edx // Odzysk rejestru d

        ret

    keysets:  // Obsługa wyjątku

        call regcopyinter // Zapis rejestrow
        sot 0x2

        in eax 0x0

        set ebx 0x000f // Usuniecie zbednych informacji
        and eax ebx

        ram 0x1fe0
        save eax // Zapis do bufora klawiatury

        call regbackinter // Powrot do stanu pierwotnego
        ret

    keyboard:

         call regcopyinter // Zapis rejestrow
         sot 0x3

         in eax 0x0

                set ebx 0x00ff // Usuniecie zbednych informacji
                and eax ebx

                ram 0x1fe1
                    save eax // Zapis do bufora klawiatury

                call regbackinter // Powrot do stanu pierwotnego


        ret

    loadPalette:
                set ecx 0x0
                set edx 0x1fd0

                loopgrph:
                    set eax 0x3 // GET PALETTE.NUMBER
                    mov ebx ecx


                        call sendGraphics

                    set eax 0x4 // GET PALETTE.NUMBER
                        uram edx
                        read ebx


                        call sendGraphics

                        set eax 0xffe0
                        and ebx eax
                    set eax 0x5

                        call sendGraphics

                    inc edx
                    inc ecx

                    set eax 0x2
                    cmp ecx eax

                    jgt endloopgrph
                    jmp loopgrph

                endloopgrph:


        ret

    grphstart:
        call regcopyinter

        ram 0x1fc2
            set eax 0xffff
            save eax


        call regbackinter
        ret

    grphcleared:
        call regcopyinter

        ram 0x1002
            set eax 0xffff
            save eax


        call regbackinter
        ret

    exception:

        ret

    clearout:
        call regcopy // Zapis rejestrow

        set ecx 0x0 // Wyczyszcenie wyjscia
        out ecx 0x0

        call regback // Zapis rejestrow
        ret

    sendCopper: // Wyslanie wiadomosci
        call regcopyn

        set ecx 0x4000 // Dodanie identyfikatora
        eor eax ecx

        out ebx 0x0 // Wyslanie informacji
        out eax 0x1

        call regback
        ret

    sendBuzzer: // Wyslanie wiadomosci
        call regcopyn

        set ecx 0xf000 // Dodanie identyfikatora
        eor eax ecx

        out ebx 0x0 // Wyslanie informacji
        out eax 0x1

        call regback
        ret

    sendGraphics: // Wyslanie wiadomosci
        call regcopyn

        set ecx 0x8000 // Dodanie identyfikatora
        eor eax ecx

        out ebx 0x0 // Wyslanie informacji
        out eax 0x1

        call regback
        ret

    ramclear: // Czyszczenie pamieci
        set eax 0x1000 // Adres startowy

        loopram:

             uram eax // Czyszczenie komorki
                set ebx 0x0 // Zawartosc pustej komorki pamieci
                save ebx

             inc eax // Przejscie do następnego adresu
                 set ebx 0x2000 // Maksymalny adres

             cmp eax ebx // Sprawdzenie czy osiagniento maksymalny adres
                 jeq endloopram // Jezeli osiagnieto koncze operacje

             jmp loopram

        endloopram: // Koniec czyszczenia

             set eax 0x0  // Czyszczenie rejeestrow
             set ebx 0x0


        ret

    loadcharset:

        set edx 0x0e00 // Adresowanie komórki tekstury

                ram 0x1020 // Zerowanie pierwotnej petli
                    set ebx 0x0
                    save ebx


                looptypechar: // Wybieranie typu znaku

                    ram 0x1020
                        read ebx

                    set eax 0x6
                        call sendGraphics

                        set ecx 0x0
                        loopchar:

                            set eax 0x7
                            mov ebx ecx
                                call sendGraphics

                            uram edx
                                read ebx

                                set eax 0x8
                                    call sendGraphics
                                set eax 0x9
                                    call sendGraphics



                            inc edx // Adres komorki do przeniesienia
                            inc ecx // YLINE

                            set eax 0x7 // Warunek koncowy petli
                                cmp ecx eax
                                jgt endloopchar

                            jmp loopchar

                    endloopchar:

                    ram 0x1020 // Wcyztanie licznika znakow
                        read ebx

                    set eax 0x003f // Sprawdzenie przekroczenia
                        cmp ebx eax
                        jgt endlooptypechar // Koniec

                        inc ebx // Postep
                            save ebx
                    jmp looptypechar

                endlooptypechar:

            ram 0x1020
            set eax 0x0
            save eax

            call clearreg
        ret

    clearPalette:
            set ecx 0x0

                loopgrph:
                    set eax 0x3 // GET PALETTE.NUMBER
                    mov ebx ecx


                        call sendGraphics

                    set eax 0x4 // GET PALETTE.NUMBER
                    set ebx 0x0


                        call sendGraphics


                    inc edx
                    inc ecx

                    set eax 0x2
                    cmp ecx eax

                    jgt endloopgrph
                    jmp loopgrph

                endloopgrph:

        ret

    waitForGraphAnswer:

        loopfinishClearScreen:
                ram 0x1002
                    read eax
                    set ebx 0xffff
                    cmp eax ebx
                        jeq finishClearScreen
                    jmp loopfinishClearScreen

                finishClearScreen:
        ret

    loadBuffer:
            call clearreg

            ram 0x1002
                 set eax 0x0
                 save eax

            set eax 0xfd
            set ebx 0x0

            // Wyslanie prosby do karty
                call sendGraphics


                call waitForGraphAnswer
            ret

    doubleDabbleAlgorithm:
        call clearreg

            // Inicjacja wartosci

            ram 0x1fa5 // Wskaźnik
                set edx 0x0
                save edx

                set ecx 0x1fa8

                    loopLoadDableNumberLoop:
                    uram ecx

                        set edx 0x0
                        save edx

                    inc ecx
                        set ebx 0x1fad
                        cmp ecx ebx
                            jlt loopLoadDableNumberLoop


            ram 0x1fad // Koniec napisu cyfry
                set edx 0xf
                save edx





            loopDable:

                ram 0x1fa4 // Wartosc konwertowana

                    read eax
                        mov ecx eax

                    set ebx 0x8000 // Wyciagniecie najstarszego bitu
                        and eax ebx

                    set ebx 0x7 // Sprowadzenie najstarszego bitu do konca
                        shr eax ebx
                        res eax

                    set ebx 0x6 // Sprowadzenie najstarszego bitu do konca
                        shr eax ebx
                        res eax

                        mov edx eax // Skladowanie najstarszego bitu -->

                    set ebx 0x0 // Przesuniecie
                        shl ecx ebx
                        res ecx

                    set ebx 0xffff // Usuniecie niepotrzebnych bitow
                        and ecx ebx

                        save ecx

                ram 0x1fae
                    set eax 0x1fad
                    save eax

                loopDabbleNumber:
                    ram 0x1fae
                        read eax
                            dec eax
                            save eax
                    uram eax
                        read eax


                        // Liczenie
                            set ebx 0x5

                            cmp eax ebx
                                jeq dabble2
                                jgt dabble2
                                jmp endDabble2

                            dabble2:
                                set ebx 0x3
                                add eax ebx

                            endDabble2:
                        mov ecx eax


                        set ebx 0x0008 // Wyciagniecie najstarszego bitu
                             and ecx ebx

                        set ebx 0x2 // Sprowadzenie najstarszego bitu do konca
                            shr ecx ebx
                            res ecx // Skladowanie najstarszego bitu -->

                        set ebx 0x0 // Przeuniecie
                            shl eax ebx
                            res eax

                            add eax edx // Dodanie poprzedniego naj bitu

                        set ebx 0xf // Usuniecie zbednych wartosci
                            and eax ebx

                            mov edx ecx
                            save eax

                    ram 0x1fae
                        read eax
                        set ebx 0x1fa9
                        cmp eax ebx
                            jgt loopDabbleNumber

                ram 0x1fa8
                    read eax

                    // Liczenie
                        set ebx 0x5

                        cmp eax ebx
                            jeq dabble0
                            jgt dabble0
                            jmp endDabble0

                        dabble0:
                            set ebx 0x3
                            add eax ebx

                        endDabble0:

                    mov ecx eax

                    set ebx 0x0 // Przeuniecie
                        shl eax ebx
                        res eax

                        add eax edx // Dodanie poprzedniego naj bitu

                    set ebx 0xf // Usuniecie zbednych wartosci
                        and eax ebx

                        save eax

                ram 0x1fa5
                    read eax
                    set ebx 0xe
                    cmp eax ebx
                        jgt finloopDable

                    inc eax
                    save eax

                jmp loopDable
            finloopDable:

            // Zamiana liczb na znaki
            ram 0x1fa8
                read edx
                inc edx
                save edx

            ram 0x1fa9
                read edx
                inc edx
                save edx

            ram 0x1faa
                read edx
                inc edx
                save edx

            ram 0x1fab
                read edx
                inc edx
                save edx

            ram 0x1fac
                read edx
                inc edx
                save edx
        ret
    intToStr:
            ram 0x1fa4 // Wczytanie wartosci
                read eax

                set ebx 0x0
                    cmp eax ebx
                    jlt makeMinusINT
                    jmp notMakeMinusINT

                makeMinusINT:
                        ram 0x1fb1 // minus
                        set ebx 0xb
                    save ebx
                    jmp endMakeMinusINT
                notMakeMinusINT:
                        ram 0x1fb1 // Kropka
                        set ebx 0x0
                    save ebx
                    jmp endMakeMinusINT
                endMakeMinusINT:

                ram 0x1fa4
                call abs // Wyciagniecie war bezwzgl

                    save eax

            call doubleDabbleAlgorithm


                    ram 0x1fa8 // Przepisanie
                read eax
                    ram 0x1fb2
                save eax

                    ram 0x1fa9 // Przepisanie
                read eax
                    ram 0x1fb3
                save eax

                    ram 0x1faa // Przepisanie
                read eax
                    ram 0x1fb4
                save eax

                    ram 0x1fab // Przepisanie
                read eax
                    ram 0x1fb5
                save eax

                    ram 0x1fac // Przepisanie
                read eax
                    ram 0x1fb6
                save eax

                    ram 0x1fb7 // Koniec
                    set eax 0xf
                save eax

            call reduceStrNumber

        ret
    doubleToStr:

            ram 0x1fb0 // Wczytanie wartosci
                read eax

                set ebx 0x0
                    cmp eax ebx
                    jlt makeMinusDouble
                    jmp notMakeMinusDouble

                makeMinusDouble:
                        ram 0x1fb1 // minus
                        set ebx 0xb
                    save ebx
                    jmp endMakeMinusDouble
                notMakeMinusDouble:
                        ram 0x1fb1 // Kropka
                        set ebx 0x0
                    save ebx
                    jmp endMakeMinusDouble
                endMakeMinusDouble:

                ram 0x1fb0
                call abs // Wyciagniecie war bezwzgl

                    save eax

                read eax
                set ebx 0xff // Wyciagniecie czesci ulamkowej
                    and eax ebx

            ram 0x1fa4 // Wartosc konwertowana

                set ebx 0x7
                    shl eax ebx
                    res eax

            set ebx 0x2710 // * (1000/256)

                emul eax ebx
                     res eax

                // Drugi rejestr

                save eax

            call doubleDabbleAlgorithm

                    ram 0x1fb5 // Kropka
                    set eax 0x3a
                save eax

                    ram 0x1fa9 // Przepisanie
                read eax
                    ram 0x1fb6
                save eax

                    ram 0x1faa // Przepisanie
                read eax
                    ram 0x1fb7
                save eax

                    ram 0x1fab // Przepisanie
                read eax
                    ram 0x1fb8
                save eax

                    ram 0x1fac // Przepisanie
                read eax
                    ram 0x1fb9
                save eax

                    ram 0x1fba // Koniec
                    set eax 0xf
                save eax

            ram 0x1fb0 // Wczytanie wartosci
                read eax
                set ebx 0xff00 // Wyciagniecie czesci ulamkowej
                    and eax ebx

                set ebx 0x7
                    shr eax ebx
                    res eax

            ram 0x1fa4
                save eax
                call doubleDabbleAlgorithm

                    ram 0x1faa // Przepisanie
                read eax
                    ram 0x1fb2
                save eax

                    ram 0x1fab // Przepisanie
                read eax
                    ram 0x1fb3
                save eax

                    ram 0x1fac // Przepisanie
                read eax
                    ram 0x1fb4
                save eax

            call reduceStrNumber
        ret


    reduceStrNumber:

        loopReduceStrNumber:

            ram 0x1fb3
                read eax
                set ebx 0x3a
                    cmp eax ebx
                    jeq eloopReduceStrNumber
                set ebx 0xf
                    cmp eax ebx
                    jeq eloopReduceStrNumber

            ram 0x1fb2
                read eax

                set ebx 0x0
                    cmp eax ebx
                    jeq shiftNumberReduceStr
                set ebx 0x1
                    cmp eax ebx
                    jeq shiftNumberReduceStr
                jmp eloopReduceStrNumber

            shiftNumberReduceStr:

                    ram 0x1fb3
                        read edx
                    ram 0x1fb2
                        save edx

                    ram 0x1fb4
                        read edx
                    ram 0x1fb3
                        save edx

                    ram 0x1fb5
                        read edx
                    ram 0x1fb4
                        save edx

                    ram 0x1fb6
                        read edx
                    ram 0x1fb5
                        save edx

                    ram 0x1fb7
                        read edx
                    ram 0x1fb6
                        save edx

                    ram 0x1fb8
                        read edx
                    ram 0x1fb7
                        save edx

                    ram 0x1fb9
                        read edx
                    ram 0x1fb8
                        save edx

                    ram 0x1fba
                        read edx
                    ram 0x1fb9
                        save edx

                    ram 0x1fba
                         set edx 0x0
                         save edx

            jmp loopReduceStrNumber
        eloopReduceStrNumber:

        ret

    print:
            call clearreg
            set edx 0x0



                loopWriter:

                    set eax 0x0a // Wybor pozycji w X

                         ram 0x1fc0 // Wczytanie z rejestru pozycji pisarza dla X
                            read ebx

                         set ecx 0x2 // Odstęp

                         shl ebx ecx // Przesuniecie aby byl odstep miedzy znakami
                            res ebx

                          // Wyslanie prosby do karty
                         call sendGraphics

                    set eax 0x0b // Wybor pozycji Y
                          ram 0x1fc1 // Wczytanie z rejestru pozycji pisarza dla Y
                              read ebx

                          set ecx 0x2 // Odstęp

                          shl ebx ecx // Przesuniecie aby byl odstep miedzy znakami
                          res ebx

                           // Wyslanie prosby do karty
                          call sendGraphics

                    set eax 0x0c // Wybor znaku
                          ram 0x1fc3 // Wczytanie wskaznika ciagu
                              read ebx
                              mov ecx ebx

                              inc ecx // Przeskok do nastepnego

                              save ecx

                          uram ebx // Wczytanie znaku ciagu
                               read ebx
                               set ecx 0xff // Wybranie najmłodszego bajtu rejestru
                               and ebx ecx

                          set ecx 0x1f
                               cmp ebx ecx
                               jeq newLineWriter

                          set ecx 0xf // Sprawdzenie czy to nie koniec stringa
                          cmp ebx ecx
                              jeq finishWriter


                          call sendGraphics


                    ram 0x1fc0 // Wczytanie z rejestru pozycji pisarza dla Y
                        read ebx

                    set ecx 0x20
                        cmp ebx ecx

                        jgt newLineWriter
                        jmp finalAnalyseWriter

                    newLineWriter:

                    ram 0x1fc0 // Nowa linia
                        set ebx 0x4
                        save ebx

                    ram 0x1fc1
                        read ebx

                        inc ebx

                        save ebx

                    finalAnalyseWriter:
                        ram 0x1fc0 // postep
                          read ebx

                          inc ebx

                          save ebx

                    inc edx // Liczenie znakow wpisanych

                    set ebx 0x3a

                    cmp edx ebx // Porownanie
                        jeq finishWriter
                        jgt finishWriter

                        jmp loopWriter

                    finishWriter:

        ret

    abs:
        set ebx 0x0
            cmp eax ebx
                jlt makeAbs
                jmp endAbs
        makeAbs:
            not eax
            inc eax
        endAbs:

        ret

    mulDouble:

        mul eax ebx
             res ecx
        emul eax ebx
             res edx

        set eax 0xff00
            and ecx eax
        set eax 0x00ff
            and edx eax

        set eax 0x7
            shr ecx eax
                res ecx
            shl edx eax
                res edx

        eor edx ecx
        mov eax edx

        ret

    divDouble:
           // Przygotowanie liczb

            ograniczDivDouble:
                set ecx 0xff

                    cmp eax ecx
                        jgt doOgraniczDivDouble
                    cmp ebx ecx
                        jgt doOgraniczDivDouble

                jmp endOgraniczDivDouble
                doOgraniczDivDouble:

                set ecx 0x0
                    shr eax ecx
                        res eax
                    shr ebx ecx
                        res ebx

                jmp ograniczDivDouble
            endOgraniczDivDouble:


            div eax ebx
                res ecx

            rem eax ebx // Czesc ulamkowa
                res edx

                set eax 0x7
                    shl edx eax
                    res edx

                div edx ebx
                    res edx



            set eax 0x7 // Czesc calkowita
                shl ecx eax
                res ecx
                mov eax ecx

            eor eax edx   // Polaczenie
        ret



    init: // Czyszczenie ramu


        call ramclear


        call clearPalette
        call loadcharset // Ladowanie znakow



        set eax 0x0340 // Tlo systemowe
             ram 0x1fd0
             save eax


        ram 0x1faf // Wartosc konwertowana
                set edx 0x0
                save edx


        call loadPalette

        call clearreg
        jmp main


    startupsound:

        ram 0x1010
            read eax

            set ebx 0xf
            cmp eax ebx
                jeq endstartupsound

        mov ebx eax


        inc ebx
        ram 0x1010
            save ebx

        set ecx 0x7
            cmp ebx ecx
            jlt sound1
            jmp sound2

        sound1:
            set eax 0x1
            set ebx 0xf
            jmp endsound

        sound2:
            set eax 0x1
            set ebx 0x2
            jmp endsound

        endsound:
        call sendBuzzer

        ret

        endstartupsound:
             set eax 0x2
             set ebx 0x0
             call sendBuzzer
        ret
    main: // Petla glowna systemu
            call loadBuffer

            ram 0x1fc0 // Pozycja zero X
                 set ebx 0x5
                 save ebx

             ram 0x1fc1 // Pozycja zero Y
                 set ebx 0x3
                 save ebx

            ram 0x1fc3 // Wskzanik strigna do wartosci konwertowaej
                 set ebx 0x0d00
                 save ebx


            call print

            set eax 0xffff
                   ram 0x1fb0
                   save eax

            call doubleToStr

             ram 0x1fc3 // Wskzanik strigna do wartosci konwertowaej
                 set ebx 0x1fb1
                 save ebx


        call print

            ram 0x1fc1 // Pozycja zero Y
                 set ebx 0x4
                 save ebx

             ram 0x1fe1
                 read eax

            ram 0x1fa4
                save eax

            ram 0x1fe1
                set ebx 0x0
                save eax

        call intToStr

            ram 0x1fc0 // Pozycja zero X
                 read ebx
                 inc ebx
                 save ebx

             ram 0x1fc3 // Wskzanik strigna do wartosci konwertowaej
                 set ebx 0x1fb1
                 save ebx
                 call print

        call clearreg

        set eax 0x0d
        set ebx 0x1

        call sendGraphics

        call startupsound



        set eax 0x5
        set ebx 0x0

        call sendCopper

        ram 0x1fc2 // Sprawdzanie zgloszenia przerwania przez uklad graficzny
            set eax 0x0
            save eax

        waitForGraphics:
            read eax
            set ebx 0xffff // Wartosc oczekiwana
            cmp eax ebx
                jeq renderGraphics // Przekierowanie wrazie wykrycia rozpoczecia nowej klatki
            jmp waitForGraphics

        renderGraphics: // Render nowej klatki

        set ebx 0x0 // Czysczenie wartosci rejestru detekotora
        save ebx


        jmp main // Zapetlenie

    // String
    &data 0x0d00 < 0000000000111110
    &data 0x0d01 < 0000000000000001
    &data 0x0d02 < 0000000000000010
    &data 0x0d03 < 0000000000000011
    &data 0x0d04 < 0000000000000100
    &data 0x0d05 < 0000000000000101
    &data 0x0d06 < 0000000000000110
    &data 0x0d07 < 0000000000000111
    &data 0x0d08 < 0000000000001000
    &data 0x0d09 < 0000000000001001
    &data 0x0d0a < 0000000000001010
    &data 0x0d0b < 0000000000000001
    &data 0x0d0c < 0000000000000000
    &data 0x0d0d < 0000000000001111

    // Charset
    &data 0x0e00 < 0000000000000000
    &data 0x0e01 < 0000000000000000
    &data 0x0e02 < 0000000000000000
    &data 0x0e03 < 0000000000000000
    &data 0x0e04 < 0000000000000000
    &data 0x0e05 < 0000000000000000
    &data 0x0e06 < 0000000000000000
    &data 0x0e07 < 0000000000000000

    &data 0x0e08 < 0000000000000000
    &data 0x0e09 < 0000001111000000
    &data 0x0e0a < 0000110000110000
    &data 0x0e0b < 0011000000001100
    &data 0x0e0c < 0011000000001100
    &data 0x0e0d < 0000110000110000
    &data 0x0e0e < 0000001111000000
    &data 0x0e0f < 0000000000000000

    &data 0x0e10 < 0000000000000000
    &data 0x0e11 < 0000000011110000
    &data 0x0e12 < 0000001100110000
    &data 0x0e13 < 0000110000110000
    &data 0x0e14 < 0000000000110000
    &data 0x0e15 < 0000000000110000
    &data 0x0e16 < 0000000000110000
    &data 0x0e17 < 0000000000000000

    &data 0x0e18 < 0000000000000000
    &data 0x0e19 < 0000001111110000
    &data 0x0e1a < 0000110000001100
    &data 0x0e1b < 0000000000001100
    &data 0x0e1c < 0000000000110000
    &data 0x0e1d < 0000000011000000
    &data 0x0e1e < 0000111111111100
    &data 0x0e1f < 0000000000000000

    &data 0x0e20 < 0000000000000000
    &data 0x0e21 < 0000111111110000
    &data 0x0e22 < 0000000000001100
    &data 0x0e23 < 0000000000001100
    &data 0x0e24 < 0000001111110000
    &data 0x0e25 < 0000000000001100
    &data 0x0e26 < 0000111111110000
    &data 0x0e27 < 0000000000000000

    &data 0x0e28 < 0000000000000000
    &data 0x0e29 < 0000001100000000
    &data 0x0e2a < 0000110000000000
    &data 0x0e2b < 0011000011000000
    &data 0x0e2c < 0011111111110000
    &data 0x0e2d < 0000000011000000
    &data 0x0e2e < 0000000011000000
    &data 0x0e2f < 0000000000000000

    &data 0x0e30 < 0000000000000000
    &data 0x0e31 < 0011111111111100
    &data 0x0e32 < 0011000000000000
    &data 0x0e33 < 0011000000000000
    &data 0x0e34 < 0000111111111100
    &data 0x0e35 < 0000000000001100
    &data 0x0e36 < 0000111111110000
    &data 0x0e37 < 0000000000000000

    &data 0x0e38 < 0000000000000000
    &data 0x0e39 < 0000001111111100
    &data 0x0e3a < 0000110000000000
    &data 0x0e3b < 0011000000000000
    &data 0x0e3c < 0011111111110000
    &data 0x0e3d < 0011000000001100
    &data 0x0e3e < 0000111111110000
    &data 0x0e3f < 0000000000000000

    &data 0x0e40 < 0000000000000000
    &data 0x0e41 < 0011111111111100
    &data 0x0e42 < 0000000000001100
    &data 0x0e43 < 0000000000110000
    &data 0x0e44 < 0000000000110000
    &data 0x0e45 < 0000000011000000
    &data 0x0e46 < 0000001100000000
    &data 0x0e47 < 0000000000000000

    &data 0x0e48 < 0000000000000000
    &data 0x0e49 < 0000111111110000
    &data 0x0e4a < 0011000000001100
    &data 0x0e4b < 0011000000001100
    &data 0x0e4c < 0000111111110000
    &data 0x0e4d < 0011000000001100
    &data 0x0e4e < 0000111111110000
    &data 0x0e4f < 0000000000000000

    &data 0x0e50 < 0000000000000000
    &data 0x0e51 < 0000111111110000
    &data 0x0e52 < 0011000000001100
    &data 0x0e53 < 0011000000001100
    &data 0x0e54 < 0000111111111100
    &data 0x0e55 < 0000000000001100
    &data 0x0e56 < 0000111111110000
    &data 0x0e57 < 0000000000000000

    &data 0x0e58 < 0000000000000000
    &data 0x0e59 < 0000000000000000
    &data 0x0e5a < 0000000000000000
    &data 0x0e5b < 0000000000000000
    &data 0x0e5c < 0000111111110000
    &data 0x0e5d < 0000000000000000
    &data 0x0e5e < 0000000000000000
    &data 0x0e5f < 0000000000000000


    &data 0x0ef0 < 0000000110000000
    &data 0x0ef1 < 0000111111110000
    &data 0x0ef2 < 0011000110001100
    &data 0x0ef3 < 0011000000000000
    &data 0x0ef4 < 0000111111110000
    &data 0x0ef5 < 0000000000001100
    &data 0x0ef6 < 0000111111110000
    &data 0x0ef7 < 0000001100000000

    &data 0x0f00 < 0000000000000000
    &data 0x0f01 < 0000111100000000
    &data 0x0f02 < 0011000011110000
    &data 0x0f03 < 0011000000001100
    &data 0x0f04 < 0011111111111100
    &data 0x0f05 < 0011000000001100
    &data 0x0f06 < 0011000000001100
    &data 0x0f07 < 0000000000000000

    &data 0x0f08 < 0000000000000000
    &data 0x0f09 < 0011111111110000
    &data 0x0f0a < 0011000000001100
    &data 0x0f0b < 0011000000001100
    &data 0x0f0c < 0011111111110000
    &data 0x0f0d < 0011000000001100
    &data 0x0f0e < 0011111111110000
    &data 0x0f0f < 0000000000000000

    &data 0x0f10 < 0000000000000000
    &data 0x0f11 < 0000001111110000
    &data 0x0f12 < 0000110000001100
    &data 0x0f13 < 0011000000000000
    &data 0x0f14 < 0011000000000000
    &data 0x0f15 < 0000110000001100
    &data 0x0f16 < 0000001111110000
    &data 0x0f17 < 0000000000000000

    &data 0x0f18 < 0000000000000000
    &data 0x0f19 < 0011111111000000
    &data 0x0f1a < 0011000000110000
    &data 0x0f1b < 0011000000001100
    &data 0x0f1c < 0011000000001100
    &data 0x0f1d < 0011000000110000
    &data 0x0f1e < 0011111111000000
    &data 0x0f1f < 0000000000000000

    &data 0x0f20 < 0000000000000000
    &data 0x0f21 < 0011111111111100
    &data 0x0f22 < 0011000000000000
    &data 0x0f23 < 0011000000000000
    &data 0x0f24 < 0011111111000000
    &data 0x0f25 < 0011000000000000
    &data 0x0f26 < 0011000000000000
    &data 0x0f27 < 0000000000000000

    &data 0x0f28 < 0000000000000000
    &data 0x0f29 < 0000001111111100
    &data 0x0f2a < 0000110000000000
    &data 0x0f2b < 0011000000000000
    &data 0x0f2c < 0011000000111100
    &data 0x0f2d < 0000110000001100
    &data 0x0f2e < 0000001111110000
    &data 0x0f2f < 0000000000000000

    &data 0x0f30 < 0000000000000000
    &data 0x0f31 < 0011000000001100
    &data 0x0f32 < 0011000000001100
    &data 0x0f33 < 0011000000001100
    &data 0x0f34 < 0011111111111100
    &data 0x0f35 < 0011000000001100
    &data 0x0f36 < 0011000000001100
    &data 0x0f37 < 0000000000000000

    &data 0x0f38 < 0000000000000000
    &data 0x0f39 < 0000001111110000
    &data 0x0f3a < 0000000011000000
    &data 0x0f3b < 0000000011000000
    &data 0x0f3c < 0000000011000000
    &data 0x0f3d < 0000000011000000
    &data 0x0f3e < 0000001111110000
    &data 0x0f3f < 0000000000000000

    &data 0x0f40 < 0000000000000000
    &data 0x0f41 < 0011111111110000
    &data 0x0f42 < 0000000011000000
    &data 0x0f43 < 0000000011000000
    &data 0x0f44 < 0000000011000000
    &data 0x0f45 < 0011000011000000
    &data 0x0f46 < 0000111100000000
    &data 0x0f47 < 0000000000000000

    &data 0x0f48 < 0000000000000000
    &data 0x0f49 < 0011111111110000
    &data 0x0f4a < 0000000011000000
    &data 0x0f4b < 0000000011000000
    &data 0x0f4c < 0000000011000000
    &data 0x0f4d < 0011000011000000
    &data 0x0f4e < 0000111100000000
    &data 0x0f4f < 0000000000000000

    &data 0x0f50 < 0000000000000000
    &data 0x0f51 < 0011000011110000
    &data 0x0f52 < 0011001100000000
    &data 0x0f53 < 0011110000000000
    &data 0x0f54 < 0011001100000000
    &data 0x0f55 < 0011000011000000
    &data 0x0f56 < 0011000000110000
    &data 0x0f57 < 0000000000000000

    &data 0x0f58 < 0000000000000000
    &data 0x0f59 < 0011000000000000
    &data 0x0f5a < 0011000000000000
    &data 0x0f5b < 0011000000000000
    &data 0x0f5c < 0011000000000000
    &data 0x0f5d < 0011000000000000
    &data 0x0f5e < 0011111111110000
    &data 0x0f5f < 0000000000000000

    &data 0x0f60 < 0000000000000000
    &data 0x0f61 < 0000110011110000
    &data 0x0f62 < 0011001100001100
    &data 0x0f63 < 0011001100001100
    &data 0x0f64 < 0011001100001100
    &data 0x0f65 < 0011000000001100
    &data 0x0f66 < 0011000000001100
    &data 0x0f67 < 0000000000000000

    &data 0x0f68 < 0000000000000000
    &data 0x0f69 < 0011000000001100
    &data 0x0f6a < 0011110000001100
    &data 0x0f6b < 0011001100001100
    &data 0x0f6c < 0011000011001100
    &data 0x0f6d < 0011000000111100
    &data 0x0f6e < 0011000000001100
    &data 0x0f6f < 0000000000000000

    &data 0x0f70 < 0000000000000000
    &data 0x0f71 < 0000111111110000
    &data 0x0f72 < 0011000000001100
    &data 0x0f73 < 0011000000001100
    &data 0x0f74 < 0011000000001100
    &data 0x0f75 < 0011000000001100
    &data 0x0f76 < 0000111111110000
    &data 0x0f77 < 0000000000000000

    &data 0x0f78 < 0000000000000000
    &data 0x0f79 < 0011111111110000
    &data 0x0f7a < 0011000000001100
    &data 0x0f7b < 0011000000001100
    &data 0x0f7c < 0011111111110000
    &data 0x0f7d < 0011000000000000
    &data 0x0f7e < 0011000000000000
    &data 0x0f7f < 0000000000000000

    &data 0x0f80 < 0000000000000000
    &data 0x0f81 < 0000111111110000
    &data 0x0f82 < 0011000000001100
    &data 0x0f83 < 0011000000001100
    &data 0x0f84 < 0011000000001100
    &data 0x0f85 < 0011000011001100
    &data 0x0f86 < 0000111111110000
    &data 0x0f87 < 0000000000001100

     &data 0x0f88 < 0000000000000000
     &data 0x0f89 < 0011111111000000
     &data 0x0f8a < 0011000000110000
     &data 0x0f8b < 0011000011000000
     &data 0x0f8c < 0011111100000000
     &data 0x0f8d < 0011000011000000
     &data 0x0f8e < 0011000000110000
     &data 0x0f8f < 0000000000000000

     &data 0x0f90 < 0000000000000000
     &data 0x0f91 < 0000111111000000
     &data 0x0f92 < 0011000000000000
     &data 0x0f93 < 0011000000000000
     &data 0x0f94 < 0000111111000000
     &data 0x0f95 < 0000000000110000
     &data 0x0f96 < 0000111111000000
     &data 0x0f97 < 0000000000000000

     &data 0x0f98 < 0000000000000000
     &data 0x0f99 < 0011111111111100
     &data 0x0f9a < 0000001100000000
     &data 0x0f9b < 0000001100000000
     &data 0x0f9c < 0000001100000000
     &data 0x0f9d < 0000001100000000
     &data 0x0f9e < 0000001100000000
     &data 0x0f9f < 0000000000000000

    &data 0x0fa0 < 0000000000000000
    &data 0x0fa1 < 0011000000001100
    &data 0x0fa2 < 0011000000001100
    &data 0x0fa3 < 0011000000001100
    &data 0x0fa4 < 0011000000001100
    &data 0x0fa5 < 0011000000001100
    &data 0x0fa6 < 0000111111110000
    &data 0x0fa7 < 0000000000000000

    &data 0x0fa8 < 0000000000000000
    &data 0x0fa9 < 0011000000001100
    &data 0x0faa < 0011000000001100
    &data 0x0fab < 0011000000110000
    &data 0x0fac < 0000110000110000
    &data 0x0fad < 0000110000110000
    &data 0x0fae < 0000001111000000
    &data 0x0faf < 0000000000000000

    &data 0x0fb0 < 0000000000000000
    &data 0x0fb1 < 0011000000001100
    &data 0x0fb2 < 0011000000001100
    &data 0x0fb3 < 0011000011001100
    &data 0x0fb4 < 0011000011001100
    &data 0x0fb5 < 0011000011001100
    &data 0x0fb6 < 0000111100110000
    &data 0x0fb7 < 0000000000000000

    &data 0x0fb8 < 0000000000000000
    &data 0x0fb9 < 0011000000001100
    &data 0x0fba < 0011000000001100
    &data 0x0fbb < 0000110000110000
    &data 0x0fbc < 0000001111000000
    &data 0x0fbd < 0000110000110000
    &data 0x0fbe < 0011000000001100
    &data 0x0fbf < 0000000000000000

    &data 0x0fc0 < 0000000000000000
    &data 0x0fc1 < 0011000000001100
    &data 0x0fc2 < 0011000000001100
    &data 0x0fc3 < 0000110000110000
    &data 0x0fc4 < 0000001111000000
    &data 0x0fc5 < 0000001111000000
    &data 0x0fc6 < 0000001111000000
    &data 0x0fc7 < 0000000000000000

    &data 0x0fc8 < 0000000000000000
    &data 0x0fc9 < 0011111111111100
    &data 0x0fca < 0000000000001100
    &data 0x0fcb < 0000000000110000
    &data 0x0fcc < 0000000011000000
    &data 0x0fcd < 0000001100000000
    &data 0x0fce < 0011111111111100
    &data 0x0fcf < 0000000000000000

    &data 0x0fd0 < 0000000000000000 // 3a
    &data 0x0fd1 < 0000000000000000
    &data 0x0fd2 < 0000000000000000
    &data 0x0fd3 < 0000000000000000
    &data 0x0fd4 < 0000000000000000
    &data 0x0fd5 < 0000000000000000
    &data 0x0fd6 < 0000000110000000
    &data 0x0fd7 < 0000000000000000

    &data 0x0fd8 < 0000000000000000 // 3b
    &data 0x0fd9 < 0000000000000000
    &data 0x0fda < 0000000000000000
    &data 0x0fdb < 0000000000000000
    &data 0x0fdc < 0000000000000000
    &data 0x0fdd < 0000000000000000
    &data 0x0fde < 0000000110000000
    &data 0x0fdf < 0000000001100000

    &data 0x0fe0 < 0000000000000000 // 3c
    &data 0x0fe1 < 0000000000000000
    &data 0x0fe2 < 0000000110000000
    &data 0x0fe3 < 0000000000000000
    &data 0x0fe4 < 0000000000000000
    &data 0x0fe5 < 0000000000000000
    &data 0x0fe6 < 0000000110000000
    &data 0x0fe7 < 0000000000000000

    &data 0x0fe8 < 0000000000000000 // 3d
    &data 0x0fe9 < 0000000000000000
    &data 0x0fea < 0000000110000000
    &data 0x0feb < 0000000000000000
    &data 0x0fec < 0000000000000000
    &data 0x0fed < 0000000000000000
    &data 0x0fee < 0000000110000000
    &data 0x0fef < 0000000001100000

    &data 0x0ff0 < 0000000000000000 // 3e
    &data 0x0ff1 < 0000111111110000
    &data 0x0ff2 < 0011110000000000
    &data 0x0ff3 < 0011111111110000
    &data 0x0ff4 < 0011110000000000
    &data 0x0ff5 < 0011111111110000
    &data 0x0ff6 < 0011000000000000
    &data 0x0ff7 < 0000000000000000