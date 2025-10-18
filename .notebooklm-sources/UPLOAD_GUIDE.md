# NotebookLM Upload & Generation Guide

Complete step-by-step instructions for generating demo audio using Google NotebookLM.

## What You'll Create

**Primary Deliverable:** 10-minute AI-hosted podcast introducing Claude Code Plugins
**Format:** MP3 audio file with natural conversation between two AI hosts
**Use Cases:**
- Standalone podcast episode for documentation site
- Audio base for creating demo video (+ slides)
- Social media highlight clips

---

## Step 1: Access NotebookLM

1. Go to **https://notebooklm.google.com/**
2. Sign in with your Google account
3. Click **"+ Create New Notebook"**
4. Name it: **"Claude Code Plugins Demo"**

---

## Step 2: Upload Documentation Sources

Upload these **8 files** in order (numbering ensures proper context flow):

### Core Documentation (6 files)
1. `01_value_proposition.md` - Main project README
2. `02_installation_guide.md` - Getting started instructions
3. `03_quick_start.md` - First workflow walkthrough
4. `04_design_principles.md` - Technical architecture
5. `05_core_plugin.md` - Core plugin capabilities
6. `06_workflow_plugin.md` - Workflow commands

### Demo Guides (2 files)
7. `07_demo_script_guide.md` - **CRITICAL** - Narrative structure for AI hosts
8. `08_glossary.md` - Technical term definitions

**How to Upload:**
- Click **"+ Add Source"** button
- Select **"Upload"** → **"Document"**
- Choose file from your system
- Wait for processing (green checkmark appears)
- Repeat for all 8 files

**Note:** NotebookLM supports up to 50 sources, so 8 is well within limits.

---

## Step 3: Customize Audio Generation

After all sources upload, you'll see an **"Audio Overview"** option.

### Click "Generate Audio Overview"

A dialog will appear with options:

**Background Information (IMPORTANT!):**
Paste this exact text to guide the AI hosts:

```
Create an engaging 10-minute introduction to Claude Code Plugins for software developers. This is a demo/tutorial, not just a discussion.

TARGET AUDIENCE: Experienced software developers familiar with AI coding assistants (Claude, GitHub Copilot) who want better workflow structure.

STRUCTURE TO FOLLOW (see 07_demo_script_guide.md):
1. Problem Statement (2 min): Context management challenges in AI coding
2. Solution Overview (2 min): Plugin framework architecture
3. Quick Start Demo (3 min): Installation and first workflow (explore → plan → next → ship)
4. Advanced Features (2 min): MCP integration, memory management, Serena
5. Call to Action (1 min): How to get started and contribute

TONE: Conversational but technically accurate. Use specific examples from the documentation. Emphasize practical benefits over theory.

KEY TECHNICAL DETAILS (from 08_glossary.md):
- 30+ commands across 5 plugins
- MIT licensed, open source
- 70-90% token reduction with Serena MCP
- Stateless execution, file-based persistence
- GitHub: applied-artificial-intelligence/claude-code-plugins

CRITICAL: Follow the narrative arc in 07_demo_script_guide.md. This should sound like a demo walkthrough, not a general conversation.
```

**Focus (Optional but Recommended):**
```
Installation walkthrough, workflow demonstration, MCP integration benefits, practical developer use cases
```

---

## Step 4: Generate and Download Audio

1. Click **"Generate"** button
2. Wait 2-4 minutes for processing
3. Audio will appear with a play button
4. Listen to preview the content
5. If satisfied, click the **⋮** (three dots) menu
6. Select **"Download"** to save MP3 file

**Expected Output:**
- File name: `NotebookLM_AudioOverview_[timestamp].mp3`
- Duration: ~10 minutes
- Format: MP3, 128kbps
- Content: Two AI hosts discussing Claude Code Plugins

---

## Step 5: Quality Check

Before using the audio, verify:

### ✅ Content Accuracy Checklist
- [ ] Mentions all 5 plugin names (core, workflow, development, git, memory)
- [ ] Accurately describes the 4-phase workflow (explore → plan → next → ship)
- [ ] Correctly states 30+ commands total
- [ ] References MIT license and open source
- [ ] Mentions MCP tools (Serena, Sequential Thinking, Context7)
- [ ] Provides GitHub repository: applied-artificial-intelligence/claude-code-plugins
- [ ] Includes installation instructions
- [ ] Explains practical benefits (not just features)

### ✅ Audio Quality Checklist
- [ ] Clear audio, no distortion
- [ ] Natural conversation flow
- [ ] Good pacing (not too fast/slow)
- [ ] Technical terms pronounced correctly
- [ ] 10-minute target length (±1 minute acceptable)

### If Quality Issues Exist
- Regenerate audio with more specific focus instructions
- Adjust the "Background Information" to emphasize missing areas
- Can try multiple times until satisfied

---

## Step 6: Create Visual Companion (Next Step)

Once audio is downloaded, you'll create slides to accompany it.

See: **TASK-004d** for slide creation guide

**Quick Preview:**
1. Listen to audio, note timestamps for key moments
2. Create 8-10 slides with screenshots/diagrams
3. Match slides to audio narrative
4. Export as video or use for presentation

---

## Alternative: Multiple Versions

You can generate multiple audio versions for different purposes:

### Version 1: Full Demo (10 min)
- Use all 8 sources
- Focus: Complete introduction with installation and advanced features
- Use for: Documentation site, podcast distribution

### Version 2: Quick Intro (5 min)
- Use only: 01, 03, 06, 07
- Focus: "What is it and how do I start?"
- Use for: Social media, quick onboarding

### Version 3: Technical Deep Dive (15 min)
- Use all 8 + add architecture docs
- Focus: "How does it work under the hood?"
- Use for: Technical conference talks, deep learning

**Tip:** Create multiple notebooks for different versions rather than deleting sources.

---

## Troubleshooting

### "Audio generation failed"
- **Cause:** Source files too large or formatting issues
- **Fix:** Ensure markdown files are plain text, no exotic formatting

### "Audio doesn't follow script structure"
- **Cause:** Background instructions not specific enough
- **Fix:** Copy the exact background instructions from Step 3, emphasize "follow 07_demo_script_guide.md"

### "Technical terms incorrect"
- **Cause:** AI hosts hallucinating without context
- **Fix:** Ensure 08_glossary.md is uploaded and referenced in instructions

### "Audio too short/long"
- **Cause:** NotebookLM optimizes based on content density
- **Fix:** Can't directly control length, but more detailed sources = longer audio

---

## Next Steps After Audio Generation

1. ✅ Download MP3 file
2. Create slide deck with screenshots (TASK-004d)
3. Produce two deliverables:
   - **Full podcast**: Upload MP3 + show notes to docs site
   - **Highlight video**: Combine key audio clips with slides (2 min)
4. Commit all materials to repository
5. Update documentation with links to demo content

---

## Time Estimate

- **Upload sources**: 5 minutes
- **Configure generation**: 5 minutes
- **Audio generation**: 2-4 minutes (automatic)
- **Quality check**: 10 minutes (listen to audio)
- **Iterations (if needed)**: 15 minutes

**Total: 25-40 minutes** (vs 6-8 hours for traditional recording)

---

## Success Criteria

Audio generation succeeds when:
- ✅ 10-minute duration (±1 minute)
- ✅ Covers all 5 sections from demo script guide
- ✅ Technically accurate (all facts correct)
- ✅ Natural conversation flow (not robotic)
- ✅ Provides clear value proposition and call to action
- ✅ Ready to use without major editing

---

**Ready to proceed?** Follow Step 1 and upload your sources to NotebookLM!
