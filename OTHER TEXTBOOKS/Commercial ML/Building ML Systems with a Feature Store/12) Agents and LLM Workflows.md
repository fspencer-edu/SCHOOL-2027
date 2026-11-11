
- Agents
	- External tools
	- Memory
	- Plan strategies to achieve goals
	- Interactive services
	- Background agents that execute tasks autonomously
- 2 protocols
	- Model Context Protocol (MCP)
	- Agent-to-Agent (A2A)
		- Standardize access to diverse tools and agents
		- Agents to discover and use tools and other agents at runtime
- LLM workflow patterns
	- Routing
	- Constraint autonomy

# From LLMs to Agents

- System prompt
	- Helped responses follow expected guidelines
- RAG
	- Dynamically add examples retrieved at query time to the system prompt
	- Retrieve similar chunks of text from a vector text

<img src="/images/Pasted image 20261111113305.png" alt="image" width="500">

- Regularly update the vector index with new data
- Vector embedding pipeline
	- Chunking involves splitting text documents into smaller chunks
	- A vector embedding is then computed independently for each chunk using an embedding model
	- Vector embeddings are stored in a vector index for later retrieval

- Client uses the vector index
	- Query is fed through the same embedding model to produce a vector embedding
	- Send query embedding to vector index and retrieve the k most similar chunks of text
	- Augment the prompt by adding the returned chunks to the prompt template
	- Generate a response by sending the prompt to the LLM

- Agent architecture
	- Uses external APIs/services/databases as a tool via the MCP
	- Each tool provides an MCP compliant server to handle requests and return results
	- Makes calls to one or more LLMs with a prompt
	- Logs its calls to tools and LLM queries as traces
	- Exposes its capabilities via the A2A protocol

- MCP protocol
	- Generic mechanism for an agent to access any external service or RAG data source

<img src="/images/Pasted image 20261111113810.png" alt="image" width="500">

## Prompt Management

- System prompt
	- Define how an LLM should behave
	- Instructions
		- Limitation
		- Privacy
		- Use styles for responses
		- Avoid opinion and promotion

- Design the enclosing prompt template
	- System prompt
	- User prompt
	- Assistant prompt
- Prompt template can be defined in a markup language (prompt format)

```python
<|system|>

You are a helpful assistant.

<|user|>

What’s the capital of France?

<|assistant|>

The capital of France is Paris.

<|begin_of_text|><|header_start|>user<|header_end|>

<|image_start|><|image|><|patch|>...<|patch|><|image_end|>

Describe this image in two sentences<|eot|>

<|header_start|>assistant<|header_end|>

The image depicts a dog standing on a skateboard….<|eot|>
```

- Design a prompt template for every LLM interaction supported by your agent
- LlamaIndex and Comet ML's Opik

```python
from llama_index.prompts import ChatPromptTemplate, SystemMessage, UserMessage

def load_system_prompt(filepath: str) -> str:
    with open(filepath, "r", encoding="utf-8") as f:
        return f.read().strip()

def get_prompt_template(model_name: str) -> ChatPromptTemplate:
    if model_name.startswith("mistral"):
        system_prompt = load_system_prompt("mistral_system.txt")
    elif model_name.startswith("llama"):
        system_prompt = load_system_prompt("llama_system.txt")

    return ChatPromptTemplate(
        messages=[
            SystemMessage(content=system_prompt),
            UserMessage(content="{user_input}")
        ]
    )

def get_model(model_name: str):
    if model_name.startswith("llama"):
        return TogetherLLM(model=f"meta-llama/{model_name}")
    elif model_name.startswith("mistral"):
        return MistralAI(model="mistral-large-latest")

if __name__ == "__main__":
    model_name = "llama-3-70b-chat-hf"  # or "mistral-large-latest"
    user_input = "What are the main differences between LlamaIndex and LangGraph?"
    prompt_template = get_prompt_template(model_name)
    messages = prompt_template.format_messages(user_input=user_input)
    model = get_model(model_name)
    response = model.chat(messages).message.content
    print("Response:\n", response)
```

