/- Utilities for interacting with LLMlean API endpoints.

Acknowledgements:
  Adapted from LeanCopilot's External.lean
    https://github.com/lean-dojo/LeanCopilot/blob/
    dd2c0c2b31fef6545654acfc82960aa59ed79e5a/
    LeanCopilot/Models/External.lean
-/
import Lean
open Lean

namespace LLMlean

structure API where
  model : String
  baseUrl : String
  key : String
  tacticGenerationEndpoint : String := "/"
deriving Inhabited, Repr

structure TacticGenerationRequest where
  model : String
  key : String
  tactic_state : String
  context : String
  «prefix» : String
deriving ToJson

structure TacticGenerationResponse where
  suggestions : Array String
deriving FromJson


def post {α β : Type} [ToJson α] [FromJson β] (req : α) (url : String) : IO β := do
  let out ← IO.Process.output {
    cmd := "curl"
    args := #[
      "-X", "POST", url,
      "-H", "accept: application/json",
      "-H", "Content-Type: application/json",
      "-d", (toJson req).pretty UInt64.size]
  }
  if out.exitCode != 0 then
     throw $ IO.userError s!"Request failed. Ensure that the server is up at `{url}`, or set LLMLEAN_URL to the proper URL."
  let some json := Json.parse out.stdout |>.toOption
    | throw $ IO.userError "Failed to parse response"
  let some res := (fromJson? json : Except String β) |>.toOption
    | throw $ IO.userError "Failed to parse response"
  return res


def API.tacticGeneration
  (api : API) (tacticState : String) (context : String)
  («prefix» : String) : IO $ Array (String × Float) := do
  let url := s!"{api.baseUrl}{api.tacticGenerationEndpoint}"
  let req : TacticGenerationRequest := {
    model := api.model,
    key := api.key,
    tactic_state := tacticState,
    context := context,
    «prefix» := «prefix»
  }
  let res : TacticGenerationResponse ← post req url
  return res.suggestions.map fun x => (x, 0.0)


end LLMlean
