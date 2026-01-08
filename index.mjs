#!/usr/bin/env node

import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
} from "@modelcontextprotocol/sdk/types.js";
import { spawn } from "child_process";

// Execute glab command and return output
async function execGlab(args) {
  return new Promise((resolve, reject) => {
    const proc = spawn("glab", args, {
      env: { ...process.env },
    });

    let stdout = "";
    let stderr = "";

    proc.stdout.on("data", (data) => {
      stdout += data.toString();
    });

    proc.stderr.on("data", (data) => {
      stderr += data.toString();
    });

    proc.on("close", (code) => {
      if (code === 0) {
        resolve(stdout);
      } else {
        reject(new Error(stderr || `glab exited with code ${code}`));
      }
    });

    proc.on("error", (err) => {
      reject(err);
    });
  });
}

// Define the tools we want to expose
const tools = [
  {
    name: "issue_list",
    description: "List project issues. Use --all for all issues, or filter by state, labels, assignee, etc.",
    inputSchema: {
      type: "object",
      properties: {
        repo: {
          type: "string",
          description: "Repository in OWNER/REPO format (optional, uses current repo if not specified)",
        },
        state: {
          type: "string",
          enum: ["opened", "closed", "all"],
          description: "Filter by issue state",
        },
        labels: {
          type: "string",
          description: "Comma-separated list of labels to filter by",
        },
        assignee: {
          type: "string",
          description: "Filter by assignee username",
        },
        author: {
          type: "string",
          description: "Filter by author username",
        },
        search: {
          type: "string",
          description: "Search issues by title and description",
        },
        per_page: {
          type: "number",
          description: "Number of issues per page (default 30)",
        },
        page: {
          type: "number",
          description: "Page number",
        },
      },
    },
  },
  {
    name: "issue_view",
    description: "View details of a specific issue by ID",
    inputSchema: {
      type: "object",
      properties: {
        issue_id: {
          type: "number",
          description: "The issue ID/number",
        },
        repo: {
          type: "string",
          description: "Repository in OWNER/REPO format (optional)",
        },
        comments: {
          type: "boolean",
          description: "Include comments in the output",
        },
      },
      required: ["issue_id"],
    },
  },
  {
    name: "issue_create",
    description: "Create a new issue",
    inputSchema: {
      type: "object",
      properties: {
        title: {
          type: "string",
          description: "Issue title",
        },
        description: {
          type: "string",
          description: "Issue description/body",
        },
        labels: {
          type: "string",
          description: "Comma-separated list of labels",
        },
        assignees: {
          type: "string",
          description: "Comma-separated list of assignee usernames",
        },
        milestone: {
          type: "string",
          description: "Milestone title or ID",
        },
        confidential: {
          type: "boolean",
          description: "Make the issue confidential",
        },
        repo: {
          type: "string",
          description: "Repository in OWNER/REPO format (optional)",
        },
      },
      required: ["title"],
    },
  },
  {
    name: "issue_update",
    description: "Update an existing issue",
    inputSchema: {
      type: "object",
      properties: {
        issue_id: {
          type: "number",
          description: "The issue ID/number",
        },
        title: {
          type: "string",
          description: "New issue title",
        },
        description: {
          type: "string",
          description: "New issue description/body",
        },
        labels: {
          type: "string",
          description: "Comma-separated list of labels to set",
        },
        unlabel: {
          type: "string",
          description: "Comma-separated list of labels to remove",
        },
        assignees: {
          type: "string",
          description: "Comma-separated list of assignee usernames",
        },
        unassign: {
          type: "boolean",
          description: "Remove all assignees",
        },
        milestone: {
          type: "string",
          description: "Milestone title or ID",
        },
        confidential: {
          type: "boolean",
          description: "Make the issue confidential",
        },
        repo: {
          type: "string",
          description: "Repository in OWNER/REPO format (optional)",
        },
      },
      required: ["issue_id"],
    },
  },
  {
    name: "issue_close",
    description: "Close an issue",
    inputSchema: {
      type: "object",
      properties: {
        issue_id: {
          type: "number",
          description: "The issue ID/number",
        },
        repo: {
          type: "string",
          description: "Repository in OWNER/REPO format (optional)",
        },
      },
      required: ["issue_id"],
    },
  },
  {
    name: "issue_reopen",
    description: "Reopen a closed issue",
    inputSchema: {
      type: "object",
      properties: {
        issue_id: {
          type: "number",
          description: "The issue ID/number",
        },
        repo: {
          type: "string",
          description: "Repository in OWNER/REPO format (optional)",
        },
      },
      required: ["issue_id"],
    },
  },
  {
    name: "issue_note",
    description: "Add a comment/note to an issue",
    inputSchema: {
      type: "object",
      properties: {
        issue_id: {
          type: "number",
          description: "The issue ID/number",
        },
        message: {
          type: "string",
          description: "The comment text",
        },
        repo: {
          type: "string",
          description: "Repository in OWNER/REPO format (optional)",
        },
      },
      required: ["issue_id", "message"],
    },
  },
];

