# @greenfinity/gitlab-mcp

MCP server for GitLab issue and CI/CD management using the glab CLI.

## Motivation

The official GitLab MCP (`glab mcp serve`) exposes 250+ tools, consuming significant context tokens (~25k) when used with Claude. This minimal MCP wrapper exposes only essential issue and CI/CD management tools (15 tools, ~6-8k tokens), reducing context usage by approximately 70%.

This server wraps the `glab` CLI to provide issue and CI/CD management functionality without the overhead of the full GitLab MCP toolset.

## Requirements

- [glab](https://gitlab.com/gitlab-org/cli) CLI installed and authenticated
- Node.js 22+

## Installation

```bash
npm install @greenfinity/gitlab-mcp
```

Or run directly with npx:

```bash
npx @greenfinity/gitlab-mcp
```

## Usage

### With Claude Desktop

Add to your Claude Desktop configuration:

```json
{
  "mcpServers": {
    "gitlab": {
      "command": "npx",
      "args": ["@greenfinity/gitlab-mcp"],
      "env": {
        "GITLAB_HOST": "gitlab.example.com"
      }
    }
  }
}
```

### With Claude Code

Add to your `~/.claude.json`:

```json
{
  "mcpServers": {
    "gitlab": {
      "type": "stdio",
      "command": "node",
      "args": ["/path/to/gitlab-mcp/src/Cli.bs.mjs"],
      "env": {
        "GITLAB_HOST": "gitlab.example.com"
      }
    }
  }
}
```

## Supported Tools (15 total)

### Issue Management (7 tools)

- `issue_list` - List project issues with filters (state, labels, assignee, author, search)
- `issue_view` - View details of a specific issue by ID
- `issue_create` - Create a new issue
- `issue_update` - Update an existing issue
- `issue_close` - Close an issue
- `issue_reopen` - Reopen a closed issue
- `issue_note` - Add a comment/note to an issue

### CI/CD Pipeline Management (5 tools)

- `pipeline_list` - List CI/CD pipelines with filters (status, ref/branch)
- `pipeline_view` - View details of a specific pipeline including jobs
- `pipeline_create` - Trigger a new pipeline run
- `pipeline_cancel` - Cancel a running pipeline
- `pipeline_retry` - Retry a failed pipeline

### CI/CD Job Management (3 tools)

- `job_list` - List jobs in a pipeline
- `job_view` - View job details and log output
- `job_retry` - Retry a specific failed job

## Why ReScript?

This package is implemented in [ReScript](https://rescript-lang.org/), a functional language that compiles to JavaScript. ReScript offers a sound type system, excellent pattern matching, and produces clean, readable JavaScript output with no runtime overhead.

The compiled JavaScript is included in the npm package, so you can use this as a regular JavaScript module without any additional tooling.

### Local Development

For local development:

```bash
# Install dependencies
yarn install

# Build the ReScript sources to JavaScript
yarn build

# Watch mode for development
yarn rescript:dev
```

## License

MIT
