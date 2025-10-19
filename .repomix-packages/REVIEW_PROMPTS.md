# LLM Review Prompts for Claude Code Plugins

These prompts are designed for reviewers to paste into their preferred LLM (Claude, ChatGPT, Gemini, etc.) along with the corresponding RepoMix package for efficient, AI-assisted review.

---

## Prompt 1: Quick Start Package Review (15-30 minutes)

**Package**: `quickstart-package.md`
**Target**: Developers evaluating if this fits their workflow
**Time**: 15-30 minutes

### Review Prompt

```
I'm reviewing a plugin framework for Claude Code called "claude-code-plugins" to see if it would improve my AI-assisted development workflow.

I've attached a Quick Start package (56K tokens) that includes:
- Project overview
- Quick start guide
- 3 example plugins (beginner to advanced)
- Core plugin with 14 commands

Please analyze this package and provide:

1. **First Impressions** (2 minutes)
   - What problem does this solve?
   - Is the value proposition clear?
   - Would I use this? Why or why not?

2. **Onboarding Assessment** (5 minutes)
   - How long would it take me to get started?
   - Is the installation clear?
   - Are the examples helpful?
   - Any confusing parts?

3. **Example Plugin Analysis** (10 minutes)
   - Analyze the 3 example plugins (hello-world, task-tracker, code-formatter)
   - Do they demonstrate progressive complexity well?
   - Are they realistic use cases?
   - Could I build my own plugin based on these examples?

4. **Quick Decision** (5 minutes)
   - ⭐ Rate overall quality (1-5 stars)
   - ✅ Recommend to colleagues? (Yes/Maybe/No)
   - 🚀 Would use in my workflow? (Yes/Maybe/No)
   - 💡 Top 3 improvements needed before launch

5. **One-Sentence Summary**
   - If you had to describe this to a colleague in one sentence, what would you say?

Please be honest and critical - I need real feedback, not politeness.

[PASTE quickstart-package.md CONTENT HERE]
```

---

## Prompt 2: Documentation Package Review (2-3 hours)

**Package**: `documentation-package.md`
**Target**: Technical reviewers and architects
**Time**: 2-3 hours

### Review Prompt

```
I'm conducting a technical review of "claude-code-plugins" - an open-source plugin framework for Claude Code. This is a pre-launch review to identify critical issues before public release.

I've attached a comprehensive Documentation package (91K tokens) that includes:
- Complete architecture documentation
- Design principles and patterns
- All 5 production plugin specifications
- Framework constraints

As an experienced software architect/engineer, please provide a thorough technical assessment:

## 1. Architecture Analysis (30 minutes)

**Design Principles** (docs/architecture/design-principles.md):
- Are the stated design principles sound?
- Any architectural red flags?
- Is the stateless execution model the right choice?
- File-based persistence - appropriate or limitation?

**Framework Patterns** (docs/architecture/patterns.md):
- Are the patterns well-designed?
- Any anti-patterns present?
- Is extensibility properly supported?
- Template system - elegant or over-engineered?

**System Constraints** (docs/architecture/constraints.md):
- Are constraints clearly documented?
- Any show-stoppers for adoption?
- MCP integration - properly abstracted?
- Security considerations adequate?

## 2. Plugin Design Review (45 minutes)

Analyze each of the 5 production plugins:

**Core Plugin** (14 commands):
- Command design quality
- Naming conventions clear?
- Feature completeness
- Any missing critical features?

**Workflow Plugin** (explore → plan → next → ship):
- Is this workflow practical?
- Does it solve real problems?
- Any workflow gaps?

**Development Plugin** (analyze, test, fix, run, review):
- Useful command set?
- Any redundancy or overlap?
- Missing essential dev tools?

**Git Plugin**:
- Safe commit approach - too cautious or appropriate?
- Integration with workflow - smooth or clunky?

**Memory Plugin**:
- Memory management - clever or complex?
- Garbage collection - automated enough?

## 3. Documentation Quality (30 minutes)

- **Clarity**: Is documentation clear and understandable?
- **Completeness**: Any critical gaps?
- **Examples**: Are examples helpful and realistic?
- **Onboarding**: Can a new user get productive quickly?
- **Reference**: Is reference documentation comprehensive?

## 4. Critical Issues Identification (20 minutes)

Identify issues by severity:

**BLOCKER** (Must fix before launch):
- [List any blocking issues]

**CRITICAL** (Should fix before launch):
- [List critical issues]

**MAJOR** (Fix soon after launch):
- [List major issues]

**MINOR** (Nice to have):
- [List minor issues]

## 5. Competitive Analysis (15 minutes)

How does this compare to:
- Raw Claude Code (what's the value-add?)
- Other AI coding assistants (Cursor, Aider, etc.)
- Traditional IDE workflows

What's unique? What's missing?

## 6. Adoption Assessment (10 minutes)

**Barriers to Adoption**:
- What would prevent teams from using this?
- Learning curve too steep?
- Integration friction?
- Documentation gaps?

**Enablers**:
- What makes this compelling?
- Clear differentiation?
- Strong use cases?

## 7. Overall Technical Rating

Rate each dimension (1-5 stars):
- Architecture Design: ⭐⭐⭐⭐⭐
- Code Quality: ⭐⭐⭐⭐⭐
- Documentation: ⭐⭐⭐⭐⭐
- Extensibility: ⭐⭐⭐⭐⭐
- Production Readiness: ⭐⭐⭐⭐⭐

**Overall Recommendation**:
- [ ] Ready for launch
- [ ] Ready with minor fixes
- [ ] Needs significant work
- [ ] Not ready - major concerns

## 8. Detailed Feedback

Provide any additional insights, concerns, or recommendations.

Please be thorough and critical - this is a pre-launch technical review. I need honest assessment, not validation.

[PASTE documentation-package.md CONTENT HERE]
```

