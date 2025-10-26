# LLM Evaluation & Testing

Comprehensive guide to evaluating and testing LLM applications including prompt testing, output validation, hallucination detection, benchmark creation, A/B testing, and quality metrics. Use when testing LLM applications, validating prompt quality, implementing systematic LLM evaluation, or measuring model performance.

---

## Quick Reference

**When to use this skill:**
- Testing LLM application outputs
- Validating prompt quality and consistency
- Detecting hallucinations and factual errors
- Creating evaluation benchmarks
- A/B testing prompts or models
- Implementing continuous evaluation (CI/CD)
- Measuring retrieval quality (for RAG)
- Debugging unexpected LLM behavior

**Metrics covered:**
- Traditional: BLEU, ROUGE, BERTScore, Perplexity
- LLM-as-Judge: GPT-4 evaluation, rubric-based scoring
- Task-specific: Exact match, F1, accuracy, recall
- Quality: Toxicity, bias, coherence, relevance

---

## Part 1: Evaluation Fundamentals

### The LLM Evaluation Challenge

**Why LLM evaluation is hard:**
1. **Subjective quality** - "Good" output varies by use case
2. **No single ground truth** - Multiple valid answers
3. **Context-dependent** - Same output good/bad in different scenarios
4. **Expensive to label** - Human evaluation doesn't scale
5. **Adversarial brittleness** - Small prompt changes = large output changes

**Solution: Multi-layered evaluation**
```
Layer 1: Automated Metrics (fast, scalable)
  ↓
Layer 2: LLM-as-Judge (flexible, nuanced)
  ↓
Layer 3: Human Review (gold standard, expensive)
```

### Evaluation Dataset Structure

```python
from dataclasses import dataclass
from typing import List, Optional

@dataclass
class EvalExample:
    """Single evaluation example."""
    input: str  # User input / prompt
    expected_output: Optional[str]  # Gold standard (if exists)
    context: Optional[str]  # Additional context (for RAG)
    metadata: dict  # Category, difficulty, etc.

@dataclass
class EvalResult:
    """Evaluation result for one example."""
    example_id: str
    actual_output: str
    scores: dict  # {'metric_name': score}
    passed: bool
    failure_reason: Optional[str]

# Example dataset
eval_dataset = [
    EvalExample(
        input="What is the capital of France?",
        expected_output="Paris",
        context=None,
        metadata={'category': 'factual', 'difficulty': 'easy'}
    ),
    EvalExample(
        input="Explain quantum entanglement",
        expected_output=None,  # No single answer
        context=None,
        metadata={'category': 'explanation', 'difficulty': 'hard'}
    )
]
```

---

## Part 2: Traditional Metrics

### Metric 1: Exact Match (Simplest)

```python
def exact_match(predicted: str, expected: str, case_sensitive: bool = False) -> float:
    """
    Binary metric: 1.0 if match, 0.0 otherwise.

    Use for: Classification, short answers, structured output
    Limitations: Too strict for generation tasks
    """
    if not case_sensitive:
        predicted = predicted.lower().strip()
        expected = expected.lower().strip()

    return 1.0 if predicted == expected else 0.0

# Example
score = exact_match("Paris", "paris")  # 1.0
score = exact_match("The capital is Paris", "Paris")  # 0.0
```

### Metric 2: ROUGE (Recall-Oriented)

```python
from rouge_score import rouge_scorer

def compute_rouge(predicted: str, expected: str) -> dict:
    """
    ROUGE metrics for text overlap.

    ROUGE-1: Unigram overlap
    ROUGE-2: Bigram overlap
    ROUGE-L: Longest common subsequence

    Use for: Summarization, translation
    Limitations: Doesn't capture semantics
    """
    scorer = rouge_scorer.RougeScorer(['rouge1', 'rouge2', 'rougeL'], use_stemmer=True)
    scores = scorer.score(expected, predicted)

    return {
        'rouge1': scores['rouge1'].fmeasure,
        'rouge2': scores['rouge2'].fmeasure,
        'rougeL': scores['rougeL'].fmeasure
    }

# Example
scores = compute_rouge(
    predicted="Paris is the capital of France",
    expected="The capital of France is Paris"
)
# {'rouge1': 0.82, 'rouge2': 0.67, 'rougeL': 0.82}
```

### Metric 3: BERTScore (Semantic Similarity)

