// Tool definitions for GitLab issue management

let issueListTool: McpSdk.tool = {
  name: "issue_list",
  description: "List project issues. Use --all for all issues, or filter by state, labels, assignee, etc.",
  inputSchema: McpSdk.makeInputSchema(
    ~properties=Dict.fromArray([
      ("repo", McpSdk.makeProperty(~type_="string", ~description="Repository in OWNER/REPO format (optional, uses current repo if not specified)")),
      ("state", McpSdk.makeEnumProperty(~type_="string", ~description="Filter by issue state", ~enum=["opened", "closed", "all"])),
      ("labels", McpSdk.makeProperty(~type_="string", ~description="Comma-separated list of labels to filter by")),
      ("assignee", McpSdk.makeProperty(~type_="string", ~description="Filter by assignee username")),
      ("author", McpSdk.makeProperty(~type_="string", ~description="Filter by author username")),
      ("search", McpSdk.makeProperty(~type_="string", ~description="Search issues by title and description")),
      ("per_page", McpSdk.makeProperty(~type_="number", ~description="Number of issues per page (default 30)")),
      ("page", McpSdk.makeProperty(~type_="number", ~description="Page number")),
    ]),
  ),
}

let issueViewTool: McpSdk.tool = {
  name: "issue_view",
  description: "View details of a specific issue by ID",
  inputSchema: McpSdk.makeInputSchema(
    ~properties=Dict.fromArray([
      ("issue_id", McpSdk.makeProperty(~type_="number", ~description="The issue ID/number")),
      ("repo", McpSdk.makeProperty(~type_="string", ~description="Repository in OWNER/REPO format (optional)")),
      ("comments", McpSdk.makeProperty(~type_="boolean", ~description="Include comments in the output")),
    ]),
    ~required=["issue_id"],
  ),
}

let issueCreateTool: McpSdk.tool = {
  name: "issue_create",
  description: "Create a new issue",
  inputSchema: McpSdk.makeInputSchema(
    ~properties=Dict.fromArray([
      ("title", McpSdk.makeProperty(~type_="string", ~description="Issue title")),
      ("description", McpSdk.makeProperty(~type_="string", ~description="Issue description/body")),
      ("labels", McpSdk.makeProperty(~type_="string", ~description="Comma-separated list of labels")),
      ("assignees", McpSdk.makeProperty(~type_="string", ~description="Comma-separated list of assignee usernames")),
      ("milestone", McpSdk.makeProperty(~type_="string", ~description="Milestone title or ID")),
      ("confidential", McpSdk.makeProperty(~type_="boolean", ~description="Make the issue confidential")),
      ("repo", McpSdk.makeProperty(~type_="string", ~description="Repository in OWNER/REPO format (optional)")),
    ]),
    ~required=["title"],
  ),
}

let issueUpdateTool: McpSdk.tool = {
  name: "issue_update",
  description: "Update an existing issue",
  inputSchema: McpSdk.makeInputSchema(
    ~properties=Dict.fromArray([
      ("issue_id", McpSdk.makeProperty(~type_="number", ~description="The issue ID/number")),
      ("title", McpSdk.makeProperty(~type_="string", ~description="New issue title")),
      ("description", McpSdk.makeProperty(~type_="string", ~description="New issue description/body")),
      ("labels", McpSdk.makeProperty(~type_="string", ~description="Comma-separated list of labels to set")),
      ("unlabel", McpSdk.makeProperty(~type_="string", ~description="Comma-separated list of labels to remove")),
      ("assignees", McpSdk.makeProperty(~type_="string", ~description="Comma-separated list of assignee usernames")),
      ("unassign", McpSdk.makeProperty(~type_="boolean", ~description="Remove all assignees")),
      ("milestone", McpSdk.makeProperty(~type_="string", ~description="Milestone title or ID")),
      ("confidential", McpSdk.makeProperty(~type_="boolean", ~description="Make the issue confidential")),
      ("repo", McpSdk.makeProperty(~type_="string", ~description="Repository in OWNER/REPO format (optional)")),
    ]),
    ~required=["issue_id"],
  ),
}

let issueCloseTool: McpSdk.tool = {
  name: "issue_close",
  description: "Close an issue",
  inputSchema: McpSdk.makeInputSchema(
    ~properties=Dict.fromArray([
      ("issue_id", McpSdk.makeProperty(~type_="number", ~description="The issue ID/number")),
      ("repo", McpSdk.makeProperty(~type_="string", ~description="Repository in OWNER/REPO format (optional)")),
    ]),
    ~required=["issue_id"],
  ),
}

let issueReopenTool: McpSdk.tool = {
  name: "issue_reopen",
  description: "Reopen a closed issue",
  inputSchema: McpSdk.makeInputSchema(
    ~properties=Dict.fromArray([
      ("issue_id", McpSdk.makeProperty(~type_="number", ~description="The issue ID/number")),
      ("repo", McpSdk.makeProperty(~type_="string", ~description="Repository in OWNER/REPO format (optional)")),
    ]),
    ~required=["issue_id"],
  ),
}

let issueNoteTool: McpSdk.tool = {
  name: "issue_note",
  description: "Add a comment/note to an issue",
  inputSchema: McpSdk.makeInputSchema(
    ~properties=Dict.fromArray([
      ("issue_id", McpSdk.makeProperty(~type_="number", ~description="The issue ID/number")),
      ("message", McpSdk.makeProperty(~type_="string", ~description="The comment text")),
      ("repo", McpSdk.makeProperty(~type_="string", ~description="Repository in OWNER/REPO format (optional)")),
    ]),
    ~required=["issue_id", "message"],
  ),
}

