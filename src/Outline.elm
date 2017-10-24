module Outline exposing 
  ( RootNode(..)
  , ChildNode(..)
  , Msg(..)
  , outlineDecoder
  , newOutline
  , update
  , view
  )
  
  
{-|

# Elm Outline

An outline editor written in Elm.

-}
  
  
import Char exposing (KeyCode)
import Json.Decode as Decode
import Html exposing (Html, ul, li, text)
import Html.Attributes exposing (class, contenteditable)
import Html.Events as Events
import Json.Decode as Decode


type Msg =
  IndentMsg
  | OutdentMsg
  

type alias Key =
  { keyCode: Char.KeyCode
  , name: String
  }  


tab : Key
tab =
  { keyCode = 9
  , name = "Tab"
  }


{-| The root data type for an outline. All outlines start at a RootNode and may
grow recursively through any number of levels of nested ChildNodes.

-}
type RootNode = RootNode (List ChildNode)


type ChildNode = ChildNode NodeContents
  

type alias NodeContents = 
  { text : String
  , children : List ChildNode
  }


{-| Create a new, single-level outline pre-populated with data.

-}
newOutline : List String -> RootNode
newOutline initialItems =
  let mapFn str = 
    ChildNode { text = str, children = [] }
    
  in
    RootNode (List.map mapFn initialItems)
    
    
{-| Decode an outline from JSON format. The expected format for an outline is as
follows:

{
  children: [
    {
      text: "One"
    },
    {
      text: "Two",
      children: [
        text: "Two.One"
      ]`
    }
  ]
}

-}
outlineDecoder : Decode.Decoder RootNode
outlineDecoder =
  Decode.map RootNode
    (Decode.field "children" (Decode.list (Decode.map ChildNode contentsDecoder)))
  
  
{-| Decode the contents of a node. This decoder uses lazy decoding due to the
recursive nature of the outline data structure.

-}
contentsDecoder : Decode.Decoder NodeContents
contentsDecoder =
  Decode.map2 NodeContents
    (Decode.field "text" Decode.string)
    (Decode.field "children" (Decode.list (Decode.map ChildNode (Decode.lazy (\_-> contentsDecoder)))))


update : Msg -> RootNode -> RootNode
update msg root =
  root
    

{-| Render the outline view. 

This function will render an entire outline, if provided with a RootNode, or any
subset of an outline, if provided with a ChildNode.

-}
view : RootNode -> Html msg
view (RootNode children) =
  ul [ class "elm-outline" ]
    <| List.map nodeView children
  

{-| Render a single item in the outline.

-}
nodeView : ChildNode -> Html msg
nodeView (ChildNode contents) =
  li [ class "elm-outline-item", onKeyDown tab.keyCode ]
  [ text contents.text
  ]


onKeyDown : KeyCode -> (String -> msg) -> Attribute msg
onKeyDown keyCode tagger =
    let
      isKey code = 
        if code == keyCode then
          Decode.succeed ""
        else
          Decode.fail ""
                
      decode =
        Decode.andThen isKey Events.keyCode

    in
      on "keydown" <| Decode.map2 (\key value -> tagger value) decode targetValue