```python
from bert_score import score as bert_score

def compute_bertscore(predicted: List[str], expected: List[str]) -> dict:
    """
    Semantic similarity using BERT embeddings.

    Better than ROUGE for:
    - Paraphrases
    - Semantic equivalence
    - Generation quality

    Returns: Precision, Recall, F1
    """
    P, R, F1 = bert_score(predicted, expected, lang="en", verbose=False)

    return {
        'precision': P.mean().item(),
        'recall': R.mean().item(),
        'f1': F1.mean().item()
    }

# Example
scores = compute_bertscore(
    predicted=["The capital of France is Paris"],
    expected=["Paris is France's capital city"]
)
# {'precision': 0.94, 'recall': 0.91, 'f1': 0.92}
```

### Metric 4: Perplexity (Model Confidence)

```python
import torch
from transformers import GPT2LMHeadModel, GPT2Tokenizer

def compute_perplexity(text: str, model_name: str = "gpt2") -> float:
    """
    Perplexity: How "surprised" is the model by this text?

    Lower = More likely/fluent
    Use for: Fluency, naturalness
    Limitations: Doesn't measure correctness
    """
    model = GPT2LMHeadModel.from_pretrained(model_name)
    tokenizer = GPT2Tokenizer.from_pretrained(model_name)

    inputs = tokenizer(text, return_tensors="pt")

    with torch.no_grad():
        outputs = model(**inputs, labels=inputs["input_ids"])
        loss = outputs.loss

    perplexity = torch.exp(loss).item()
    return perplexity

# Example
ppl = compute_perplexity("Paris is the capital of France")  # Low (fluent)
ppl2 = compute_perplexity("Capital France the is Paris of")  # High (awkward)
```

---

## Part 3: LLM-as-Judge Evaluation

### Pattern 1: Rubric-Based Scoring

```python
from openai import OpenAI

client = OpenAI()

EVALUATION_PROMPT = """
You are an expert evaluator. Score the assistant's response on a scale of 1-5 for each criterion:

**Criteria:**
1. **Accuracy**: Is the information factually correct?
2. **Completeness**: Does it fully answer the question?
3. **Clarity**: Is it easy to understand?
4. **Conciseness**: Is it appropriately brief?

**Response to evaluate:**
{response}

**Expected answer (reference):**
{expected}

Provide scores in JSON format:
{{
  "accuracy": <1-5>,
  "completeness": <1-5>,
  "clarity": <1-5>,
  "conciseness": <1-5>,
  "reasoning": "Brief explanation"
}}
"""

def llm_judge_score(response: str, expected: str) -> dict:
    """
    Use GPT-4 as judge with rubric scoring.

    Pros: Flexible, nuanced, scales well
    Cons: Costs $, potential bias, slower
    """
    prompt = EVALUATION_PROMPT.format(response=response, expected=expected)

    completion = client.chat.completions.create(
        model="gpt-4",
        messages=[{"role": "user", "content": prompt}],
        response_format={"type": "json_object"}
    )

    import json
    scores = json.loads(completion.choices[0].message.content)
    return scores

# Example
scores = llm_judge_score(
    response="Paris is the capital of France, located in the north-central part of the country.",
    expected="Paris"
)
# {'accuracy': 5, 'completeness': 5, 'clarity': 5, 'conciseness': 3, 'reasoning': '...'}
```

### Pattern 2: Binary Pass/Fail Evaluation

```python
PASS_FAIL_PROMPT = """
Evaluate if the assistant's response is acceptable.

**Question:** {question}
**Response:** {response}
**Criteria:** {criteria}

Return ONLY "PASS" or "FAIL" followed by a one-sentence reason.
"""

def binary_eval(question: str, response: str, criteria: str) -> tuple[bool, str]:
    """
    Simple pass/fail evaluation.

    Use for: Unit tests, regression tests, CI/CD
    """
    prompt = PASS_FAIL_PROMPT.format(
        question=question,
        response=response,
        criteria=criteria
    )

    completion = client.chat.completions.create(
        model="gpt-4",
        messages=[{"role": "user", "content": prompt}],
        temperature=0.0  # Deterministic
    )

    result = completion.choices[0].message.content
    passed = result.startswith("PASS")
    reason = result.split(":", 1)[1].strip() if ":" in result else result

    return passed, reason

# Example
passed, reason = binary_eval(
    question="What is the capital of France?",
    response="The capital is Paris",
    criteria="Response must mention Paris"
)
# (True, "Response correctly identifies Paris as the capital")
```

### Pattern 3: Pairwise Comparison (A/B Testing)

