module Example exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)


import Json.Decode as Decode
import Outline exposing (..)


suite : Test
suite =
  describe "Data"
  [ describe "newOutline" 
    [ test "creates an empty outline" <|
      \_ ->
        let
          outline = newOutline []
          
        in
          Expect.equal outline (Outline.RootNode [])
      
    , test "creates outline with provided contents" <|
      \_ ->
        let
          list = ["One", "Two", "Three"]
          (RootNode children) = newOutline list
          
        in
          case (List.head children) of
            Nothing ->
              Expect.true "Outline should have children" False
              
            Just (ChildNode firstChild) ->
              Expect.equal firstChild.text <| Maybe.withDefault "" (List.head list)
    ]
    
  , describe "decodeOutline"
    [ test "properly decodes an outline" <|
      \_ ->
        let 
          outline =
            """
              {
                "children": [
                  {
                    "text": "One",
                    "children": []
                  }
                ]
              }
            """
            
          decodedOutline =
            Decode.decodeString
              Outline.outlineDecoder outline
            
        in
          Expect.equal decodedOutline
            (Ok <| newOutline ["One"])
          
    ]
  ]
