# RAG Implementation Patterns

Comprehensive guide to implementing Retrieval-Augmented Generation (RAG) systems including vector database selection, chunking strategies, embedding models, retrieval optimization, and production deployment patterns. Use when building RAG systems, implementing semantic search, optimizing retrieval quality, or debugging RAG performance issues.

---

## Quick Reference

**When to use this skill:**
- Building RAG/semantic search systems
- Implementing document retrieval pipelines
- Optimizing vector database performance
- Debugging retrieval quality issues
- Choosing between vector database options
- Designing chunking strategies
- Implementing hybrid search

**Technologies covered:**
- Vector DBs: Qdrant, Pinecone, Chroma, Weaviate, Milvus
- Embeddings: OpenAI, Sentence Transformers, Cohere
- Frameworks: LangChain, LlamaIndex, Haystack

---

## Part 1: Vector Database Selection

### Database Comparison Matrix

| Database | Best For | Deployment | Performance | Cost |
|----------|----------|------------|-------------|------|
| **Qdrant** | Self-hosted, production | Docker/K8s | Excellent (Rust) | Free (self-host) |
| **Pinecone** | Managed, rapid prototyping | Cloud | Excellent | Pay-per-use |
| **Chroma** | Local development, embedded | In-process | Good (Python) | Free |
| **Weaviate** | Complex schemas, GraphQL | Docker/Cloud | Excellent (Go) | Free + Cloud |
| **Milvus** | Large-scale, distributed | K8s | Excellent (C++) | Free (self-host) |

### Qdrant Setup (Recommended for Production)

```python
from qdrant_client import QdrantClient
from qdrant_client.models import Distance, VectorParams, PointStruct

# Initialize client (local or cloud)
client = QdrantClient(url="http://localhost:6333")  # or cloud URL

# Create collection
client.create_collection(
    collection_name="documents",
    vectors_config=VectorParams(
        size=1536,  # OpenAI text-embedding-3-small dimension
        distance=Distance.COSINE  # or DOT, EUCLID
    )
)

# Insert vectors with payload
client.upsert(
    collection_name="documents",
    points=[
        PointStruct(
            id=1,
            vector=[0.1, 0.2, ...],  # 1536 dimensions
            payload={
                "text": "Document content",
                "source": "doc.pdf",
                "page": 1,
                "metadata": {...}
            }
        )
    ]
)

# Search
results = client.search(
    collection_name="documents",
    query_vector=[0.1, 0.2, ...],
    limit=5,
    score_threshold=0.7  # Minimum similarity
)
```

### Pinecone Setup (Managed Service)

```python
from pinecone import Pinecone, ServerlessSpec

# Initialize
pc = Pinecone(api_key="your-key")

# Create index
pc.create_index(
    name="documents",
    dimension=1536,
    metric="cosine",
    spec=ServerlessSpec(cloud="aws", region="us-east-1")
)

# Get index
index = pc.Index("documents")

# Upsert vectors
index.upsert(vectors=[
    ("doc1", [0.1, 0.2, ...], {"text": "...", "source": "..."})
])

# Query
results = index.query(
    vector=[0.1, 0.2, ...],
    top_k=5,
    include_metadata=True
)
```

---

## Part 2: Chunking Strategies

### Strategy 1: Fixed-Size Chunking (Simple, Fast)

```python
def fixed_size_chunking(text: str, chunk_size: int = 512, overlap: int = 50) -> list[str]:
    """
    Split text into fixed-size chunks with overlap.

    Pros: Simple, predictable chunk sizes
    Cons: May break mid-sentence, poor semantic boundaries
    """
    words = text.split()
    chunks = []

    for i in range(0, len(words), chunk_size - overlap):
        chunk = ' '.join(words[i:i + chunk_size])
        chunks.append(chunk)

    return chunks

# Usage
chunks = fixed_size_chunking(document, chunk_size=512, overlap=50)
```

**When to use:**
- Simple documents (logs, transcripts)
- Prototyping/MVP
- Consistent token budgets needed

### Strategy 2: Semantic Chunking (Better Quality)

```python
from langchain.text_splitter import RecursiveCharacterTextSplitter

def semantic_chunking(text: str, chunk_size: int = 1000, overlap: int = 200) -> list[str]:
    """
    Split on semantic boundaries (paragraphs, sentences).

    Pros: Preserves meaning, better retrieval quality
    Cons: Variable chunk sizes, slower processing
    """
    splitter = RecursiveCharacterTextSplitter(
        chunk_size=chunk_size,
        chunk_overlap=overlap,
        separators=["\n\n", "\n", ". ", " ", ""],  # Priority order
        length_function=len
    )

    return splitter.split_text(text)

# Usage
chunks = semantic_chunking(document, chunk_size=1000, overlap=200)
```