```python
PAIRWISE_PROMPT = """
Compare two responses to the same question. Which is better?

**Question:** {question}

**Response A:**
{response_a}

**Response B:**
{response_b}

**Criteria:** {criteria}

Return ONLY: "A", "B", or "TIE", followed by a one-sentence explanation.
"""

def pairwise_comparison(
    question: str,
    response_a: str,
    response_b: str,
    criteria: str = "Overall quality, accuracy, and helpfulness"
) -> tuple[str, str]:
    """
    A/B test two responses.

    Use for: Prompt engineering, model comparison
    """
    prompt = PAIRWISE_PROMPT.format(
        question=question,
        response_a=response_a,
        response_b=response_b,
        criteria=criteria
    )

    completion = client.chat.completions.create(
        model="gpt-4",
        messages=[{"role": "user", "content": prompt}],
        temperature=0.0
    )

    result = completion.choices[0].message.content
    winner = result.split()[0]  # "A", "B", or "TIE"
    reason = result.split(":", 1)[1].strip() if ":" in result else result

    return winner, reason

# Example
winner, reason = pairwise_comparison(
    question="Explain quantum computing",
    response_a="Quantum computers use qubits instead of bits...",
    response_b="Quantum computing is complex. It uses quantum mechanics."
)
# ("A", "Response A provides more detail and explanation")
```

---

## Part 4: Hallucination Detection

### Method 1: Grounding Check

```python
def check_grounding(response: str, context: str) -> dict:
    """
    Verify response is grounded in provided context.

    Critical for RAG systems.
    """
    GROUNDING_PROMPT = """
    Context: {context}

    Response: {response}

    Is the response fully supported by the context? Answer with:
    - "GROUNDED": All claims supported
    - "PARTIALLY_GROUNDED": Some claims unsupported
    - "NOT_GROUNDED": Contains unsupported claims

    List any unsupported claims.
    """

    prompt = GROUNDING_PROMPT.format(context=context, response=response)

    completion = client.chat.completions.create(
        model="gpt-4",
        messages=[{"role": "user", "content": prompt}]
    )

    result = completion.choices[0].message.content
    status = result.split("\n")[0]
    unsupported = [line for line in result.split("\n")[1:] if line.strip()]

    return {
        'grounding_status': status,
        'unsupported_claims': unsupported,
        'is_hallucination': status != "GROUNDED"
    }
```

### Method 2: Factuality Check (External Verification)

```python
def check_factuality(claim: str, use_search: bool = True) -> dict:
    """
    Verify factual claims using external sources.

    Options:
    1. Web search + verification
    2. Knowledge base lookup
    3. Cross-reference with trusted source
    """
    if use_search:
        # Use web search to verify
        from tavily import TavilyClient
        tavily = TavilyClient(api_key="your-key")

        # Search for evidence
        results = tavily.search(claim, max_results=3)

        # Ask LLM to verify based on search results
        VERIFY_PROMPT = """
        Claim: {claim}

        Search results:
        {results}

        Is the claim supported by these sources? Answer: TRUE, FALSE, or UNCERTAIN.
        Explanation:
        """

        prompt = VERIFY_PROMPT.format(
            claim=claim,
            results="\n\n".join([r['content'] for r in results])
        )

        completion = client.chat.completions.create(
            model="gpt-4",
            messages=[{"role": "user", "content": prompt}]
        )

        result = completion.choices[0].message.content
        is_factual = result.startswith("TRUE")

        return {
            'claim': claim,
            'factual': is_factual,
            'evidence': results,
            'explanation': result
        }
```

### Method 3: Self-Consistency Check

```python
def self_consistency_check(question: str, num_samples: int = 5) -> dict:
    """
    Generate multiple responses, check for consistency.

    If model is confident, responses should be consistent.
    Inconsistency suggests hallucination risk.
    """
    responses = []

    for _ in range(num_samples):
        completion = client.chat.completions.create(
            model="gpt-4",
            messages=[{"role": "user", "content": question}],
            temperature=0.7  # Some randomness
        )
        responses.append(completion.choices[0].message.content)

    # Compute pairwise similarity
    from sklearn.feature_extraction.text import TfidfVectorizer
    from sklearn.metrics.pairwise import cosine_similarity

    vectorizer = TfidfVectorizer()
    vectors = vectorizer.fit_transform(responses)
    similarities = cosine_similarity(vectors)

    # Average pairwise similarity
    avg_similarity = similarities.sum() / (len(responses) * (len(responses) - 1))

    return {
        'responses': responses,
        'avg_similarity': avg_similarity,
        'is_consistent': avg_similarity > 0.7,  # Threshold
        'confidence': 'high' if avg_similarity > 0.85 else 'medium' if avg_similarity > 0.7 else 'low'
    }
```

