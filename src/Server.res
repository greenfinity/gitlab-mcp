// MCP Server for GitLab issue management

let createServer = () => {
  let server = McpSdk.createServer(
    {
      name: "gitlab-mcp",
      version: "1.0.0",
    },
    {
      capabilities: {
        tools: %raw(`{}`),
      },
    },
  )

  // Handle list tools request
  server->McpSdk.setRequestHandler(McpSdk.listToolsRequestSchema, async _request => {
    {McpSdk.tools: Tools.allTools}
  })

  // Handle call tool request
  server->McpSdk.setRequestHandler(McpSdk.callToolRequestSchema, async (request: McpSdk.callToolRequest) => {
    let name = request.params.name
    let args = request.params.arguments

    switch name->Types.toolNameFromString {
    | Some(toolName) => await Handlers.handleTool(toolName, args)
    | None => McpSdk.makeErrorResponse(`Unknown tool: ${name}`)
    }
  })

  server
}

let runServer = async () => {
  let server = createServer()
  let transport = McpSdk.createStdioTransport()
  await server->McpSdk.connect(transport)
  Console.error("GitLab MCP server started")
}