- Prompt is versioned as a file along with the code
- Version prompts in a data platform, and downloaded when needed
	- Easier governance, analytics, and search for prompts

```python
import opik
prompt = opik.Prompt(  # Saves this Prompt to the Opik Server
  name="MLFS Prompt",
  prompt="Hi {{name}}. Welcome to {{location}}. How can I assist you today?"
)

client = opik.Opik() # Download a prompt with an Opik client
prompt = client.get_prompt(name="MLFS Prompt")
formatted_prompt = prompt.format(name="Alice", location="Wonderland")
```

## Prompt Engineering

- System prompt should describe the task for the LLM to perform
	- Output format
	- System prompt should describe desirable properties for the output code created and provide code examples to help the LLM avoid common mistakes
	- Context information

- In-context learning
	- Provide context
	- Statistically in the system or dynamically with RAG
- Chain-of-thought (CoT) prompting
	- Instruct the LLM to think step-by-step toward a more systematic approach to problem solving
	- Reasoning trace is effectively the model explaining its final response
	- Self-critique, and validate its own reasoning
- Role playing
	- Who is interacting or speaking
- Structured output
	- Tell the LLM to produce structured output
	- MCP tools also often rely on structured outputs
- Prompt decomposition
	- Break down a complex task into smaller tasks and chain prompt together in a workflow

- RAG
- Function calling
- Workflow

## Context Window

- Context length
	- Define the maximum number of tokens supported in the context window
	- Entire conversation history, user query, system prompt, and LLM output
	- 128K tokens (DeepSeek-V3)
- Continue conversation
	- Warn user they have reached the limit of the context length and prevent continuing
	- Forget the earlier tokens (catastrophically)
	- Summarize early parts and replace the early token with the summary

- Current generation of LLMs drop in performance as input length approaches the context length

<img src="/images/Pasted image 20261111114910.png" alt="image" width="500">

- Computation complexity for transformer-based LLMs scaled quadratically with context length, $O(n^2)$, n is the number of token
	- Self-attention mechanisms
	- Every token attends to every other token
- Large context window LLMs have developed to make longer inputs scale closer to sub quadratic, $O(nlogn)$
	- Flash attention and mixture of expert architectures

## Agents and Workflows with LlamaIndex

- LlamaIndex
	- Open source framework for building stateful LLM-powered workflows and agents
	- Simplified common low-level operations
		- Calling LLMs
		- Defining and parsing prompts
		- Retrieving context data from external service
		- Orchestrating operations
- Query engines
	- Take a query and return a response
	- Abstracting away the retrieval/LLM/tool workflow
- Retrievers
	- Pull relevant context data for the user's query from a vector index, free-text search engine (BM25), feature store, or external API
- Tools
	- Python callables
		- Functions, methods, classes
	- Encapsulate actions!
- Settings
	- Configuration objects for LLM, embedding model, and prompt helper
- Prompt templates
	- Customizing system prompt and user prompt
- Memory objects
	- Maintaining and updating conversation state

- Workflow in Llamaindex
	- User define pipeline that specifies which steps, components, and logic to execute and in what order
	- Retrieve documents
	- Add context/examples to the system prompt
	- Summarize documents with LLM
- Conditional and parallel steps

- Agent
	- Autonomous program with an LLM, system prompt, and set of available tools
	- Builds the system prompt and fills placeholders using context data and its memory
- LLM outputs
	- A sequence of tools it want to perform
	- A response to the client
- Agent calls the LLM again, passing the whole conversation history

```python
from llama_index.llms.openai import OpenAI
from llama_index.tools.duckduckgo import DuckDuckGoSearchToolSpec
from llama_index.agent import OpenAIAgent

llm = OpenAI(model="gpt-5", temperature=0)

tools = DuckDuckGoSearchToolSpec().to_tool_list()

agent = OpenAIAgent.from_tools(
    tools,
    llm=llm,
    system_prompt="You are a helpful assistant.
    Use the search tool for new info."
)

question = "Who won the football game yesterday?"
response = agent.query(question)

print(getattr(response, "response", str(response)))
```

