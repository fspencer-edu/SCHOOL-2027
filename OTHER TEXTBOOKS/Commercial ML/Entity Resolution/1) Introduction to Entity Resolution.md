# What Is Entity Resolution?

- Entity resolution is a key analytic technique to identify data records that refer to the same real-world entity
- Removal of duplicate entries within a single source
- Build rich and comprehensive data assets
	- Healthcare providers
	- Financial services
	- Customer databases
# Why Is Entity Resolution Needed?

- Creating a comprehensive view of a customer
- Mergers and acquisitions
# Main Challenges of Entity Resolution

## Lack of Unique Names

- Recognizing uniqueness between names or labels

## Inconsistent Naming Conventions

- Names are recorded in a variety of ways and data structures
	- Full
	- Abbreviations

## Data Capture Inconsistencies

- Some data acquisition processes with employ some characters only
	- Mistyped
	- Different conventions
	- Transliteration
## Worked Example

- High cardinality
	- Large number of potential values
- Composite structure
- Possess more than one value
- Identifier may be recorded in a variety of formats
	- Spaces
	- Hyphens
- Include or exclude an international dialling prefix

## Deliberate Obfuscation

- Data inconsistencies arise from inattentive data capture processes

## Match Permutations

- Deduplicate a list
	- First name against the remaining

## Blind Matching?

- Some data is not available
	- Privacy constraints
	- Geopolitical factors

# The Entity Resolution Process

1) Data standardization
2) Record blocking
3) Attribute comparison
4) Match classification

- Clustering
- Canonicalization

## Data Standardization

- Ensure consistent data structures to test for equivalence between attributes
- Ensure that the formatting of attributes is consistent
- Splitting fields and removing null values and extra characters
## Record Blocking

- Blocking
	- Only subsets of record pairs, preselected based on ready equivalence between certain attributes, are compared in their entirety
- Concentrates the resolution process on those records with the highest propensity to match
## Attribute Comparison

- Process of comparing individual attributes between the pairs of records selected by the blocking process occurs next

## Match Classification

- Conclude whether the collective similarity between individual attributes is sufficient to declare two records to mate
	- Resolve that they refer to the same real-world entity
- Manually defined rules
- Machine learning probabilistic approach
## Clustering

- Group records into connected clusters via their matching pairs
- Inclusion or a record pair in a cluster is determined by a match confidence threshold
- If matching criteria allow for different equivalence criteria, then cluster may be intransitive
	- Record A may be paired ith B, and B with C, but C not with A
	- Clusters may be highly interconnected or more loosely coupled

## Canonicalization

- Determine which attribute values should be used to represent an entity
- Decide which value is the most representative
- Canonical attribute value is used to describe the resolved entity on onward calculations

## Worked Example

- Standardize data
	- Splitting the name attribute
	- Standardizing the data of birth
	- Remove extra characters in phone field
- Compare individual attributes for exact matches
- Determine if there is an overall match
	- Majority of the attributes match
	- Various combinations of matching attributes to be sufficient
- Relative weighting
	- Different attributes are worth more
	- Combining weighted scores produces an overall match scores that can be considered against a confidence threshold
- Probabilistic approach
	- Values of a categorical attribute are significantly more common than others
# Measuring Performance

- Recall
	- Measures how many actual positives the model correctly identifies
	- Ratio of true matches to the total match population

$Recall = \frac{TP}{TP+FP}$


- Precision
	- Measures how may predicted positives are actually correct
	- The ratio of true matches to the total declared matches

$Precision = \frac{TP}{TP+FP}$