---

## Prompt 3: Developer Package Review (3-4 hours)

**Package**: `developer-package.md`
**Target**: Contributors and deep-dive code reviewers
**Time**: 3-4 hours

### Review Prompt

```
I'm conducting a comprehensive code review of "claude-code-plugins" before public open-source launch. This is the complete source code review.

I've attached the Developer package (210K tokens) containing:
- Full source code for all 5 plugins (30 commands, 5 agents)
- All 3 example plugins with implementation
- Architecture documentation
- Automation scripts

As an experienced developer, please conduct a thorough code review:

## 1. Code Quality Analysis (60 minutes)

**Overall Code Quality**:
- Code organization and structure
- Naming conventions consistency
- Code clarity and readability
- DRY principle adherence
- SOLID principles application

**Specific Code Review**:
For each plugin, analyze:
- Command implementations (commands/*.md)
- Agent implementations (agents/*.md)
- Plugin manifest (plugin.json)

**Code Smells**:
- Identify any code smells
- Complexity hotspots
- Potential bugs
- Edge cases not handled
- Error handling gaps

## 2. Implementation Patterns (45 minutes)

**Template System**:
- Is markdown + variable substitution the right approach?
- Template quality and consistency
- Extensibility of template system

**Stateless Execution**:
- How well is statelessness maintained?
- Any hidden state leaks?
- Is duplication justified? (WHY_DUPLICATION_EXISTS.md)

**File-Based Persistence**:
- JSON state management quality
- File operation safety
- Atomic operations where needed?

**Error Handling**:
- Consistent error handling?
- Graceful degradation?
- User-friendly error messages?

## 3. Testing & Quality (30 minutes)

**Test Coverage**:
- Are there tests? (if visible in package)
- Critical paths covered?
- Edge cases tested?

**Quality Automation**:
- Validation patterns used?
- Safe commit implementation
- Hook system design

**Documentation**:
- Code comments appropriate?
- Self-documenting code?
- API documentation quality?

## 4. Security Review (30 minutes)

**Security Concerns**:
- Command injection risks?
- File system safety?
- Git operation safety?
- Secrets handling?
- Dependency security?

**Access Control**:
- Appropriate permission checks?
- Safe defaults?

## 5. Performance Analysis (20 minutes)

**Performance Considerations**:
- Token efficiency (important for LLM context)
- File I/O optimization
- Unnecessary complexity?

**Scalability**:
- Can this scale to large projects?
- Performance bottlenecks?

## 6. Extensibility & Maintenance (30 minutes)

**Plugin Architecture**:
- Easy to add new plugins?
- Clear plugin API?
- Good separation of concerns?

**Maintainability**:
- Code easy to modify?
- Clear dependencies?
- Versioning strategy?
- Breaking change handling?

**Contribution Readiness**:
- Easy for contributors to understand?
- Clear contribution path?
- Good code examples?

## 7. Example Plugin Analysis (30 minutes)

Review the 3 example plugins:

**hello-world**:
- Good starter example?
- Teaches fundamentals?

**task-tracker**:
- Demonstrates intermediate patterns?
- Realistic use case?

**code-formatter**:
- Shows advanced integration?
- Production-quality example?

## 8. Automation Scripts (20 minutes)

**sync-from-private.sh**:
- Script quality
- Safety considerations
- Error handling

**generate-commands-reference.py**:
- Implementation quality
- Robustness

## 9. Critical Code Issues

Categorize by severity:

**CRITICAL** (Security, data loss, breaking):
- [List critical code issues]

**HIGH** (Bugs, poor error handling):
- [List high priority issues]

**MEDIUM** (Code quality, refactoring):
- [List medium priority issues]

**LOW** (Style, minor improvements):
- [List low priority issues]

## 10. Contribution Assessment

**Would you contribute to this project?**
- [ ] Yes - excited to contribute
- [ ] Maybe - depends on roadmap
- [ ] No - concerns about codebase

**Why or why not?**

## 11. Code Quality Ratings

Rate each dimension (1-5 stars):
- Code Organization: ⭐⭐⭐⭐⭐
- Code Quality: ⭐⭐⭐⭐⭐
- Error Handling: ⭐⭐⭐⭐⭐
- Security: ⭐⭐⭐⭐⭐
- Maintainability: ⭐⭐⭐⭐⭐
- Documentation: ⭐⭐⭐⭐⭐

**Overall Code Quality**: ⭐⭐⭐⭐⭐ / 5

## 12. Launch Recommendation

Based on code review:
- [ ] Code ready for launch
- [ ] Ready with minor fixes (list required fixes)
- [ ] Needs refactoring (list areas)
- [ ] Not ready - major code quality concerns

## 13. Detailed Findings

Please provide comprehensive feedback on:
- Specific code improvements needed
- Refactoring suggestions
- Best practices violations
- Clever implementations worth highlighting
- Any other insights

Be thorough and critical - I need honest code review before public launch.

[PASTE developer-package.md CONTENT HERE]
```

