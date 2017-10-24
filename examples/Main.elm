module Main exposing
  (..)
  
  
import Outline exposing (RootNode)
import Html exposing (Html)


type Msg =
  OutlineMsg Outline.Msg


type alias Model =
  { outline : RootNode
  }
  
  
initialModel : Model
initialModel =
  { outline : Outline.newOutline ["One", "Two", "Three"]
  }
  
  
view : Model -> Html
view model =
  Outline.view model.outline 

  
main : Program Value Model Msg
main = 
  Program
    { init = init
    , view = view
    , update = update
    }