**When to use:**
- Long-form documents (articles, books, reports)
- Quality > speed
- Natural language content

### Strategy 3: Hierarchical Chunking (Best for Structured Docs)

```python
def hierarchical_chunking(document: dict) -> list[dict]:
    """
    Chunk based on document structure (sections, subsections).

    Pros: Preserves hierarchy, enables parent-child retrieval
    Cons: Requires structured input, more complex
    """
    chunks = []

    for section in document['sections']:
        # Parent chunk (section summary)
        chunks.append({
            'text': section['title'] + '\n' + section['summary'],
            'type': 'parent',
            'section_id': section['id']
        })

        # Child chunks (paragraphs)
        for para in section['paragraphs']:
            chunks.append({
                'text': para,
                'type': 'child',
                'parent_id': section['id']
            })

    return chunks
```

**When to use:**
- Technical documentation
- Books with TOC
- Legal documents
- Need to preserve context hierarchy

### Strategy 4: Sliding Window (Maximum Context Preservation)

```python
def sliding_window_chunking(text: str, window_size: int = 512, stride: int = 256) -> list[str]:
    """
    Overlapping windows for maximum context.

    Pros: No information loss at boundaries
    Cons: Storage overhead (duplicate content)
    """
    words = text.split()
    chunks = []

    for i in range(0, len(words) - window_size + 1, stride):
        chunk = ' '.join(words[i:i + window_size])
        chunks.append(chunk)

    return chunks
```

**When to use:**
- Critical retrieval accuracy needed
- Short queries need broader context
- Storage cost not a concern

---

## Part 3: Embedding Models

### Model Selection Guide

| Model | Dimensions | Speed | Quality | Cost | Use Case |
|-------|-----------|-------|---------|------|----------|
| **OpenAI text-embedding-3-small** | 1536 | Fast | Excellent | $0.02/1M tokens | Production, general purpose |
| **OpenAI text-embedding-3-large** | 3072 | Medium | Best | $0.13/1M tokens | High-quality retrieval |
| **all-MiniLM-L6-v2** | 384 | Very fast | Good | Free | Self-hosted, prototyping |
| **all-mpnet-base-v2** | 768 | Fast | Very good | Free | Self-hosted, quality |
| **Cohere embed-english-v3.0** | 1024 | Fast | Excellent | $0.10/1M tokens | Semantic search focus |

### OpenAI Embeddings (Recommended)

```python
from openai import OpenAI

client = OpenAI(api_key="your-key")

def get_embeddings(texts: list[str], model: str = "text-embedding-3-small") -> list[list[float]]:
    """
    Generate embeddings using OpenAI.

    Batch size: Up to 2048 inputs per request
    Rate limits: Check tier limits
    """
    response = client.embeddings.create(
        model=model,
        input=texts
    )

    return [item.embedding for item in response.data]

# Usage
chunks = ["chunk 1", "chunk 2", ...]
embeddings = get_embeddings(chunks)
```

### Sentence Transformers (Self-Hosted)

```python
from sentence_transformers import SentenceTransformer

# Load model (cached after first download)
model = SentenceTransformer('all-MiniLM-L6-v2')

def get_embeddings_local(texts: list[str]) -> list[list[float]]:
    """
    Generate embeddings locally (no API costs).

    GPU recommended for batches > 100
    CPU acceptable for small batches
    """
    return model.encode(texts, show_progress_bar=True).tolist()

# Usage
embeddings = get_embeddings_local(chunks)
```

---

## Part 4: Retrieval Optimization

### Technique 1: Hybrid Search (Dense + Sparse)

```python
from qdrant_client.models import Filter, FieldCondition, MatchValue

def hybrid_search(query: str, query_vector: list[float], top_k: int = 10):
    """
    Combine dense (vector) and sparse (keyword) search.

    Dense: Semantic similarity
    Sparse: Exact keyword matches
    """
    # Dense search
    dense_results = client.search(
        collection_name="documents",
        query_vector=query_vector,
        limit=top_k * 2  # Get more candidates
    )

    # Sparse search (BM25 via metadata)
    sparse_results = client.search(
        collection_name="documents",
        query_filter=Filter(
            must=[
                FieldCondition(
                    key="text",
                    match=MatchValue(value=query)
                )
            ]
        ),
        limit=top_k * 2
    )

    # Merge and re-rank
    combined = merge_results(dense_results, sparse_results, weights=(0.7, 0.3))
    return combined[:top_k]
```