---

## Part 5: RAG-Specific Evaluation

### Retrieval Quality Metrics

```python
def evaluate_retrieval(query: str, retrieved_docs: List[dict], relevant_doc_ids: List[str]) -> dict:
    """
    Evaluate retrieval quality using IR metrics.

    Precision: What % of retrieved docs are relevant?
    Recall: What % of relevant docs were retrieved?
    MRR: Mean Reciprocal Rank
    NDCG: Normalized Discounted Cumulative Gain
    """
    retrieved_ids = [doc['id'] for doc in retrieved_docs]

    # Precision
    true_positives = len(set(retrieved_ids) & set(relevant_doc_ids))
    precision = true_positives / len(retrieved_ids) if retrieved_ids else 0.0

    # Recall
    recall = true_positives / len(relevant_doc_ids) if relevant_doc_ids else 0.0

    # F1
    f1 = 2 * (precision * recall) / (precision + recall) if (precision + recall) > 0 else 0.0

    # MRR (Mean Reciprocal Rank)
    mrr = 0.0
    for i, doc_id in enumerate(retrieved_ids, 1):
        if doc_id in relevant_doc_ids:
            mrr = 1.0 / i
            break

    return {
        'precision': precision,
        'recall': recall,
        'f1': f1,
        'mrr': mrr,
        'num_retrieved': len(retrieved_ids),
        'num_relevant_retrieved': true_positives
    }
```

### End-to-End RAG Evaluation

```python
def evaluate_rag_pipeline(
    question: str,
    generated_answer: str,
    retrieved_docs: List[dict],
    ground_truth: str,
    relevant_doc_ids: List[str]
) -> dict:
    """
    Comprehensive RAG evaluation.

    1. Retrieval quality (precision, recall)
    2. Answer quality (ROUGE, BERTScore)
    3. Answer grounding (hallucination check)
    4. Citation accuracy
    """
    # 1. Retrieval metrics
    retrieval_scores = evaluate_retrieval(question, retrieved_docs, relevant_doc_ids)

    # 2. Answer quality
    context = "\n\n".join([doc['text'] for doc in retrieved_docs])

    rouge_scores = compute_rouge(generated_answer, ground_truth)
    bert_scores = compute_bertscore([generated_answer], [ground_truth])

    # 3. Grounding check
    grounding = check_grounding(generated_answer, context)

    # 4. LLM-as-judge overall quality
    judge_scores = llm_judge_score(generated_answer, ground_truth)

    return {
        'retrieval': retrieval_scores,
        'answer_quality': {
            'rouge': rouge_scores,
            'bertscore': bert_scores
        },
        'grounding': grounding,
        'llm_judge': judge_scores,
        'overall_pass': (
            retrieval_scores['f1'] > 0.5 and
            grounding['grounding_status'] == "GROUNDED" and
            judge_scores['accuracy'] >= 4
        )
    }
```

---

## Part 6: Prompt Testing Frameworks

### Framework 1: Regression Test Suite

```python
class PromptTestSuite:
    """
    Unit tests for prompts (like pytest for LLMs).
    """

    def __init__(self):
        self.tests = []
        self.results = []

    def add_test(self, name: str, input: str, criteria: str):
        """Add a test case."""
        self.tests.append({
            'name': name,
            'input': input,
            'criteria': criteria
        })

    def run(self, generate_fn):
        """Run all tests with given generation function."""
        for test in self.tests:
            response = generate_fn(test['input'])
            passed, reason = binary_eval(
                question=test['input'],
                response=response,
                criteria=test['criteria']
            )

            self.results.append({
                'test_name': test['name'],
                'passed': passed,
                'reason': reason,
                'response': response
            })

        return self.results

    def summary(self) -> dict:
        """Get test summary."""
        total = len(self.results)
        passed = sum(1 for r in self.results if r['passed'])

        return {
            'total_tests': total,
            'passed': passed,
            'failed': total - passed,
            'pass_rate': passed / total if total > 0 else 0.0
        }

# Usage
suite = PromptTestSuite()
suite.add_test("capital_france", "What is the capital of France?", "Must mention Paris")
suite.add_test("capital_germany", "What is the capital of Germany?", "Must mention Berlin")

def my_generate(prompt):
    # Your LLM call
    return client.chat.completions.create(
        model="gpt-4",
        messages=[{"role": "user", "content": prompt}]
    ).choices[0].message.content

results = suite.run(my_generate)
print(suite.summary())
# {'total_tests': 2, 'passed': 2, 'failed': 0, 'pass_rate': 1.0}
```

