- Find matching entities by checking for exact matches between their data attributes
- Approximate (fuzzy) matching techniques
- Textural data
	- Look for similarities and differences between strings

# Edit Distance Matching

- Measure the edit distance between two strings
	- Minimum number of operations to transform one string into the other
	- Used to assess the likelihood that two strings describe the same attribute, if recorded differently

## Levenshtein Distance

- The Levenshtein distance is a well-known edit distance metric named after it creator
	- Soviet mathematician Vladimir Levenshtein.
- Calculates the minimum number of changes needed to transform on strings into another
	- Insert
	- Delete
	- Substitute
- Uses recursion

$a, b$ = stings being compared
$|a|$ = length of string $a$
$a[0]$ = first character of string $a$
$tail(0)$ = string $a$ without its first character
$lev(a, b)$ = edit distance between two strings
$min$ = smallest cost

- Given by $lev(a, b)$

<img src="/images/Pasted image 20261115194745.png" alt="image" width="500">

- Jellyfish
	- Python library for approximate and phonetic matching of strings

```python
%pip install jellyfish
import jellyfish as jf

jf.levenshtein_distance('Michael','Micheal')
2
```

- Iterates character by character through the characters of the two strings
- Increments the distance score, from first to last character

## Jaro Similarity

- Measure how similar two strings are based on the number of matching characters and how many of those characters are out of order
- Produces a score between 0 and 1

0 = completely different
1 = identical strings

- Matthew Jaro in 1989

<img src="/images/Pasted image 20261115195133.png" alt="image" width="500">

$|s_i|$ = length of the string $s_i$
$m$ = number of matching characters
$t$ = the number of transpositions

- Each character of $s_1$ is compared with all its matching characters in $s_2$
- If no matching characters are found, then the strings are not similar and the algorithm terminates with a similarity score of 0
- If non-zero matching characters are found, then the number of transpositions are found
	- Number of matching characters not in the right order divided by 2

```python
jf.jaro_similarity('Michael','Micheal')
0.9523809523809524
```

$|s_1| = |s_2| =7$
$m= 7$
$t = 1$

<img src="/images/Pasted image 20261115200717.png" alt="image" width="500">

- In both Levenshtein and Jaro all characters in a string contribute equally to the score
- First few characters are most significant

## Jaro-Winkler Similarity

- Uses a prefix scale $p$ that gives more favourable rating to strings that match from the beginning for a set prefix length $l$

$sim_w$ is $sim_w = sim_j + lp(1 − sim_j)$


```python
jf.jaro_winkler_similarity('Michael','Micheal')

0.9714285714285714

jf.jaro_winkler_similarity('michael','MICHAEL')
0

jf.jaro_winkler_similarity('michael'.lower(),'MICHAEL'.lower())
1.0
```

<img src="/images/Pasted image 20261115202045.png" alt="image" width="500">

# Phonetic Matching

- Compare how similar words are pronounced
- Based on English pronunciation
	- Metaphone
	- Match Rating Approach (MRA)
## Metaphone

- Encodes each word into sequence of letters from the set of “0BFHJKLMNPRSTWXY” where 0 represents the “th” sound and X represents “sh” or “ch.”
- Transformation produces a common key that can then be exact-matched to determine equivalence

```python
jf.metaphone('michael')
MXL
```

## Match Rating Approach

- Uses a set of rules to encode a word into a simplified phonetic representation

# Comparing the Techniques

- Compare the edit distance and phonetic similarity techniques

```python
mylist = ['Michael','Micheal','Michel','Mike','Mick']
combs = []

import itertools

for a, b in itertools.combinations(mylist, 2):
   combs.append([a,b,
      jf.jaro_similarity(a,b),
      jf.jaro_winkler_similarity(a, b),   
      jf.levenshtein_distance(a,b),
      jf.match_rating_comparison(a,b),
      (jf.metaphone(a)==jf.metaphone(b))])

pd.DataFrame(combs, columns=['Name1','Name2','Jaro','JaroWinkler','Levenshtein',
 'Match Rating','Metaphone'])
```

# Sample Problem

- Calculate the Jaro-Winkler similarity metric to compare the first names and last names between the two datasets

```python
df_w_un['Firstname_jaro'] = df_w_un.apply(
    lambda x: jf.jaro_winkler_similarity(x.Firstname_w, x.Firstname_t), axis=1)

df_w_un['Lastname_jaro'] = df_w_un.apply(
    lambda x: jf.jaro_winkler_similarity(x.Lastname_w, x.Lastname_t), axis=1)
```

- Apply threshold of 0.8 on both first and last name attribute
- Manually construct a joint dataset with every possible combination or records and then apply similarity function
- Discount combination with equivalence scores below a chosen threshold

# Full Similarity Comparison

- Generate all the record combinations using the cross-merge function
- Generates a row for every name combination between the datasets

```python
df_w = pd.read_csv('mps_wiki_clean.csv')
df_t = pd.read_csv('mps_they_clean.csv')
cross = df_w.merge(df_t, how='cross',suffixes=('_w', '_t'))
cross.head(n=5)

cross['Firstname_jaro'] = cross.apply(lambda x: True if 
    jf.jaro_winkler_similarity(x.Firstname_w, x.Firstname_t);0.8 
    else False, axis=1)

cross['Lastname_jaro'] = cross.apply(lambda x: True if 
    jf.jaro_winkler_similarity(x.Lastname_w, x.Lastname_t);0.8 
    else False, axis=1)

```

- Calculate the Jaro-Winkler Similarity metric for both first and last name on each row

```python
tp = cross[(cross['Firstname_jaro'] & cross['Lastname_jaro']) & 
    (cross['Constituency_w']==cross['Constituency_t'])]

len(tp)
634

fp = cross[(cross['Firstname_jaro'] & cross['Lastname_jaro']) & 
    (cross['Constituency_w']!=cross['Constituency_t'])]

len(fp)
19
```

- Examine the candidates rejected by examining where the constituency matches

# Measuring Performance

<img src="/images/Pasted image 20261115203539.png" alt="image" width="500">

```python
df_w['Firstname'].value_counts().mean()
1.8950437317784257

df_w['Lastname'].value_counts().mean()
1.1545293072824157
```

- Last name match is 64% more differentiating that a first name match