### Technique 2: Query Expansion

```python
def expand_query(query: str) -> list[str]:
    """
    Generate query variations for better recall.

    Techniques:
    - Synonym expansion
    - Question reformulation
    - Entity extraction
    """
    from openai import OpenAI
    client = OpenAI()

    response = client.chat.completions.create(
        model="gpt-4",
        messages=[{
            "role": "system",
            "content": "Generate 3 alternative phrasings of the user's query."
        }, {
            "role": "user",
            "content": query
        }]
    )

    expanded = [query] + response.choices[0].message.content.split('\n')
    return expanded

# Usage
queries = expand_query("How to train neural networks?")
# → ["How to train neural networks?",
#    "What are neural network training techniques?",
#    "Neural network optimization methods",
#    "Deep learning model training"]
```

### Technique 3: Reranking

```python
from sentence_transformers import CrossEncoder

# Load cross-encoder (better than bi-encoder for reranking)
reranker = CrossEncoder('cross-encoder/ms-marco-MiniLM-L-6-v2')

def rerank_results(query: str, results: list[dict], top_k: int = 5) -> list[dict]:
    """
    Rerank initial results using cross-encoder.

    More accurate but slower than initial retrieval
    Use on top 20-50 candidates only
    """
    # Score each query-document pair
    pairs = [(query, result['text']) for result in results]
    scores = reranker.predict(pairs)

    # Combine scores with results
    for result, score in zip(results, scores):
        result['rerank_score'] = float(score)

    # Sort and return top_k
    reranked = sorted(results, key=lambda x: x['rerank_score'], reverse=True)
    return reranked[:top_k]
```

### Technique 4: Metadata Filtering

```python
def filtered_search(
    query_vector: list[float],
    filters: dict,
    top_k: int = 5
):
    """
    Filter search by metadata (date, category, author, etc.)

    Pre-filter: Faster but may miss results
    Post-filter: More results but slower
    """
    from qdrant_client.models import Filter, FieldCondition, Range

    # Build filter conditions
    conditions = []

    if 'date_range' in filters:
        conditions.append(
            FieldCondition(
                key="date",
                range=Range(
                    gte=filters['date_range']['start'],
                    lte=filters['date_range']['end']
                )
            )
        )

    if 'category' in filters:
        conditions.append(
            FieldCondition(
                key="category",
                match=MatchValue(value=filters['category'])
            )
        )

    # Search with filters
    results = client.search(
        collection_name="documents",
        query_vector=query_vector,
        query_filter=Filter(must=conditions) if conditions else None,
        limit=top_k
    )

    return results
```

---

## Part 5: Context Management

### Pattern 1: Retrieved Context Optimization

```python
def optimize_context(query: str, retrieved_docs: list[str], max_tokens: int = 4000) -> str:
    """
    Optimize retrieved context to fit within LLM context window.

    Strategies:
    1. Relevance-based truncation
    2. Extractive summarization
    3. Overlap removal
    """
    # Sort by relevance
    sorted_docs = sorted(retrieved_docs, key=lambda d: d['score'], reverse=True)

    # Build context within token budget
    context_parts = []
    total_tokens = 0

    for doc in sorted_docs:
        doc_tokens = estimate_tokens(doc['text'])

        if total_tokens + doc_tokens <= max_tokens:
            context_parts.append(f"[Source: {doc['source']}]\n{doc['text']}")
            total_tokens += doc_tokens
        else:
            # Truncate last document to fit
            remaining = max_tokens - total_tokens
            truncated = truncate_to_tokens(doc['text'], remaining)
            context_parts.append(f"[Source: {doc['source']}]\n{truncated}")
            break

    return "\n\n---\n\n".join(context_parts)
```

### Pattern 2: Citation Tracking