- Error compounding quickly makes autonomous multistep pipelines unreliable
- Deterministic, user-defined workflows are favours
- Workflows are structured as Python classes

```python
app = FastAPI()

class FraudExplanationWorkflow(Workflow):
    def __init__(self):
        super().__init__()
        fs = hopsworks.login().get_feature_store()
        self.fg = fs.get_feature_group(name="cc_fraud", version=1)
        self.model = self.fg.embeddingIndex.getEmbedding("explain_emb").model
        prompt_template = ChatPromptTemplate.from_messages([
            ("system",
             "Here are explanations for fraudulent credit card transactions. "
             "Summarize, identify patterns, group similar fraud types, "
             "and highlight if these cases represent common fraud scenarios."),
            ("user", "Context:\n{context}"),
        ])
        llm = ChatGroq(model="meta-llama/Llama-4-Scout-17B", temperature=0)
        self.query_engine = RetrieverQueryEngine.from_args(
            llm=llm, prompt=prompt_template
        )

    @step
    def fetch_explanation(self, ev: StartEvent) -> FetchExplanationEvent:
        tid = ev.payload
        row = self.fg.filter(f"tid={tid}").read()
        explanation = row.iloc[0]["explanation"]
        return FetchExplanationEvent(payload=explanation)

    @step
    def find_similar(self, ev: FetchExplanationEvent) -> FindSimilarEvent:
        encoded_explanation = self.model.encode(ev.payload)
        similar_trans = self.fg.find_neighbors(encoded_explanation, k=10)
        explanations = [str(x[1]) for x in similar_trans]
        full_text = "\n".join(explanations)
        combined_text = f"Similar transaction explanations were: {full_text}"
        return FindSimilarEvent(payload=combined_text)

    @step
    def summarize(self, ev: FindSimilarEvent) -> StopEvent:
        fraud_exs = ev.payload
        result = self.query_engine.query({"context": fraud_exs})
        return StopEvent(result=str(result))

@app.on_event("startup")
def initialize_workflow():
    app.state.workflow = FraudExplanationWorkflow()

@app.get("/find-similar-fraud")
def fraud_question(tid: str):
    result_event = app.state.workflow.run(tid)
    return {"result": result_event.result}
```

- Each method in the workflow is annotated with `@step` and takes a user defined `Event` handler object as a parameter
- `StopEvent`
	- Indicate the workflow does not need any further processing and can output its results

# Retrieval Augmented Generation (RAG)

- RAG puts relevant context in the prompt
- Too many examples cause prompt to be too generate, too few may not be a representative sample
- Associated with retrieval of document chunks using a vector index

- Chunking strategies
	- Sentence based chunking
		- Split at sentence boundaries
	- Paragraph-based chunking
		- Split at paragraph boundaries
	- Fixed token chunking
		- Consistent embedding sizes
		- No attention to document structure
	- Semantic chunking
		- Group semantically related context using embeddings or topic modeling
	- Recursive chunking
		- Apply hierarchical chunking strategies for nested document structures
	- Sliding windows
		- Create overlapping chunks with a fixed window size and stride

- Lost context problem (context degradation or context rot)
	- Model pays strong attention to information places at the beginning and end, while ignoring detailed in the middle

```python
def traditional_chunking(document, chunk_size=XXXX, overlap=YY):
    # Step 1: Split the document into chunks
    chunks = chunk_document(document, chunk_size, overlap)
    # Step 2: Embed each chunk independently
    chunk_embeddings = model.encode(chunks)
    return chunks, chunk_embeddings

chunks, embeddings = traditional_chunking(document)
```

- Chunking process treats each chunk as an independent document
	- References to entities mentioned in other chunks become ambiguous
	- Contextual information spanning chunk boundaries gets lost
	- Embedding model has no way to resolve these references

- Late-chunking in long-context embedding models
- LlamaIndex decouples application code from the vector index
	- Replace vector database with a different one

