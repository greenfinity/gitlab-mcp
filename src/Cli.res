%%raw(`#!/usr/bin/env node`)

// CLI entry point for GitLab MCP server

@val external exit: int => unit = "process.exit"

let main = async () => {
  await Server.runServer()
}

main()->Promise.catch(error => {
  Console.error2("Fatal error:", error)
  exit(1)
  Promise.resolve()
})->ignore