```python
def generate_with_citations(query: str, context: str, sources: list[dict]) -> dict:
    """
    Generate answer with citation tracking.

    Returns:
    - answer: Generated text
    - citations: List of source documents used
    """
    from openai import OpenAI
    client = OpenAI()

    # Create source map
    source_map = {i+1: source for i, source in enumerate(sources)}
    numbered_context = "\n\n".join([
        f"[{i+1}] {source['text']}"
        for i, source in enumerate(sources)
    ])

    response = client.chat.completions.create(
        model="gpt-4",
        messages=[{
            "role": "system",
            "content": "Answer using the provided sources. Cite sources as [1], [2], etc."
        }, {
            "role": "user",
            "content": f"Context:\n{numbered_context}\n\nQuestion: {query}"
        }]
    )

    answer = response.choices[0].message.content

    # Extract citations from answer
    import re
    cited_nums = set(map(int, re.findall(r'\[(\d+)\]', answer)))
    cited_sources = [source_map[num] for num in cited_nums if num in source_map]

    return {
        'answer': answer,
        'citations': cited_sources,
        'num_sources_used': len(cited_sources)
    }
```

---

## Part 6: Production Best Practices

### Caching Strategy

```python
from functools import lru_cache
import hashlib

class EmbeddingCache:
    """Cache embeddings to avoid recomputation."""

    def __init__(self, cache_size: int = 10000):
        self.cache = {}
        self.max_size = cache_size

    def get_or_compute(self, text: str, embed_fn) -> list[float]:
        # Create cache key
        key = hashlib.sha256(text.encode()).hexdigest()

        if key in self.cache:
            return self.cache[key]

        # Compute and cache
        embedding = embed_fn(text)

        if len(self.cache) >= self.max_size:
            # Evict oldest (FIFO)
            self.cache.pop(next(iter(self.cache)))

        self.cache[key] = embedding
        return embedding

# Usage
cache = EmbeddingCache()
embedding = cache.get_or_compute(text, lambda t: get_embeddings([t])[0])
```

### Async Processing

```python
import asyncio
from typing import List

async def process_documents_async(documents: List[str], batch_size: int = 100):
    """
    Process large document sets asynchronously.

    Benefits:
    - 10-50x faster for I/O-bound operations
    - Better resource utilization
    - Scalable to millions of documents
    """
    async def process_batch(batch):
        embeddings = await get_embeddings_async(batch)
        await upsert_to_db_async(batch, embeddings)

    # Split into batches
    batches = [documents[i:i+batch_size] for i in range(0, len(documents), batch_size)]

    # Process batches concurrently
    await asyncio.gather(*[process_batch(batch) for batch in batches])

# Usage
asyncio.run(process_documents_async(documents))
```

### Monitoring & Observability

```python
import time
from dataclasses import dataclass
from datetime import datetime

@dataclass
class RAGMetrics:
    """Track RAG system performance."""
    query_count: int = 0
    avg_retrieval_time: float = 0.0
    avg_generation_time: float = 0.0
    cache_hit_rate: float = 0.0
    avg_num_results: float = 0.0

class RAGMonitor:
    def __init__(self):
        self.metrics = RAGMetrics()
        self.query_times = []

    def log_query(self, retrieval_time: float, generation_time: float, num_results: int):
        self.metrics.query_count += 1
        self.query_times.append({
            'timestamp': datetime.now(),
            'retrieval_time': retrieval_time,
            'generation_time': generation_time,
            'num_results': num_results
        })

        # Update averages
        self.metrics.avg_retrieval_time = sum(
            q['retrieval_time'] for q in self.query_times
        ) / len(self.query_times)

        self.metrics.avg_generation_time = sum(
            q['generation_time'] for q in self.query_times
        ) / len(self.query_times)

    def get_metrics(self) -> dict:
        return {
            'total_queries': self.metrics.query_count,
            'avg_retrieval_ms': self.metrics.avg_retrieval_time * 1000,
            'avg_generation_ms': self.metrics.avg_generation_time * 1000,
            'p95_retrieval_ms': self._percentile([q['retrieval_time'] for q in self.query_times], 95) * 1000
        }
```

---

## Part 7: Common Pitfalls & Solutions

### Pitfall 1: Chunk Size Too Small/Large

**Problem:** Small chunks lack context, large chunks reduce retrieval precision

**Solution:**
```python
# Experiment with chunk sizes
chunk_sizes = [256, 512, 1024, 2048]
for size in chunk_sizes:
    chunks = semantic_chunking(document, chunk_size=size)
    # Evaluate retrieval quality
    recall = evaluate_retrieval(chunks, test_queries)
    print(f"Size {size}: Recall {recall:.2f}")

# Typical sweet spot: 512-1024 tokens
```

### Pitfall 2: Poor Embedding Model Choice

**Problem:** Model not suited for domain (e.g., code search with general model)

