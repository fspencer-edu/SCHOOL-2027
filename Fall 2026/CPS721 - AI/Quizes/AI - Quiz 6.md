```prolog
1. S -> NP VP
2. VP -> copula_verb Mods
3. VP -> transitive verb NP Mods
4. VP -> intrasitive verb Mods
5. NP -> proper_noun Mods
6. NP -> article NP2
7. NP2 -> adjective NP2
8. NP2 -> common_Noun Mods
9. Mods -> []
10. Mods -> PP Mods
11. PP -> preposition NP
```


```prolog
NP - the little brick near a cube with a blue pyramid
Modify the cube
The brick is near a cube, and the brick is with a blue pyramid.

NP (6)
    article -> the
    NP2 (7)
        adjective -> little
        NP2 (8)
            common_noun -> brick
            Mods (10)
                PP (11)
                    preposition -> near
                    NP (6)
                        article -> a
                        NP2 (8)
                            common_noun -> cube
                            Mods (10)
                                PP (11)
                                    preposition -> with
                                    NP (6)
                                        article -> a
                                        NP2 (7)
                                            adjective -> blue
                                            NP2 (8)
                                                common_noun -> pyramid
                                                Mods -> []
                                Mods -> []
                Mods -> []
```

```prolog
NP - the little brick near a cube with a blue pyramid
Modify the brick
The brick is near a cube, and the cube is with a blue pyramid.

NP (6)
    article -> the
    NP2 (7)
        adjective -> little
        NP2 (8)
            common_noun -> brick
            Mods (10)
                PP (11)
                    preposition -> near
                    NP (6)
                        article -> a
                        NP2 (8)
                            common_noun -> cube
                            Mods -> []
                Mods (10)
                    PP (11)
                        preposition -> with
                        NP (6)
                            article -> a
                            NP2 (7)
                                adjective -> blue
                                NP2 (8)
                                    common_noun -> pyramid
                                    Mods -> []
                    Mods -> []
```


```prolog
I shot a elephant in my pajamas
Modify I (I am wearing the pajamas)

S (1)
    NP (5)
        proper_noun -> I
    VP (3)
        transitive_verb -> shot
        NP (6)
            article -> an
            NP2 (8)
                common_noun -> elephant
                Mods -> []
        Mods (10)
            PP (11)
                preposition -> in
                NP (6)
                    article -> my
                    NP2 (8)
                        common_noun -> pajamas
                        Mods -> []
            Mods -> []
```

The prepositional phrase `in my pajamas` attaches to the **VP Mods**, not the elephant's NP.

```prolog
I shot a elephant in my pajamas (modify elephant)
Modify elephant (the elephant is wearing the pajamas)

S (1)
    NP (5)
        proper_noun -> I
    VP (3)
        transitive_verb -> shot
        NP (6)
            article -> an
            NP2 (8)
                common_noun -> elephant
                Mods (10)
                    PP (11)
                        preposition -> in
                        NP (6)
                            article -> my
                            NP2 (8)
                                common_noun -> pajamas
                                Mods -> []
                    Mods -> []
        Mods -> []
```

The prepositional phrase `in my pajamas` attaches to the **NP2 Mods** of `elephant`, not the VP.



| Term                          | Meaning                                                            | Examples                     |
| ----------------------------- | ------------------------------------------------------------------ | ---------------------------- |
| **Proper noun**               | The specific name of a person, place, or thing                     | John, Mary, Toronto, Canada  |
| **Common noun**               | A general name for a person, place, thing, or concept              | dog, student, city, book     |
| **Adjective**                 | Describes a noun                                                   | big, red, happy, intelligent |
| **Article**                   | Introduces a noun                                                  | a, an, the                   |
| **Transitive verb**           | A verb that requires a direct object (NP) in this grammar          | eats, sees, likes, reads     |
| **Intransitive verb**         | A verb that does not require a direct object                       | sleeps, runs, laughs, walks  |
| **Copula verb**               | A linking verb connecting the subject to a description or identity | is, am, are, was             |
| **Preposition**               | Shows a relationship involving location, time, direction, etc.     | in, on, at, with, under      |
| **Noun Phrase (NP)**          | A proper noun or group of words functioning as a noun              | John, the big dog            |
| **Verb Phrase (VP)**          | A verb and associated words                                        | sleeps, eats an apple        |
| **Prepositional Phrase (PP)** | A preposition followed by a noun phrase                            | in the park, with Mary       |
| **Modifiers (Mods)**          | Optional phrases that add information                              | in the park, with a friend   |