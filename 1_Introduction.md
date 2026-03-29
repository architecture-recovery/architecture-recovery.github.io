
IT University of Copenhagen


# Software Architecture Recovery: Introduction

Mircea Lungu

## Riddle

### What is the software artifact that you are not guaranteed to have, not even when paying 50B for a software company?

![](images/elon-musk-and-the-sink.png)

<details>
<summary>Answer</summary>
An up-to-date architectural diagram.
</details>

![](images/twitter_arch_recovered.png)
[link to original tweet](https://twitter.com/elonmusk/status/1593899029531803649)

Note: this diagram was *recovered by an outsider*, not produced by the company. Is it still accurate today?


## Many Situations Require Understanding a System's Architecture

- Onboarding on a new system
- Buying a software company
- Doing a PR review
- Having to do
	- an architectural evaluation
	- a risk assessment for security

Wouldn't it be good if you had an architectural diagram of the system that was up to date?


## Architectural Documentation Is Rarely Available or Up to Date

*2 min in pairs, then we collect answers*

### No
*Why is it missing?*
### Yes
*Is it up to date? How? Not? Why not?*



## Few Incentives and Inherent Difficulty Explain the Gap

### Few stakeholders prioritize architecture documentation
- Sometimes that's not a priority at all
	- You're a startup that needs to show that the idea is viable. You don't have time for anything else.
- Often there is no perceived value for the customer (or more likely, no clear immediate value)

### Creating and maintaining it is hard
- Traceability between architecture and code is not easy to establish
- It requires a better and more general understanding of the system than just coding — not everybody can do it
- Hard to maintain — especially when they are in .ppt or .png


## Even Existing Documentation Drifts from Reality

When architecture documentation *does* exist, it still goes out of date because developers make decisions and changes:
- that are not aligned with the original vision => **[architectural drift](https://youtu.be/hExflmcBSc4?t=14)**
- that go against prescriptive architecture => **[architectural erosion](https://youtu.be/hExflmcBSc4?t=70)**

### Erosion Example
![](images/adjacent_connector_.png)

*2 min in pairs:*
- What could be the cause of erosion here?
- Why would it be a problem?



## Three Approaches to Keeping Architecture Current

### Enforce constraints so code must match architecture

Specify the architecture, draw it, and then ensure that all new code conforms to it!

- Type systems — too low-level
- Special tools for defining architecture constraints
	- DSL - domain specific language (e.g. [Dictō](https://scg.unibe.ch/archive/papers/Cara14b-Dicto.pdf))
	- tools that take inspiration from unit testing (e.g. [ArchUnit](https://www.archunit.org/use-cases))
	- How to integrate these tools?
		- CI/CD
		- Pre-commit hooks
		- IDE
- Declarative architecture: docker compose, swarm stack specifications, infrastructure-as-code specifications, etc.

### Generate diagrams that evolve with the code
- A research direction that we work on here at ITU
- Not the focus of this course
- This course will however, give you the tools for implementing your own evolving diagrams

### Recover the architecture directly from code
- As opposed to *drawing them in Powerpoint*
- No great tools for this — often too much low-level noise
- **The focus of this course**



# Architecture Recovery Is Reverse Engineering at the Architectural Level

a.k.a. *architecture reconstruction* (the literature uses both; we use *recovery* in this course)

**(def.)** A reverse engineering approach that aims at recovering viable architectural views of a software application. [1]

Reverse engineering = analyzing a system to identify its components, their interrelationships, and create representations at a higher level of abstraction. [2]

[1] Ducasse & Pollet, [Software Architecture Reconstruction: a Process-Oriented Taxonomy](https://rmod.inria.fr/archives/papers/Duca09c-TSE-SOAArchitectureExtraction.pdf)

[2] Demeyer et al., [Object Oriented Reengineering Patterns](http://scg.unibe.ch/download/oorp/OORP.pdf), Chapter 1.2



## Symphony Provides a Structured Process for Recovery

[Symphony: View-Driven Software Architecture Reconstruction](https://ipa.win.tue.nl/archive/springdays2005/Deursen1.pdf)

- Classical, principled way
- View-driven approach
- Distinguishes between three kinds of *views*
    1. **Source**
	     - represents artifacts of a system directly
	     - not necessarily architectural (e.g. see later example)
    2. **Target**
	     - describes architecture-as-implemented
	     - e.g., module view, execution view, deployment view
    3. **Hypothetical**
	     - architecture-as-designed
	     - existing documentation, presentations



## Symphony Alternates Between Design and Execution Stages

![](images/symphony.png)



*2 min in pairs: think of a system you know — what would be the "problem elicitation" and "concept determination" for recovering its architecture?*

### Problem elicitation establishes the business case
- What is the problem?

![](images/symphony.png)



### Concept determination identifies needed viewpoints

- What architectural information is needed to solve the problem?
- **Which viewpoints are relevant?**

![](images/symphony.png)




### Data gathering extracts low-level source views
 - Can involve a multitude of sources even besides source code (e.g., git repo, runtime information)

![](images/symphony.png)



### Knowledge inference abstracts source into target views
 - Abstracting low-level information

![](images/symphony.png)


### Information interpretation produces documentation
 - Visual representation
 - Analysis, creating new documentation

![](images/symphony.png)


## Source Views Are Not Necessarily Architectural

Example: [Google Collab with Basic Data Gathering](https://colab.research.google.com/drive/1oe_TV7936Zmmzbbgq8rzqFpxYPX7SQHP#scrollTo=0ruTtX88Tb-w)



## Course Roadmap

| Week | Topic |
|------|-------|
| 1 | **Introduction** — what, why, and how (today) |
| 2 | **Abstraction & Visualization** — from raw data to architectural views |
| 3 | **Evolutionary Analysis** — what version control reveals |
| 4 | **Dynamic Analysis** — observing the running system |




# Individual Assignment


## Goal

- **Recover the architecture of an existing system**

- Document the outcome in an **individual report**
	- the target reader is a developer who needs to take over the system and maintain it
	- brief (not more than 3–5 pages)
	- do not explain what Symphony does in the report; assume the reader knows it
	- focus on your results




## Case-Study Systems

1. The Zeeguu Project
	- [zeeguu.org](https://zeeguu.com) (invite code: zeeguu-preview)
	- Code:
		- Python Backend: [Zeeguu-API](https://github.com/zeeguu/API)
		- React Frontend: [Zeeguu-Web](https://github.com/zeeguu/web)
	- A [paper](https://github.com/zeeguu-ecosystem/CHI18-Paper/blob/master/!AsWeMayStudy--Preprint.pdf) about the system

or,

2. Another system that you know
	- if it has comparable complexity (>200 files)
	- you confirm with me about the appropriateness of the system


## Viewpoints

1. Module Viewpoint (**default**)
	- we will write example code snippets in Collab to support this
	- makes the most sense for the Zeeguu system

2. Other Viewpoints
	- you could look at the execution or deployment information
	- might make more sense for another system — the Zeeguu one is too simple (could be done together with the module)

## Tools

- Are important for recovery

- **If you can program**, this is your chance to build analysis tools over the upcoming lectures
	  - you can still code as a team — you only have to write the analysis on your own
	  - you don't have to use Collab

- **If you can't program**, you'll develop expertise in evaluating and combining existing analysis tools
	- the time programmers spend coding, you'll spend finding and comparing third-party tools




# For Next Week


## Reading
- [Symphony: View-Driven Software Architecture Reconstruction](https://ipa.win.tue.nl/archive/springdays2005/Deursen1.pdf)
	- (note: Symphony uses "reconstruction" — same thing as "recovery")


## Individual Project
- Start looking for a case study that you would like to analyze


## Practice
- [Google Collab with Basic Data Gathering](https://colab.research.google.com/drive/1oe_TV7936Zmmzbbgq8rzqFpxYPX7SQHP#scrollTo=0ruTtX88Tb-w)
	- Understand the code
	- Apply it on your own case study if you already have one
	- Can you complete the implementation of the import extractor with the missing part?
		- (consider using an AST parser to extract more precise dependencies)
		- what if an import is not at the beginning of the line?


## Questions & Feedback
- Use the anonymous [form](https://forms.gle/ADWfDZdKfPwdFG1D6)
- Or on Discord if it's of general interest
