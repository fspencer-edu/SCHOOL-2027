From beginning to end, the **Full Pipeline** should work like this:

```
1. GUI / Pipeline page
   ↓
2. Run setup procedure
   ↓
3. Build / refresh lmimx_log queue
   ↓
4. Select eligible PART_IDs
   ↓
5. For each PART_ID:
      mark RUNNING
      ↓
      call input procedure(PART_ID)
      ↓
      input procedure rebuilds/populates mx.lmimx
      ↓
      range preparation / validation
      ↓
      snapshot mx.lmimx into cache_pipeline
      ↓
      discover fixed slices (usually T_ID values)
      ↓
      for each slice:
          CPU prepare
          ↓
          GPU SQL-parity estimation
          ↓
          validate convergence
          ↓
          write converged rows to mx.lmimx_gpu_result
      ↓
      wait for all async writes
      ↓
      call configured output procedure(PART_ID)
      ↓
      output procedure reads mx.lmimx_gpu_result
      ↓
      output procedure writes its own final destination table
      ↓
      output procedure updates relevant estimated flags
      ↓
      staging table is cleared
      ↓
      mark PART_ID COMPLETE
   ↓
6. Move to next PART_ID
   ↓
7. Pipeline complete
```

## 1. Setup

The selected setup procedure is source/workflow-specific.

For example:

```
LEU
lfs.subLFS3m3xPR_lmimx_leu_setup
```

or:

```
WH
lfs.subLFS3m3xPR_lmimx_wh_setup
```

Its job is to determine which `PART_ID`s have work and populate the generic queue:

```
mx.lmimx_log
```

The solver itself does not determine business-specific eligibility.

---

## 2. Pipeline queue

Python reads:

```
mx.lmimx_log
```

and determines:

```
pending
running
complete
failed
```

The physical source may have 50 partitions:

```
p0 ... p49
```

but only partitions with actual eligible work should be sent through the production solver.

So conceptually:

```
50 source partitions

        ↓ setup

25 pending
1 running
24 no work
```

The log is **production state**.

It belongs only to the Full Pipeline, not START GPU.

---

## 3. Start a PART_ID

Suppose:

```
PART_ID = 3
```

Python marks:

```
PART_ID=3
Status=RUNNING
```

before beginning the production work.

That ensures a failure during input/snapshot/solve/output can later mark the partition:

```
FAILED
```

instead of leaving it looking pending.

---

## 4. Input procedure

Then Python calls the selected source-specific input procedure:

```
LEU:
subLFS3m3xPR_lmimx_leu_input(3)

WH:
subLFS3m3xPR_lmimx_wh_input(3)
```

The purpose of every input procedure should be:

```
source-specific tables
        ↓
generic matrix representation
        ↓
mx.lmimx
```

So regardless of whether you're doing LEU or WH, the GPU always receives the same generic structure:

```
mx.lmimx
mx.lmimx_dim
mx.lmimxframe
```

This is the key abstraction.

---

# 5. Input constructs `mx.lmimx`

`mx.lmimx` contains the normalized matrix rows.

For example:

```
I_ID   I_LVL
G_ID   G_LVL
T_ID   T_LVL
A_ID   A_LVL
L_ID   L_LVL

ValRaw
ValMin
ValMax
ValEst
```

The actual dimensions can vary; Python discovers them dynamically.

The input procedure also supplies/rebuilds whatever structure the range procedure needs.

---

# 6. Range calculation

Before iterative estimation, the ranges need to be valid.

This corresponds to the original SQL:

```
mx.sublmimx_range(...)
```

Its job is primarily to tighten:

```
ValMin
ValMax
```

according to parent/child restrictions.

A core rule is:

\[ ChildMax = \min( ChildMax,\; ParentMax-\sum ChildMin+OwnMin ) \]

and special zero parents can force unknown descendants to zero.

This is **constraint preparation**, not the final estimation.

So:

```
raw input
   ↓
range logic
   ↓
feasible-ish Min/Max envelope
```