**Solution:**
```python
# Use domain-specific models
domain_models = {
    'code': 'microsoft/codebert-base',
    'medical': 'dmis-lab/biobert-v1.1',
    'legal': 'nlpaueb/legal-bert-base-uncased',
    'general': 'text-embedding-3-small'
}

model = domain_models.get(your_domain, 'text-embedding-3-small')
```

### Pitfall 3: No Query Optimization

**Problem:** User queries don't match document phrasing

**Solution:** Implement query expansion + rewriting
```python
def optimize_query(raw_query: str) -> str:
    """Transform user query to better match documents."""
    # Example: "how 2 train NN" → "neural network training methods"
    # Use LLM to rewrite poorly-formed queries
    pass
```

### Pitfall 4: Ignoring Metadata

**Problem:** Returning irrelevant results due to lack of filtering

**Solution:** Always store rich metadata
```python
payload = {
    'text': chunk,
    'source': 'doc.pdf',
    'page': 5,
    'date': '2024-01-15',
    'category': 'engineering',
    'author': 'John Doe',
    'confidence': 0.95  # Document quality score
}
```

---

## Quick Decision Trees

### "Which vector DB should I use?"

```
Need managed service?
  YES → Pinecone (easy) or Weaviate Cloud
  NO  → Continue

Need distributed/high-scale?
  YES → Milvus or Weaviate
  NO  → Continue

Self-hosting on Docker?
  YES → Qdrant (best performance/features)
  NO  → Chroma (embedded, simple)
```

### "Which chunking strategy?"

```
Document type?
  Structured (docs, books) → Hierarchical chunking
  Unstructured (chat, logs) → Fixed-size chunking
  Mixed → Semantic chunking

Quality requirement?
  Critical → Sliding window (overlap 50%)
  Standard → Semantic (overlap 20%)
  Fast/cheap → Fixed-size (overlap 10%)
```

### "Which embedding model?"

```
Budget?
  No limits → text-embedding-3-large
  Cost-sensitive → all-mpnet-base-v2 (self-hosted)

Quality requirement?
  Best → text-embedding-3-large
  Good → text-embedding-3-small or Cohere
  Acceptable → all-MiniLM-L6-v2
```

---

## Example: Complete RAG Pipeline

```python
from qdrant_client import QdrantClient
from openai import OpenAI
from langchain.text_splitter import RecursiveCharacterTextSplitter

class RAGPipeline:
    def __init__(self):
        self.qdrant = QdrantClient(url="http://localhost:6333")
        self.openai = OpenAI()
        self.splitter = RecursiveCharacterTextSplitter(chunk_size=1000, chunk_overlap=200)

    def ingest_document(self, text: str, metadata: dict):
        """Ingest and index a document."""
        # 1. Chunk
        chunks = self.splitter.split_text(text)

        # 2. Embed
        embeddings = self.openai.embeddings.create(
            model="text-embedding-3-small",
            input=chunks
        ).data

        # 3. Store
        points = [
            PointStruct(
                id=i,
                vector=emb.embedding,
                payload={'text': chunk, **metadata}
            )
            for i, (chunk, emb) in enumerate(zip(chunks, embeddings))
        ]

        self.qdrant.upsert(collection_name="docs", points=points)

    def query(self, question: str, top_k: int = 5) -> str:
        """Query with RAG."""
        # 1. Embed query
        query_emb = self.openai.embeddings.create(
            model="text-embedding-3-small",
            input=[question]
        ).data[0].embedding

        # 2. Retrieve
        results = self.qdrant.search(
            collection_name="docs",
            query_vector=query_emb,
            limit=top_k
        )

        # 3. Build context
        context = "\n\n".join([r.payload['text'] for r in results])

        # 4. Generate
        response = self.openai.chat.completions.create(
            model="gpt-4",
            messages=[{
                "role": "system",
                "content": f"Answer based on this context:\n{context}"
            }, {
                "role": "user",
                "content": question
            }]
        )

        return response.choices[0].message.content

# Usage
rag = RAGPipeline()
rag.ingest_document(document_text, {'source': 'manual.pdf'})
answer = rag.query("How do I configure the system?")
```

---

## Resources

- **Qdrant Docs:** https://qdrant.tech/documentation/
- **Pinecone Docs:** https://docs.pinecone.io/
- **OpenAI Embeddings:** https://platform.openai.com/docs/guides/embeddings
- **LangChain RAG:** https://python.langchain.com/docs/use_cases/question_answering/
- **Sentence Transformers:** https://www.sbert.net/

---

**Skill version:** 1.0.0
**Last updated:** 2025-10-25
**Maintained by:** Applied Artificial Intelligence
