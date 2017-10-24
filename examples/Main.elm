module Main exposing
  (..)
  
  
import Outline exposing (RootNode)
import Html exposing (Html, beginnerProgram)


type Msg =
  OutlineMsg Outline.Msg


type alias Model =
  { outline : RootNode
  }
  
  
initialModel : Model
initialModel =
  { outline = Outline.newOutline ["One", "Two", "Three"]
  }


update : Msg -> Model -> Model
update msg model =
  case msg of
    OutlineMsg outlineMsg ->
      { model | outline = Outline.update outlineMsg model.outline }

  
view : Model -> Html msg
view model =
  Outline.view model.outline 


main : Program Never Model Msg  
main = 
  beginnerProgram
    { model = initialModel
    , view = view
    , update = update
    }