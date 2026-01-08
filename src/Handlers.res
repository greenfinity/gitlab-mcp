// Tool handlers - execute glab commands based on tool input

let addArg = (args: array<string>, flag: string, value: option<string>) => {
  switch value {
  | Some(v) => args->Array.concat([flag, v])
  | None => args
  }
}

let addFlag = (args: array<string>, flag: string, value: option<bool>) => {
  switch value {
  | Some(true) => args->Array.concat([flag])
  | _ => args
  }
}

let addIntArg = (args: array<string>, flag: string, value: option<int>) => {
  switch value {
  | Some(v) => args->Array.concat([flag, v->Int.toString])
  | None => args
  }
}

let handleIssueList = async (input: Types.issueListInput): McpSdk.callToolResponse => {
  let args = ["issue", "list"]
    ->addArg("-R", input.repo)
    ->addArg("--state", input.state)
    ->addArg("--label", input.labels)
    ->addArg("--assignee", input.assignee)
    ->addArg("--author", input.author)
    ->addArg("--search", input.search)
    ->addIntArg("--per-page", input.per_page)
    ->addIntArg("--page", input.page)

  switch await Glab.exec(args) {
  | Ok(output) => McpSdk.makeSuccessResponse(output)
  | Error(err) => McpSdk.makeErrorResponse(`Error: ${err}`)
  }
}

let handleIssueView = async (input: Types.issueViewInput): McpSdk.callToolResponse => {
  let args = ["issue", "view", input.issue_id->Int.toString]
    ->addArg("-R", input.repo)
    ->addFlag("--comments", input.comments)

  switch await Glab.exec(args) {
  | Ok(output) => McpSdk.makeSuccessResponse(output)
  | Error(err) => McpSdk.makeErrorResponse(`Error: ${err}`)
  }
}

let handleIssueCreate = async (input: Types.issueCreateInput): McpSdk.callToolResponse => {
  let args = ["issue", "create", "--title", input.title]
    ->addArg("--description", input.description)
    ->addArg("--label", input.labels)
    ->addArg("--assignee", input.assignees)
    ->addArg("--milestone", input.milestone)
    ->addFlag("--confidential", input.confidential)
    ->addArg("-R", input.repo)
    ->Array.concat(["--yes"]) // Skip confirmation prompts

  switch await Glab.exec(args) {
  | Ok(output) => McpSdk.makeSuccessResponse(output)
  | Error(err) => McpSdk.makeErrorResponse(`Error: ${err}`)
  }
}

let handleIssueUpdate = async (input: Types.issueUpdateInput): McpSdk.callToolResponse => {
  let args = ["issue", "update", input.issue_id->Int.toString]
    ->addArg("--title", input.title)
    ->addArg("--description", input.description)
    ->addArg("--label", input.labels)
    ->addArg("--unlabel", input.unlabel)
    ->addArg("--assignee", input.assignees)
    ->addFlag("--unassign", input.unassign)
    ->addArg("--milestone", input.milestone)
    ->addFlag("--confidential", input.confidential)
    ->addArg("-R", input.repo)

  switch await Glab.exec(args) {
  | Ok(output) => McpSdk.makeSuccessResponse(output)
  | Error(err) => McpSdk.makeErrorResponse(`Error: ${err}`)
  }
}

let handleIssueClose = async (input: Types.issueCloseInput): McpSdk.callToolResponse => {
  let args = ["issue", "close", input.issue_id->Int.toString]
    ->addArg("-R", input.repo)

  switch await Glab.exec(args) {
  | Ok(output) => McpSdk.makeSuccessResponse(output)
  | Error(err) => McpSdk.makeErrorResponse(`Error: ${err}`)
  }
}

let handleIssueReopen = async (input: Types.issueReopenInput): McpSdk.callToolResponse => {
  let args = ["issue", "reopen", input.issue_id->Int.toString]
    ->addArg("-R", input.repo)

  switch await Glab.exec(args) {
  | Ok(output) => McpSdk.makeSuccessResponse(output)
  | Error(err) => McpSdk.makeErrorResponse(`Error: ${err}`)
  }
}

let handleIssueNote = async (input: Types.issueNoteInput): McpSdk.callToolResponse => {
  let args = ["issue", "note", input.issue_id->Int.toString, "--message", input.message]
    ->addArg("-R", input.repo)

  switch await Glab.exec(args) {
  | Ok(output) => McpSdk.makeSuccessResponse(output)
  | Error(err) => McpSdk.makeErrorResponse(`Error: ${err}`)
  }
}

let handleTool = async (
  toolName: Types.toolName,
  args: option<JSON.t>,
): McpSdk.callToolResponse => {
  let jsonArgs = args->Option.getOr(JSON.Encode.object(Dict.make()))

  switch toolName {
  | IssueList =>
    switch jsonArgs->Types.issueListInput_decode {
    | Ok(input) => await handleIssueList(input)
    | Error(err) => McpSdk.makeErrorResponse(`Invalid arguments: ${err.message}`)
    }

  | IssueView =>
    switch jsonArgs->Types.issueViewInput_decode {
    | Ok(input) => await handleIssueView(input)
    | Error(err) => McpSdk.makeErrorResponse(`Invalid arguments: ${err.message}`)
    }

  | IssueCreate =>
    switch jsonArgs->Types.issueCreateInput_decode {
    | Ok(input) => await handleIssueCreate(input)
    | Error(err) => McpSdk.makeErrorResponse(`Invalid arguments: ${err.message}`)
    }

  | IssueUpdate =>
    switch jsonArgs->Types.issueUpdateInput_decode {
    | Ok(input) => await handleIssueUpdate(input)
    | Error(err) => McpSdk.makeErrorResponse(`Invalid arguments: ${err.message}`)
    }

  | IssueClose =>
    switch jsonArgs->Types.issueCloseInput_decode {
    | Ok(input) => await handleIssueClose(input)
    | Error(err) => McpSdk.makeErrorResponse(`Invalid arguments: ${err.message}`)
    }

  | IssueReopen =>
    switch jsonArgs->Types.issueReopenInput_decode {
    | Ok(input) => await handleIssueReopen(input)
    | Error(err) => McpSdk.makeErrorResponse(`Invalid arguments: ${err.message}`)
    }

  | IssueNote =>
    switch jsonArgs->Types.issueNoteInput_decode {
    | Ok(input) => await handleIssueNote(input)
    | Error(err) => McpSdk.makeErrorResponse(`Invalid arguments: ${err.message}`)
    }
  }
}
