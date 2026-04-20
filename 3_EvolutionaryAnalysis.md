# III: Evolutionary Analysis for Architecture Recovery

Mircea Lungu (mlun@itu.dk) 

![400](images/heraclitus.png)

> *No man ever steps in the same river twice, for it is not the same river and he is not the same man.*

> -- Heraclitus


As opposed to life, in software we record the changes. Can we use them for something? Can we use them for Architecture Recovery? The answer is in todays' lecture. 




# Software Evolution: The System Is Never Finished

Software evolution is **the continual development of a piece of software after its initial release to address changing stakeholder requirements**.

- It used to be called *software maintenance*
- Nowadays evolution is the preferred term because it highlights the fact that a software system is never *finished*


## Why Are Software Systems Never Finished? Lehman's E-Type Thesis

> *An e-type program that is used in a real-world environment must change, or become progressively less useful in that environment.* 
> 
> -- M. Lehman, *The Law of Continuing Change*

In the terminology of Lehman, the "e" in *e-type* stands for *embedded*. He meant, *embedded in the real world*. (A different usage than what we call now embedded systems.) Since the world changes, the system must change too.

Three forces drive the evolution of a software system: the **human context** of use, the **technical context** of the platform, and our own **evolving understanding** of the problem. 


### The Human Context Changes: Laws, Taxes, Regulations

To think about: *Do you have good examples of systems that had to change because the real world changed around them?* 

- the software that computes taxes in Denmark
- all the websites in Europe once GDPR came into being
- etc. 

### The Technical Context Changes: Dependencies and Languages Keep Moving

![](assets/red-queen-quote.png)

#### Libraries and Languages Change Constantly — Fall Behind and Things Break

Libraries, frameworks, and programming languages all release new versions. Fall behind on your language version and upstream libraries eventually drop support for it — and your code stops working.

**Example — `npm audit`.** Run it on your React app on any given morning and a dozen of your dependencies have new versions. Do you upgrade? Stay pinned? There's no neutral choice — dependency management is a portfolio problem, not a one-time decision.



### Our Understanding of the Problem Changes: We Learn by Building

As we build a system, our understanding of the problem domain deepens. Users reveal what they actually meant. Edge cases that were invisible on day one become obvious on day ninety. Early abstractions that looked right turn out to be wrong in ways only visible in hindsight.

Every time the team learns something new about the problem, the system has to bend to match. This force is strongest while the domain model is still taking shape — which makes it the *dominant* driver of architectural change in young systems, or whenever a team enters a new domain.



## Architecture Evolves Too — and Not Only Through Drift

In Week 1 we talked about **drift** and **erosion** — the ways architecture degrades *unintentionally* over time. 

But architecture also evolves in the opposite direction: through **deliberate upgrades and redesigns**, as the team's understanding of the problem matures or the context shifts.

From this POV, the **architecture metaphor might not be the best** — because it makes us think about a fixed structure, as we normally have in building architecture. Although, even buildings are changing. 

Stewart Brand's *How Buildings Learn* shows this with examples: buildings are constantly adapted throughout their lives, and so are software systems.

![](images/how_buildings_learn.png)