### Framework 2: A/B Testing Framework

```python
class ABTest:
    """
    A/B test prompts or models.
    """

    def __init__(self, test_cases: List[dict]):
        self.test_cases = test_cases
        self.results = []

    def run(self, generate_a, generate_b):
        """Compare two generation functions."""
        for test in self.test_cases:
            response_a = generate_a(test['input'])
            response_b = generate_b(test['input'])

            winner, reason = pairwise_comparison(
                question=test['input'],
                response_a=response_a,
                response_b=response_b
            )

            self.results.append({
                'input': test['input'],
                'response_a': response_a,
                'response_b': response_b,
                'winner': winner,
                'reason': reason
            })

        return self.results

    def summary(self) -> dict:
        """Aggregate results."""
        total = len(self.results)
        a_wins = sum(1 for r in self.results if r['winner'] == 'A')
        b_wins = sum(1 for r in self.results if r['winner'] == 'B')
        ties = sum(1 for r in self.results if r['winner'] == 'TIE')

        return {
            'total_comparisons': total,
            'a_wins': a_wins,
            'b_wins': b_wins,
            'ties': ties,
            'a_win_rate': a_wins / total if total > 0 else 0.0,
            'statistical_significance': self._check_significance(a_wins, b_wins, total)
        }

    def _check_significance(self, a_wins, b_wins, total):
        """Simple binomial test for statistical significance."""
        from scipy.stats import binom_test
        # H0: Both equally good (p=0.5)
        p_value = binom_test(max(a_wins, b_wins), total, 0.5)
        return p_value < 0.05  # Significant at 95% confidence
```

---

## Part 7: Production Monitoring

### Continuous Evaluation Pipeline

```python
import logging
from datetime import datetime

class ProductionMonitor:
    """
    Monitor LLM performance in production.
    """

    def __init__(self, sample_rate: float = 0.1):
        self.sample_rate = sample_rate
        self.metrics = []
        self.logger = logging.getLogger(__name__)

    def log_interaction(self, user_input: str, model_output: str, metadata: dict):
        """Log interaction for evaluation."""
        import random

        # Sample traffic for evaluation
        if random.random() < self.sample_rate:
            # Run automated checks
            toxicity = self._check_toxicity(model_output)
            perplexity = compute_perplexity(model_output)

            metric = {
                'timestamp': datetime.now().isoformat(),
                'user_input': user_input,
                'model_output': model_output,
                'toxicity_score': toxicity,
                'perplexity': perplexity,
                'latency_ms': metadata.get('latency_ms'),
                'model_version': metadata.get('model_version')
            }

            self.metrics.append(metric)

            # Alert if anomaly detected
            if toxicity > 0.5:
                self.logger.warning(f"High toxicity detected: {toxicity}")

    def _check_toxicity(self, text: str) -> float:
        """Check for toxic content."""
        from detoxify import Detoxify
        model = Detoxify('original')
        results = model.predict(text)
        return max(results.values())  # Max toxicity score

    def get_metrics(self) -> dict:
        """Aggregate metrics."""
        if not self.metrics:
            return {}

        return {
            'total_interactions': len(self.metrics),
            'avg_toxicity': sum(m['toxicity_score'] for m in self.metrics) / len(self.metrics),
            'avg_perplexity': sum(m['perplexity'] for m in self.metrics) / len(self.metrics),
            'avg_latency_ms': sum(m['latency_ms'] for m in self.metrics if m.get('latency_ms')) / len(self.metrics),
            'high_toxicity_rate': sum(1 for m in self.metrics if m['toxicity_score'] > 0.5) / len(self.metrics)
        }
```

---

## Part 8: Best Practices

### Practice 1: Layered Evaluation Strategy

