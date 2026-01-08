// MCP SDK bindings for ReScript

type server
type transport

// Server creation
type serverInfo = {
  name: string,
  version: string,
}

type serverCapabilities = {tools: {.}}

type serverOptions = {capabilities: serverCapabilities}

@module("@modelcontextprotocol/sdk/server/index.js") @new
external createServer: (serverInfo, serverOptions) => server = "Server"

// Transport
@module("@modelcontextprotocol/sdk/server/stdio.js") @new
external createStdioTransport: unit => transport = "StdioServerTransport"

// Request schemas
@module("@modelcontextprotocol/sdk/types.js")
external listToolsRequestSchema: 'a = "ListToolsRequestSchema"

@module("@modelcontextprotocol/sdk/types.js")
external callToolRequestSchema: 'a = "CallToolRequestSchema"

// Request handler
@send
external setRequestHandler: (server, 'schema, 'request => promise<'response>) => unit =
  "setRequestHandler"

// Connect
@send external connect: (server, transport) => promise<unit> = "connect"

// Tool definition types
type inputSchemaProperty = {
  @as("type") type_: string,
  description?: string,
  enum?: array<string>,
}

type inputSchema = {
  @as("type") type_: string,
  properties: Dict.t<inputSchemaProperty>,
  required?: array<string>,
}

type tool = {
  name: string,
  description: string,
  inputSchema: inputSchema,
}

type listToolsResponse = {tools: array<tool>}

// Call tool request
type callToolParams = {
  name: string,
  arguments: option<JSON.t>,
}

type callToolRequest = {params: callToolParams}

// Call tool response
type textContent = {
  @as("type") type_: string,
  text: string,
}

type callToolResponse = {
  content: array<textContent>,
  isError?: bool,
}

// Helper functions for creating schemas
let makeProperty = (~type_: string, ~description: string) => {
  {type_: type_, description: description}
}

let makeEnumProperty = (~type_: string, ~description: string, ~enum: array<string>) => {
  {type_: type_, description: description, enum: enum}
}

let makeInputSchema = (~properties: Dict.t<inputSchemaProperty>, ~required: option<array<string>>=?) => {
  let schema: inputSchema = {
    type_: "object",
    properties: properties,
  }
  switch required {
  | Some(req) => {...schema, required: req}
  | None => schema
  }
}

let makeTextContent = (text: string) => {
  {type_: "text", text: text}
}

let makeSuccessResponse = (text: string): callToolResponse => {
  {content: [{type_: "text", text: text}]}
}

let makeErrorResponse = (text: string): callToolResponse => {
  {content: [{type_: "text", text: text}], isError: true}
}
