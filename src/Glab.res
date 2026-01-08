// Execute glab CLI commands

type childProcess
type spawnOptions = {env: Dict.t<string>}
type buffer

@module("child_process")
external spawn: (string, array<string>, spawnOptions) => childProcess = "spawn"

@send external onClose: (childProcess, @as("close") _, int => unit) => unit = "on"
@send external onError: (childProcess, @as("error") _, JsExn.t => unit) => unit = "on"

@get external stdout: childProcess => 'a = "stdout"
@get external stderr: childProcess => 'a = "stderr"

@send external on: ('a, string, 'b => unit) => unit = "on"
@send external bufferToString: buffer => string = "toString"

@val external processEnv: Dict.t<string> = "process.env"

let exec = (args: array<string>): promise<result<string, string>> => {
  Promise.make((resolve, _reject) => {
    let proc = spawn("glab", args, {env: processEnv})
    let stdoutRef = ref("")
    let stderrRef = ref("")

    proc->stdout->on("data", (data: buffer) => {
      stdoutRef := stdoutRef.contents ++ data->bufferToString
    })

    proc->stderr->on("data", (data: buffer) => {
      stderrRef := stderrRef.contents ++ data->bufferToString
    })

    proc->onClose(code => {
      if code === 0 {
        resolve(Ok(stdoutRef.contents))
      } else {
        let errorMsg = if stderrRef.contents !== "" {
          stderrRef.contents
        } else {
          `glab exited with code ${code->Int.toString}`
        }
        resolve(Error(errorMsg))
      }
    })

    proc->onError(err => {
      resolve(Error(err->JsExn.message->Option.getOr("Unknown error")))
    })
  })
}