```python
# Layer 1: Fast, cheap automated checks
def quick_checks(response: str) -> bool:
    """Run fast automated checks."""
    # Length check
    if len(response) < 10:
        return False

    # Toxicity check
    if check_toxicity(response) > 0.5:
        return False

    # Basic coherence (perplexity)
    if compute_perplexity(response) > 100:
        return False

    return True

# Layer 2: LLM-as-judge (selective)
def llm_evaluation(response: str, criteria: str) -> float:
    """Run LLM evaluation on subset."""
    scores = llm_judge_score(response, criteria)
    return sum(scores.values()) / len(scores)  # Average score

# Layer 3: Human review (expensive, critical cases)
def flag_for_human_review(response: str, confidence: float) -> bool:
    """Determine if human review needed."""
    return (
        confidence < 0.7 or
        len(response) > 1000 or  # Long responses
        "uncertain" in response.lower()  # Model uncertainty
    )

# Combined pipeline
def evaluate_response(question: str, response: str) -> dict:
    # Layer 1: Quick checks
    if not quick_checks(response):
        return {'status': 'failed_quick_checks', 'human_review': False}

    # Layer 2: LLM judge
    score = llm_evaluation(response, "accuracy and helpfulness")
    confidence = score / 5.0

    # Layer 3: Human review decision
    needs_human = flag_for_human_review(response, confidence)

    return {
        'status': 'passed' if score >= 3.5 else 'failed',
        'score': score,
        'confidence': confidence,
        'human_review': needs_human
    }
```

### Practice 2: Version Your Prompts

```python
from typing import Dict
import hashlib

class PromptVersion:
    """Track prompt versions for A/B testing and rollback."""

    def __init__(self):
        self.versions = {}
        self.active_version = None

    def register(self, name: str, prompt_template: str, metadata: dict = None):
        """Register a prompt version."""
        version_id = hashlib.md5(prompt_template.encode()).hexdigest()[:8]

        self.versions[version_id] = {
            'name': name,
            'template': prompt_template,
            'metadata': metadata or {},
            'created_at': datetime.now(),
            'metrics': {'total_uses': 0, 'avg_score': 0.0}
        }

        return version_id

    def use(self, version_id: str, **kwargs) -> str:
        """Use a specific prompt version."""
        if version_id not in self.versions:
            raise ValueError(f"Unknown version: {version_id}")

        version = self.versions[version_id]
        version['metrics']['total_uses'] += 1

        return version['template'].format(**kwargs)

    def update_metrics(self, version_id: str, score: float):
        """Update performance metrics for a version."""
        version = self.versions[version_id]
        current_avg = version['metrics']['avg_score']
        total_uses = version['metrics']['total_uses']

        # Running average
        new_avg = ((current_avg * (total_uses - 1)) + score) / total_uses
        version['metrics']['avg_score'] = new_avg

# Usage
pm = PromptVersion()

v1 = pm.register(
    name="question_answering_v1",
    prompt_template="Answer this question: {question}",
    metadata={'author': 'alice', 'date': '2024-01-01'}
)

v2 = pm.register(
    name="question_answering_v2",
    prompt_template="You are a helpful assistant. Answer: {question}",
    metadata={'author': 'bob', 'date': '2024-01-15'}
)

# A/B test
prompt = pm.use(v1, question="What is AI?")  # 50% traffic
score = llm_evaluation(response, criteria)
pm.update_metrics(v1, score)
```

---

## Quick Decision Trees

### "Which evaluation method should I use?"

```
Have ground truth labels?
  YES → ROUGE, BERTScore, Exact Match
  NO  → LLM-as-judge, Human review

Evaluating factual correctness?
  YES → Grounding check, Factuality verification
  NO  → Subjective quality → LLM-as-judge

Need fast feedback (CI/CD)?
  YES → Binary pass/fail tests
  NO  → Comprehensive multi-metric evaluation

Budget constraints?
  Tight → Automated metrics only
  Moderate → LLM-as-judge + sampling
  No limit → Human review gold standard
```

### "How to detect hallucinations?"

```
Have source documents (RAG)?
  YES → Grounding check against context
  NO  → Continue

Can verify with search?
  YES → Factuality check with web search
  NO  → Continue

Check model confidence?
  YES → Self-consistency check (multiple samples)
  NO  → Flag for human review
```

---

## Resources

- **ROUGE:** https://github.com/google-research/google-research/tree/master/rouge
- **BERTScore:** https://github.com/Tiiiger/bert_score
- **OpenAI Evals:** https://github.com/openai/evals
- **LangChain Evaluation:** https://python.langchain.com/docs/guides/evaluation/
- **Ragas (RAG eval):** https://github.com/explodinggradients/ragas

---

**Skill version:** 1.0.0
**Last updated:** 2025-10-25
**Maintained by:** Applied Artificial Intelligence
