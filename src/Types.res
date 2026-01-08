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

// CI Pipeline input types

@spice
type pipelineListInput = {
  repo?: string,
  status?: string,
  ref?: string,
  per_page?: int,
  page?: int,
}

@spice
type pipelineViewInput = {
  pipeline_id: int,
  repo?: string,
}

@spice
type pipelineCreateInput = {
  repo?: string,
  ref?: string,
  variables?: string,
}

@spice
type pipelineCancelInput = {
  pipeline_id: int,
  repo?: string,
}

@spice
type pipelineRetryInput = {
  pipeline_id: int,
  repo?: string,
}

@spice
type jobListInput = {
  pipeline_id: int,
  repo?: string,
}

@spice
type jobViewInput = {
  job_id: int,
  repo?: string,
}

@spice
type jobRetryInput = {
  job_id: int,
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
  | PipelineList
  | PipelineView
  | PipelineCreate
  | PipelineCancel
  | PipelineRetry
  | JobList
  | JobView
  | JobRetry

let toolNameFromString = (name: string): option<toolName> => {
  switch name {
  | "issue_list" => IssueList->Some
  | "issue_view" => IssueView->Some
  | "issue_create" => IssueCreate->Some
  | "issue_update" => IssueUpdate->Some
  | "issue_close" => IssueClose->Some
  | "issue_reopen" => IssueReopen->Some
  | "issue_note" => IssueNote->Some
  | "pipeline_list" => PipelineList->Some
  | "pipeline_view" => PipelineView->Some
  | "pipeline_create" => PipelineCreate->Some
  | "pipeline_cancel" => PipelineCancel->Some
  | "pipeline_retry" => PipelineRetry->Some
  | "job_list" => JobList->Some
  | "job_view" => JobView->Some
  | "job_retry" => JobRetry->Some
  | _ => None
  }
}