---

# 7. Snapshot production input

Once `mx.lmimx` belongs to the selected `PART_ID`, Python creates a fresh immutable snapshot under:

```
backend/cache_pipeline/
```

The production flow should always be:

```
input procedure
→ fresh mx.lmimx
→ fresh production snapshot
```

not:

```
old cache
→ maybe current data
```

That prevents stale partitions from getting mixed together.

The snapshot contains:

```
matrix rows
fixed slice metadata
hierarchy definitions
row counts
frame signature
```

---

# 8. Discover slices

Your current matrix has `T` as a fixed/slice dimension.

So one PART_ID can contain several:

```
T_ID
```

values.

For example:

```
PART_ID=3

T=2014500
T=2023250
...
```

Python identifies each one as a separate solve.

So:

```
PART_ID
   ↓
slice 1: T=x
slice 2: T=y
slice 3: T=z
```

---

# 9. Build the matrix problem

For each slice, Python reads the snapshot and constructs:

```
KEY rows
CHILD groups
PARENT groups
hierarchy relationships
tree definitions
```

The important structure is:

```
KEY
 ↓
CHILD
 ↓
PARENT
```

where KEY represents the lowest-level/base cells.

Python precomputes mappings instead of having MariaDB repeatedly do:

```
JOIN
GROUP BY
UPDATE
```

during every iteration.

---

# 10. CPU preparation

Before the GPU receives a slice, the CPU prepares:

```
arrays
group indices
tree mappings
Min/Max
ValEst
KEY→CHILD maps
CHILD→PARENT maps
```

The performance pipeline can overlap this.

While:

```
GPU solves T(n)
```

the CPU can prepare:

```
T(n+1)
```

---

# 11. GPU estimation

This is the replacement for the slow original `submx_estimatemx` loop.

For one slice:

```
I_ID=1
    ↓
tree 1
tree 2
tree 3
...
tree 90
    ↓
calculate CHECKDIFF

I_ID=2
    ↓
repeat
```

The solver tries to follow the same SQL calculation order.

---

# 12. What happens inside each tree

For each tree, the solver roughly does:

```
1. Move estimates off exact Min/Max boundaries

2. Aggregate KEY values to CHILD level

3. Aggregate CHILD values to PARENT level

4. Decide whether:
   KEY total is valid
   CHILD total is valid
   CHILD is too low
   CHILD is too high

5. Perform proportional/fixed-floating redistribution

6. Push the resulting CHILD targets back into KEY estimates

7. Calculate that tree's Diff_AMT
```

KEY/base rows remain the authoritative solution.

---

# 13. SQL-style convergence

For each parent group:

\[ Violation = \max( ParentMin-KeyTotal,\; KeyTotal-ParentMax,\; 0 ) \]

Then for each tree:

\[ Diff\_AMT = ROUND\left( \sum Violation, 1 \right) \]

Then across all trees:

\[ CHECKDIFF = \max(Diff\_AMT) \]

Your threshold is:

```
MX_THRESHOLD=0.1
```

So the slice converges when:

```
every tree Diff_AMT <= 0.1
```

The outer loop stops then, or at:

```
MX_MAX_ITERATIONS=500
```

as the safety ceiling.

---

# 14. Slice validation

A low `CHECKDIFF` alone should not blindly publish.

The current design also checks that the final state is valid.

So:

```
solver converged
AND
final validation passed
AND
full tree set used
```

Only then is the slice eligible for production output.

If a slice doesn't converge:

```
PART_ID fails
output procedure is NOT called
```

---

# 15. Write to `mx.lmimx_gpu_result`

For production, each converged slice is written to the shared staging table:

```
mx.lmimx_gpu_result
```

This table is generic.

It should **not change between LEU and WH**.

So every workflow uses:

```
GPU result
   ↓
mx.lmimx_gpu_result
```

The result writer can run asynchronously.

So the waterfall is:

```
CPU prepare next slice
        ||
GPU solve current slice
        ||
MariaDB writes previous result
```

---

# 16. Publication barrier

Before calling the output procedure, Python does:

```
writer.drain()
```

That means:

> wait until every GPU result row for the current PART_ID has finished committing to `mx.lmimx_gpu_result`.

Only after that should output begin.

---

# 17. Output procedure

Then Python calls the configured output procedure.

For LEU:

```
subLFS3m3xPR_lmimx_leu_output(PART_ID)
```

For WH:

```
subLFS3m3xPR_lmimx_wh_output(PART_ID)
```

Every output procedure should use:

```
FROM mx.lmimx_gpu_result
```

but it decides where the final result goes.

For example:

```
LEU output
mx.lmimx_gpu_result
   ↓
lfs.<LEU final table>
```

and:

```
WH output
mx.lmimx_gpu_result
   ↓
lfs.<WH final table>
```

So if your desired names are:

```
LEU → lfs.lmimx
WH  → lfs.lmimx_wh
```

that belongs inside the stored procedures.

Python does **not** need special logic for those destination table names.

---

# 18. Estimated flags

The output procedure can also update the source/import status.

For example:

```
LEUEstimatedFlag = 1
```

or whatever flag belongs to the WH workflow.

That update needs to be scoped to the current:

```
PART_ID
```

so one output run doesn't mark dates belonging to another partition.

---

# 19. Clear staging

Once the output procedure has consumed the staging rows:

```
mx.lmimx_gpu_result
```

it can clear/truncate them.

Then the staging table is ready for the next production PART_ID.

This is why production PART_IDs are processed sequentially with respect to the shared staging/output lifecycle.

---

# 20. Mark the PART_ID complete

Only after:

```
all slices converged
+
all result writes completed
+
output procedure succeeded
```

does Python update:

```
mx.lmimx_log
```

to:

```
COMPLETE
```

If anything fails:

```
input
snapshot
GPU
writer
output
```

then the PART_ID becomes:

```
FAILED
```

rather than `COMPLETE`.

---

# The complete production flow

So in one diagram:

```
SOURCE TABLES
    │
    ▼
configured setup procedure
    │
    ▼
mx.lmimx_log
PART_ID queue
    │
    ▼
PART_ID = RUNNING
    │
    ▼
configured input procedure(PART_ID)
    │
    ▼
mx.lmimx
generic matrix
    │
    ├── mx.lmimx_dim
    ├── mx.lmimxframe
    └── hierarchy structure
    │
    ▼
range preparation
ValMin / ValMax
    │
    ▼
fresh cache_pipeline snapshot
    │
    ▼
discover T slices
    │
    ▼
CPU build
KEY / CHILD / PARENT mappings
    │
    ▼
GPU SQL-parity estimator
    │
    ├── tree 1
    ├── tree 2
    ├── ...
    └── tree N
    │
    ▼
Diff_AMT per tree
    │
    ▼
CHECKDIFF = MAX(Diff_AMT)
    │
    ├── > threshold → next I_ID
    │
    └── <= threshold → converged
    │
    ▼
final validation
    │
    ▼
mx.lmimx_gpu_result
generic staging table
    │
    ▼
writer.drain()
    │
    ▼
configured output procedure(PART_ID)
    │
    ▼
procedure-specific final table

LEU → LEU destination
WH  → WH destination
etc.
    │
    ▼
update source estimated flag
    │
    ▼
clear staging
    │
    ▼
PART_ID = COMPLETE
    │
    ▼
next PART_ID
```

And the crucial design boundary is:

```
GENERIC

mx.lmimx
mx.lmimx_dim
mx.lmimxframe
GPU solver
mx.lmimx_gpu_result
```

versus:

```
WORKFLOW-SPECIFIC

setup procedure
input procedure
output procedure
source tables
final destination table
estimated/status flag
```

That separation means you can support LEU, WH, or another calculation later without changing the GPU solver itself—only the three configured SQL procedures need to know the source/output-specific details.