// Build glab command args from tool input
function buildArgs(toolName, input) {
  const args = ["issue"];

  switch (toolName) {
    case "issue_list":
      args.push("list");
      if (input.repo) args.push("-R", input.repo);
      if (input.state) args.push("--state", input.state);
      if (input.labels) args.push("--label", input.labels);
      if (input.assignee) args.push("--assignee", input.assignee);
      if (input.author) args.push("--author", input.author);
      if (input.search) args.push("--search", input.search);
      if (input.per_page) args.push("--per-page", String(input.per_page));
      if (input.page) args.push("--page", String(input.page));
      break;

    case "issue_view":
      args.push("view", String(input.issue_id));
      if (input.repo) args.push("-R", input.repo);
      if (input.comments) args.push("--comments");
      break;

    case "issue_create":
      args.push("create");
      args.push("--title", input.title);
      if (input.description) args.push("--description", input.description);
      if (input.labels) args.push("--label", input.labels);
      if (input.assignees) args.push("--assignee", input.assignees);
      if (input.milestone) args.push("--milestone", input.milestone);
      if (input.confidential) args.push("--confidential");
      if (input.repo) args.push("-R", input.repo);
      args.push("--yes"); // Skip confirmation prompts
      break;

    case "issue_update":
      args.push("update", String(input.issue_id));
      if (input.title) args.push("--title", input.title);
      if (input.description) args.push("--description", input.description);
      if (input.labels) args.push("--label", input.labels);
      if (input.unlabel) args.push("--unlabel", input.unlabel);
      if (input.assignees) args.push("--assignee", input.assignees);
      if (input.unassign) args.push("--unassign");
      if (input.milestone) args.push("--milestone", input.milestone);
      if (input.confidential) args.push("--confidential");
      if (input.repo) args.push("-R", input.repo);
      break;

    case "issue_close":
      args.push("close", String(input.issue_id));
      if (input.repo) args.push("-R", input.repo);
      break;

    case "issue_reopen":
      args.push("reopen", String(input.issue_id));
      if (input.repo) args.push("-R", input.repo);
      break;

    case "issue_note":
      args.push("note", String(input.issue_id));
      args.push("--message", input.message);
      if (input.repo) args.push("-R", input.repo);
      break;

    default:
      throw new Error(`Unknown tool: ${toolName}`);
  }

  return args;
}

// Create and configure the MCP server
const server = new Server(
  {
    name: "gitlab-mcp",
    version: "1.0.0",
  },
  {
    capabilities: {
      tools: {},
    },
  }
);

// Handle list tools request
server.setRequestHandler(ListToolsRequestSchema, async () => {
  return { tools };
});

// Handle tool calls
server.setRequestHandler(CallToolRequestSchema, async (request) => {
  const { name, arguments: args } = request.params;

  try {
    const glabArgs = buildArgs(name, args || {});
    const output = await execGlab(glabArgs);

    return {
      content: [
        {
          type: "text",
          text: output || "Command completed successfully",
        },
      ],
    };
  } catch (error) {
    return {
      content: [
        {
          type: "text",
          text: `Error: ${error.message}`,
        },
      ],
      isError: true,
    };
  }
});

// Start the server
async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.error("GitLab MCP server started");
}

main().catch((error) => {
  console.error("Fatal error:", error);
  process.exit(1);
});
