module Quote exposing (..)

import Html exposing (Html)
import Html.Attributes exposing (class)
import List.Extra as List
import Random
import ElmEscapeHtml exposing (unescape)


type alias Quote =
    { name : String
    , quote : String
    }


type alias Model =
    Quote


quotes : String -> List Quote
quotes locale =
    case locale of
        "nl" ->
            [ Quote "Bart van de Cloot, Wok a Way" "Dankzij GratWiFi&reg; genieten al onze klanten nu van gratis internet."
            , Quote "Harry Curvers, Camping 't Soete Dal" "Ongelooflijk hoe goed GratWiFi&reg; werkt, en als er eens een probleem is, wordt dit zo verholpen."
            ]

        "fr" ->
            [ Quote "Bart van de Cloot, Wok a Way" "Grace à GratWiFi® tous nos clients peuvent désormais profiter de l'internet sans fil."
            , Quote "Harry Curves, Camping 't Soete Dal" "Incroyable à quel point GratWiFi® fonctionne, et s'il ya un problème, il est fixé immédiatement."
            ]

        "en" ->
            [ Quote "Bart van de Cloot" "Thanks to GratWiFi® all our customers are now able to enjoy free wireless internet."
            , Quote "Harry Curves, Camping 't Soete Dal" "Unbelievable how well GratWiFi® works, and if there is an issue, it is fixed immediately."
            ]

        "de" ->
            [ Quote "Bart van de Cloot" "Durch GratWiFi® sind all unsere Kunden nun in der Lage, kostenfreiem Internet zu geniessen."
            , Quote "Harry Curves, Camping 't Soete Dal" "Unglaublich, wie gut GratWiFi® arbeitet, und wenn es ein Problem gibt, wird es sofort behoben."
            ]

        _ ->
            []


quote : String -> Int -> Quote
quote locale index =
    List.getAt index (quotes locale)
        |> Maybe.withDefault (Quote "Gaston" "TESTKE")


view : Model -> Html Msg
view model =
    Html.div [ class "quote" ]
        [ Html.blockquote []
            [ Html.p []
                [ Html.text (unescape model.quote)
                ]
            , Html.p [ class "quotee" ]
                [ Html.text (unescape model.name)
                ]
            ]
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )


type Msg
    = NoOp


type alias Config =
    { seed : Int
    , locale : String
    }


init : Config -> ( Model, Cmd Msg )
init config =
    let
        locale =
            config.locale

        seed0 =
            Random.initialSeed config.seed

        local_quotes =
            quotes locale

        upper_limit =
            (List.length local_quotes) - 1

        ( index, _ ) =
            Random.step (Random.int 0 upper_limit) seed0
    in
        ( quote locale index, Cmd.none )


main : Program Config Model Msg
main =
    Html.programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = always Sub.none
        }