---

## Prompt 4: Market/UX Package Review (Hybrid)

**Packages**: `quickstart-package.md` + `documentation-package.md`
**Target**: Product managers, UX designers, technical writers
**Time**: 2-3 hours

### Review Prompt

```
I'm reviewing "claude-code-plugins" from a product and user experience perspective before open-source launch.

I've attached two packages:
1. Quick Start package (56K tokens) - user onboarding
2. Documentation package (91K tokens) - complete docs

Please analyze from a product/UX lens:

## 1. Value Proposition Analysis (20 minutes)

**Clarity**:
- Is the problem clearly stated?
- Is the solution obvious?
- Target audience well-defined?

**Positioning**:
- How does this position vs. competitors?
- Unique value clear?
- Differentiation strong?

**Messaging**:
- Tagline effective? ("From Chaos to System")
- Key messages resonate?
- Tone appropriate for audience?

## 2. User Journey Analysis (45 minutes)

**Discovery**:
- Would a user find this when searching for solutions?
- Is it clear what this does from README?
- First impression strong?

**Onboarding**:
- Time to first value?
- Installation friction?
- Learning curve appropriate?
- Help available when stuck?

**Activation**:
- First workflow (explore → plan → next → ship) intuitive?
- Examples relevant to real work?
- Success criteria clear?

**Retention**:
- Reason to keep using?
- Value grows over time?
- Network effects or lock-in?

## 3. Documentation Quality (40 minutes)

**Getting Started Docs**:
- Clear and concise?
- Right level of detail?
- Visual aids needed?
- Common pitfalls addressed?

**Architecture Docs**:
- Accessible to target audience?
- Too technical or just right?
- Diagrams needed?

**Reference Docs**:
- Easy to find what you need?
- Examples sufficient?
- API documentation clear?

**Content Gaps**:
- What's missing?
- What's over-documented?
- Redundancy issues?

## 4. User Experience Assessment (30 minutes)

**Command UX**:
- Command names intuitive?
- Workflow logical?
- Error messages helpful?
- Feedback appropriate?

**Plugin Discovery**:
- Easy to find right plugin?
- Descriptions clear?
- Examples helpful?

**Customization**:
- Configuration approachable?
- Extension path clear?
- Examples of customization?

## 5. Target Audience Fit (20 minutes)

**Who is this for?**
- Individual developers?
- Teams?
- Enterprises?
- Open source contributors?

**Audience Alignment**:
- Content matches audience needs?
- Language appropriate?
- Assumptions correct?

**Persona Validation**:
- Clear user personas?
- Content addresses their pain points?

## 6. Competitive Analysis (25 minutes)

**Alternatives**:
- What would users use instead?
- Why would they choose this?
- What would make them stay?

**Feature Comparison**:
- Feature parity with competitors?
- Unique features?
- Missing features?

**Positioning**:
- Clear differentiation?
- Compelling reasons to switch?

## 7. Go-to-Market Readiness (20 minutes)

**Launch Materials**:
- README effective as launch page?
- Demo/video needed?
- Screenshots/visuals needed?

**Community Building**:
- Clear contribution path?
- Community engagement strategy?
- Support channels adequate?

**Marketing Assets**:
- Testimonials/case studies?
- Use case documentation?
- Comparison content?

## 8. User Feedback Prediction (15 minutes)

**Likely Positive Feedback**:
- What will users love?
- What solves real pain?

**Likely Concerns**:
- What will confuse users?
- What will frustrate users?
- What will block adoption?

## 9. Ratings & Metrics

Rate each dimension (1-5 stars):
- Value Proposition: ⭐⭐⭐⭐⭐
- Documentation Quality: ⭐⭐⭐⭐⭐
- User Experience: ⭐⭐⭐⭐⭐
- Onboarding: ⭐⭐⭐⭐⭐
- Product-Market Fit: ⭐⭐⭐⭐⭐

**Net Promoter Score Prediction**:
- How likely would users recommend this? (0-10)
- Reasoning?

## 10. Launch Recommendation

From product/UX perspective:
- [ ] Ready for launch
- [ ] Ready with UX improvements (list them)
- [ ] Needs significant UX work
- [ ] Product positioning unclear

## 11. Actionable Recommendations

Provide specific, prioritized recommendations:

**Pre-Launch (Must Do)**:
1. [Recommendation]
2. [Recommendation]
3. [Recommendation]

**Post-Launch (Should Do)**:
1. [Recommendation]
2. [Recommendation]
3. [Recommendation]

**Future Enhancements**:
1. [Recommendation]
2. [Recommendation]

## 12. Detailed UX Feedback

Any additional insights on user experience, positioning, or go-to-market strategy.

Be honest and user-focused - I need real UX insights, not cheerleading.

[PASTE quickstart-package.md CONTENT HERE]

[PASTE documentation-package.md CONTENT HERE]
```