// CI Pipeline tools

let pipelineListTool: McpSdk.tool = {
  name: "pipeline_list",
  description: "List CI/CD pipelines for a project. Filter by status or branch/ref.",
  inputSchema: McpSdk.makeInputSchema(
    ~properties=Dict.fromArray([
      ("repo", McpSdk.makeProperty(~type_="string", ~description="Repository in OWNER/REPO format (optional, uses current repo if not specified)")),
      ("status", McpSdk.makeEnumProperty(~type_="string", ~description="Filter by pipeline status", ~enum=["running", "pending", "success", "failed", "canceled", "skipped", "manual"])),
      ("ref", McpSdk.makeProperty(~type_="string", ~description="Filter by branch or tag name")),
      ("per_page", McpSdk.makeProperty(~type_="number", ~description="Number of pipelines per page (default 30)")),
      ("page", McpSdk.makeProperty(~type_="number", ~description="Page number")),
    ]),
  ),
}

let pipelineViewTool: McpSdk.tool = {
  name: "pipeline_view",
  description: "View details of a specific pipeline including its jobs and status",
  inputSchema: McpSdk.makeInputSchema(
    ~properties=Dict.fromArray([
      ("pipeline_id", McpSdk.makeProperty(~type_="number", ~description="The pipeline ID")),
      ("repo", McpSdk.makeProperty(~type_="string", ~description="Repository in OWNER/REPO format (optional)")),
    ]),
    ~required=["pipeline_id"],
  ),
}

let pipelineCreateTool: McpSdk.tool = {
  name: "pipeline_create",
  description: "Trigger a new CI/CD pipeline run",
  inputSchema: McpSdk.makeInputSchema(
    ~properties=Dict.fromArray([
      ("repo", McpSdk.makeProperty(~type_="string", ~description="Repository in OWNER/REPO format (optional)")),
      ("ref", McpSdk.makeProperty(~type_="string", ~description="Branch or tag to run pipeline on (defaults to default branch)")),
      ("variables", McpSdk.makeProperty(~type_="string", ~description="Pipeline variables in KEY=VALUE format, comma-separated")),
    ]),
  ),
}

let pipelineCancelTool: McpSdk.tool = {
  name: "pipeline_cancel",
  description: "Cancel a running pipeline",
  inputSchema: McpSdk.makeInputSchema(
    ~properties=Dict.fromArray([
      ("pipeline_id", McpSdk.makeProperty(~type_="number", ~description="The pipeline ID to cancel")),
      ("repo", McpSdk.makeProperty(~type_="string", ~description="Repository in OWNER/REPO format (optional)")),
    ]),
    ~required=["pipeline_id"],
  ),
}

let pipelineRetryTool: McpSdk.tool = {
  name: "pipeline_retry",
  description: "Retry a failed pipeline",
  inputSchema: McpSdk.makeInputSchema(
    ~properties=Dict.fromArray([
      ("pipeline_id", McpSdk.makeProperty(~type_="number", ~description="The pipeline ID to retry")),
      ("repo", McpSdk.makeProperty(~type_="string", ~description="Repository in OWNER/REPO format (optional)")),
    ]),
    ~required=["pipeline_id"],
  ),
}

let jobListTool: McpSdk.tool = {
  name: "job_list",
  description: "List jobs in a pipeline",
  inputSchema: McpSdk.makeInputSchema(
    ~properties=Dict.fromArray([
      ("pipeline_id", McpSdk.makeProperty(~type_="number", ~description="The pipeline ID")),
      ("repo", McpSdk.makeProperty(~type_="string", ~description="Repository in OWNER/REPO format (optional)")),
    ]),
    ~required=["pipeline_id"],
  ),
}

let jobViewTool: McpSdk.tool = {
  name: "job_view",
  description: "View details of a specific job including its log output",
  inputSchema: McpSdk.makeInputSchema(
    ~properties=Dict.fromArray([
      ("job_id", McpSdk.makeProperty(~type_="number", ~description="The job ID")),
      ("repo", McpSdk.makeProperty(~type_="string", ~description="Repository in OWNER/REPO format (optional)")),
    ]),
    ~required=["job_id"],
  ),
}

let jobRetryTool: McpSdk.tool = {
  name: "job_retry",
  description: "Retry a specific failed job",
  inputSchema: McpSdk.makeInputSchema(
    ~properties=Dict.fromArray([
      ("job_id", McpSdk.makeProperty(~type_="number", ~description="The job ID to retry")),
      ("repo", McpSdk.makeProperty(~type_="string", ~description="Repository in OWNER/REPO format (optional)")),
    ]),
    ~required=["job_id"],
  ),
}

let allTools = [
  // Issue tools
  issueListTool,
  issueViewTool,
  issueCreateTool,
  issueUpdateTool,
  issueCloseTool,
  issueReopenTool,
  issueNoteTool,
  // CI Pipeline tools
  pipelineListTool,
  pipelineViewTool,
  pipelineCreateTool,
  pipelineCancelTool,
  pipelineRetryTool,
  // CI Job tools
  jobListTool,
  jobViewTool,
  jobRetryTool,
]
