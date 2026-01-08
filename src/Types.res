// GitLab issue tool input types

@spice
type issueListInput = {
  repo?: string,
  state?: string,
  labels?: string,
  assignee?: string,
  author?: string,
  search?: string,
  per_page?: int,
  page?: int,
}

@spice
type issueViewInput = {
  issue_id: int,
  repo?: string,
  comments?: bool,
}

@spice
type issueCreateInput = {
  title: string,
  description?: string,
  labels?: string,
  assignees?: string,
  milestone?: string,
  confidential?: bool,
  repo?: string,
}

@spice
type issueUpdateInput = {
  issue_id: int,
  title?: string,
  description?: string,
  labels?: string,
  unlabel?: string,
  assignees?: string,
  unassign?: bool,
  milestone?: string,
  confidential?: bool,
  repo?: string,
}

@spice
type issueCloseInput = {
  issue_id: int,
  repo?: string,
}

@spice
type issueReopenInput = {
  issue_id: int,
  repo?: string,
}

@spice
type issueNoteInput = {
  issue_id: int,
  message: string,
  repo?: string,
}

// Tool name enum
type toolName =
  | IssueList
  | IssueView
  | IssueCreate
  | IssueUpdate
  | IssueClose
  | IssueReopen
  | IssueNote

let toolNameFromString = (name: string): option<toolName> => {
  switch name {
  | "issue_list" => IssueList->Some
  | "issue_view" => IssueView->Some
  | "issue_create" => IssueCreate->Some
  | "issue_update" => IssueUpdate->Some
  | "issue_close" => IssueClose->Some
  | "issue_reopen" => IssueReopen->Some
  | "issue_note" => IssueNote->Some
  | _ => None
  }
}