---

## Usage Instructions for Reviewers

### Step 1: Choose Your Review Type
- **Quick evaluation** → Use Prompt 1 (15-30 min)
- **Technical review** → Use Prompt 2 (2-3 hours)
- **Code review** → Use Prompt 3 (3-4 hours)
- **Product/UX review** → Use Prompt 4 (2-3 hours)

### Step 2: Load Package into LLM
1. Open your preferred LLM (Claude, ChatGPT, Gemini, etc.)
2. Copy the entire package file content
3. Paste the review prompt
4. Paste the package content below the prompt
5. Submit

### Step 3: Save LLM Response
1. Copy the LLM's analysis
2. Save to a file or paste into feedback form
3. Share via GitHub Discussion, Google Form, or email

### Tips for Best Results

**For Claude**:
- Use Claude 3.5 Sonnet or better
- Enable Projects for better context
- Review can be done in one session

**For ChatGPT**:
- Use GPT-4 or better
- May need to split large packages across multiple messages
- Save conversation for reference

**For Gemini**:
- Use Gemini 1.5 Pro for large context
- Can handle full packages in one go
- Export conversation when done

**General Tips**:
- Read the LLM's analysis carefully
- Ask follow-up questions for clarity
- Request specific examples for vague feedback
- Have LLM rate severity of issues (Critical/High/Medium/Low)

---

## Post-Review Actions

After getting LLM analysis:

1. **Extract Key Findings**:
   - Critical issues (must fix)
   - High priority improvements
   - Medium priority enhancements
   - Low priority nice-to-haves

2. **Categorize Feedback**:
   - Architecture concerns
   - Code quality issues
   - Documentation gaps
   - UX improvements
   - Missing features

3. **Submit Feedback**:
   - GitHub Discussion (detailed technical feedback)
   - Google Form (quick ratings and summary)
   - Direct email (sensitive or detailed conversations)

4. **Optional: Human Validation**:
   - Review LLM's analysis
   - Add your own insights
   - Highlight what LLM might have missed
   - Disagree with LLM where appropriate

---

## Why LLM-Assisted Review?

**Efficiency**: 10x faster than manual review
**Thoroughness**: LLMs can analyze entire codebase systematically
**Consistency**: Same evaluation criteria across all reviews
**Scalability**: More reviewers can participate with less time investment
**Quality**: Deep analysis at speed of reading

**But Remember**: LLMs can miss nuance, context, and domain expertise. Your human judgment is the final filter.

---

**Questions about review process?**
- Open a GitHub Discussion
- Email: [contact info]
- Discord: [if available]

**Thank you for helping make claude-code-plugins better!**