*(Personally I'd push the metaphor further and call it a **garden** rather than a building — you have to constantly tend to it if you want to maintain it.)*

*If architecture evolves whether we track it or not, the question becomes: how do we stay aware of that evolution in time to shape it? We'll return to this at the end of today's lecture.*


# From Source to History: What VCS Tells Us About the Architecture

In Week 2 we extracted low-level dependencies from source code and abstracted them up into architecturally meaningful views. Today we apply the same pattern to a new source: the **version control history**. The low-level atoms are now **commits** — who changed what, when, with what message.

> Next week we extend this pattern once more, to the running system itself.

Three kinds of architecturally-relevant information can be recovered from a version control system:

1. **Implicit dependencies** — parts of the system that change together
2. **Living documentation** — *why* changes happened, recorded alongside the code and more likely to be up-to-date than separate architecture docs
3. **Architectural volatility** — which parts of the system are still being actively designed vs. which have settled


## Implicit Dependencies

### Logical Coupling: the parts of the system that always change together 

When two entities *frequently* change together, even if there is no explicit dependency between them, we call that between them there is **logical coupling**. 

This information can be inferred from the version control. The concept was introduced in 1998 in [a paper](https://plg.uwaterloo.ca/~migod/846/papers/gall-coupling.pdf) by Gall et al. has become quite popular in the meantime. 

Adam Tornhill has a tool that computes it and wrote a book about many of the concepts discussed in this course. Other tools that compute it exist. 

However, defining the concept is a challenge, because it's after all a matter of selecting thresholds and constants: 
- how many changes should two entities have together before we call them coupled?
- what percentage of changes can be not *together* while still allowing us to consider them coupled?

Pros

- language-independent method 
- can even detect dependencies between parts of the code that are not written in the same language
- can detect dependencies that are indirect 


Cons

- only a small part of the dependencies can be detected this way



## Living Documentation

### Commit Messages as Evolving Architecture Documentation

One of the beautiful insights I recently had is the importance of the git messages associated to commits as documentation. 

Indeed, even if there is no separate documentation, well described commits can serve as an evolving documentation for a software system. Look at the following commit comment, from linux, which documents a (+9, -4) change. How many of us are able to write such detailed changes?

![](images/commit-comment-in-linux.png)

However, the information in the git log could be useful for architecture recovery, only if the developers wrote meaningful messages. 








## Architectural Volatility

Churn reveals which parts of the system are architecturally **volatile** — still being actively designed, extended, or corrected — versus which have **settled** into a stable form. 

This matters because volatility concentrates bugs, complexity, and future effort.

### Extract: Churn as a Metric on Individual Code Entities

**[Churn](https://linearb.io/blog/what-is-code-churn/) is a metric that indicates how often a given piece of code gets edited.**
 - process metric (*as opposed to? do you remember the alternate concept? *)
 - can be detected with **language independent analysis** (which is good for *polyglot systems*)
 - can be applied to all kinds of code —e.g., a file, a class, a function—

**Why** would places in the system with **high-code churn** be relevant? 
- Studies observe correlation between code churn and complexity metrics [Shin et al. 2011]
- High *code churn* predicts buggy parts of the code better than just *size* [Nagappan & Ball 2005]
- It's likely that they'll require more effort in the future (e.g. yesterday's weather [Girba et al.])
- Are likely to be most important parts of the code if there is the most work done on them

#### Caveats When Using Churn

**Input — what goes into the churn calculation**

1. **Irrelevant files change frequently** (`README.md`, `LICENSE.md`, `package-lock.json`). You have to filter them out
	1. by combining with static complexity metrics to distinguish signal from noise
	2. by manual investigation
2. **File renames can break history.** Git sometimes loses track of file history — e.g. if you rename and modify in the same commit. Follow renames explicitly when aggregating.

**Measurement — how you count change on that input**

3. **Developer styles vary** — the micro-commits developer vs. the large-chunk committer. You could use LOC changed instead of commit count. (*What could the problems with this be?*)
4. **Time interval matters.** Weight recent changes more heavily — a module that churned wildly three years ago but is stable now is not a current hotspot.

### Abstract: Evolutionary Hotspots as an Architectural Viewpoint

Aggregating churn along the module hierarchy gives us an **evolutionary hotspots** view — an architectural viewpoint that highlights the code entities (modules, packages, subsystems) with the highest cumulative churn.

This is the same extract → abstract move we saw in Week 2: raw per-file measurements rolled up along the module hierarchy to produce something architecturally meaningful.

Notebook: [Abstracting Churn Along the Module Hierarchy in Python](https://colab.research.google.com/drive/1T4Hj12uD6h5Ody4ietooe5nW-yGFCoX9?usp=sharing)





# Embracing Evolution: Making Architectural Change Visible in Every PR

If architecture evolves whether we track it or not — and we've argued it does — then the practical question becomes: *how do we stay aware of that evolution in time to shape it?*

Traditional architecture documentation loses the race. By the time a diagram gets updated, the architecture has already moved on. Churn and hotspot analyses are retrospective — useful for understanding *what happened*, but too late to influence the decisions that produced the change.

## The Idea: Architectural Diff at Review Time

What if architectural change were surfaced at the same moment as the code change — in the pull request itself? Then reviewers can reason about architectural impact *alongside* the code diff, not after the fact. Deliberate evolution becomes the default. Accidental drift becomes visible the moment it's introduced.

![](assets/archlens-diff-at-pr-time.png)

![](assets/archlens-second-view-for-frienship-pr.png)
Example from [PR #517 to zeeguu/api](https://github.com/zeeguu/api/pull/517#issuecomment-4188532557)

## ArchLens as One Operationalization of the Idea

[ArchLens](https://github.com/archlens/ArchLens) — a tool we've been developing here at ITU — implements this approach. You define module views in a lightweight specification file; a GitHub Action generates an architectural diff for every PR and posts it as a comment. Over time, the PR history becomes an annotated record of how the architecture evolved — and why.

The broader goal: make architecture a **first-class artifact** in the development loop, not a stale document that occasionally gets refreshed.


# For Your Projects

## Consider enriching your architectural views with evolutionary signals
- **Churn** — highlight the architecturally volatile parts
- **Logical coupling** — surface implicit dependencies that static analysis missed
- **Commit messages** — mine them for architectural intent, especially where code-level docs are sparse

## Post your abstracted views in the new channel as you produce them
- Voluntary
- Seeing peer work helps — both for cross-pollination and for building a shared vocabulary across the class. 
- Also, I will provide feedback on the views in that channel 



# To Think About 
 

- **Non-e-type systems.** *Are there programs that are not impacted by the change in the world around them?* Candidates: a chess engine, a red-black tree balancing algorithm. One could argue this is the difference between *algorithms* and *software systems*: algorithms don't have to change with the world, software systems do. 

- **Socio-technical angle.** The same VCS data can reveal *who* knows what about the system, not just *where* change concentrates. See [Code Ownership and Truck Factor](code_ownership.md) for Git-Truck and the Avelino paper — related but outside today's architecture-recovery focus.

- What if you could replay the history of a system from the beginning but only showing those files that made it to the end. So project the beginnings through the perspective of the endings. Would that be a useful way of focusing on the most relevant aspects of the system? 

# References

[Detection of Logical Coupling Based on Product Release History](https://plg.uwaterloo.ca/~migod/846/papers/gall-coupling.pdf), by  Harald Gall, Karin Hajek, and Mehdi Jazayeri. 

[Laws of Software Evolution Revisited](http://labs.cs.upt.ro/labs/acs/html/resources/Lehman-2.pdf). M. M. Lehman

[Evaluating Complexity, Code Churn, and Developer Activity Metrics as Indicators of Software Vulnerabilities](https://repository.lib.ncsu.edu/bitstreams/772957fa-3b2f-4862-93d8-2d7889654f51/download). Y. Shin, A. Meneely, L. Williams, and J. A. Osborne. IEEE Transactions on Software Engineering, 2011. — Empirical study on Firefox and RHEL that directly compares complexity, churn, and developer-activity metrics.

[Use of Relative Code Churn Measures to Predict System Defect Density](https://www.microsoft.com/en-us/research/wp-content/uploads/2016/02/icse05churn.pdf). N. Nagappan and T. Ball. ICSE 2005. — The canonical paper showing that relative churn measures outperform size-based metrics for predicting defect density.