```python
fg = fs.get_feature_group(name="facts_about_hopsworks")
vectorstore = fg.get_vector_index(framework="llamaindex")
retriever = VectorIndexRetriever(
    index=vectorstore, 
    similarity_top_k=5
)
prompt_template = ChatPromptTemplate.from_messages([
    ("system", "Use the following examples to answer the question."),
    ("user", "Context:\n{context}"),
    ("user", "{question}"),
])

llm = Groq(model="meta-llama/llama-4-8b-instruct", temperature=0)

query_engine = RetrieverQueryEngine.from_args(
    retriever=retriever,
    llm=llm,
    prompt=prompt_template,
)

result = query_engine.query("Does Hopsworks make beer?")
```

- Vector indexes are probabilistic
- Reranking steps before adding the chunks to the prompt
- Reranking algorithms
	- Reorder the retrieved chunks based on relevance-scoring methods
	- retrieve more chunks and exclude with low relevance score

## Retrieval with a Document Store

- An alternative to using embedding-based retrieval is to use a document store with free-text search capabilities (search engine)
	- OpenSearch
	- Elasticsearch
- Open source document stores that use a data structure called an inverted index to support free-text search
- BM25
	- Term-based retrieval method that ranks documents based on how well the terms in the query match those in the document
		- Partial and full matches
	- Higher throughput for insertions and lower latency than vetor indexes

```python
from llama_index.tools import FunctionTool
from opensearchpy import OpenSearch

opensearch_api = hopsworks.login().get_opensearch_api()
client = OpenSearch(**opensearch_api.get_default_py_config())
project_index = opensearch_api.get_project_index()

def retrieve_opensearch(question: str, top_k: int = 3) -> str:
    response = client.search(
        index=project_index,
        body={ "query": { "match": { "text": question } } }
    )
    hits = response["hits"]["hits"]
    context = " ".join([hit["_source"]["text"] for hit in hits[:top_k]])
    return context

opensearch_tool = FunctionTool.from_defaults(
    fn=retrieve_opensearch,
    name="opensearch_retrieve",
    description="Search OpenSearch for relevant context given a question."
)

```


- Each project has its on default OpenSearch index

## Retrieval with a Feature Store

- Both vector indexes and inverted indexes take the user query directly as an input search string
- Much enterprise data is stored as structured data in row-oriented and columnar databases
	- Entity ID
	- SQL expression or an API call to retrieve the data

```python
def retrieve_feature_vector(cc_num: str) -> str:
    fv = feature_view.get_feature_vector(serving_keys={"cc_num": cc_num})
    return str(fv)

feature_store_tool = FunctionTool.from_defaults(
    fn=retrieve_feature_vector,
    name="feature_store_retrieve",
    description="Retrieve credit card details with a credit card number."
)
```

## Retrieval with a Graph Database

- Graph databases store information in a graph structure
- Knowledge graph
	- Composed of interconnected entities and relationships
- Product catalog
- Linking symptoms, diagnoses, and treatments
- Graph Query Language (GQL)
	- ISO that is based on the Cypher query language
- GraphRAG
	- Using a knowledge graph as the data source for retrieval RAGA
	- Build a GQL query that retrieves relevant nodes/edges/facts

```python
MATCH (c:CreditCard {number: '1234-5678'})-[:USED_IN]->
      (t:Transaction)-[:AT]->(m:Merchant),
      (t)-[:OCCURRED_AT]->(l:Location),
      (t)-[:REPORTED_AS]->(fr:FraudReport)
WHERE fr.is_fraud = true AND t.date >= date() - duration({days: 30})
RETURN t.id AS tid, t.date AS date, m.name AS merchant, l.city AS location
```

# Tools and Function Calling LLMs

- Function calling LLM
# Model Context Protocol
# Agent-to-Agent (A2A) Protocol
# From LLM Workflows to Agents

## Planning
## Security Challenges
## Domain-Specific (Intermediate) Representations
# A Development Process for Agents
# Agent Deployment in Hopsworks