#!/usr/bin/env python
"""Get multigraphs of consonants and vowels and their probabilities from a file of words.

@author: andreasl
"""

import json
import pathlib
import re
from typing import Dict, Set


def read_words(dictionary_path: pathlib.Path = "/usr/share/dict/words") -> Set[str]:
    """Read words from a dictionary file and retrieve the ones that only contain
    normal alphabet-multigraphs."""
    words = set()
    with open(dictionary_path) as file:
        for line in file.read().splitlines():
            if re.search(r"^[a-z]+$", line) is not None:
                words.add(line)
    return words


def _get_probabilities(words: Set[str], multigraph_set: Set[str]) -> Dict[str, float]:
    """Calculate the probablilities to the elements of the given multigraph set."""
    multigraphs_probabilities: Dict[str, float] = {}

    for multigraph in multigraph_set:
        count = sum(word.count(multigraph) for word in words)
        multigraphs_probabilities[multigraph] = count

    all_counts = sum(multigraphs_probabilities.values())
    for multigraph in multigraphs_probabilities:
        multigraphs_probabilities[multigraph] /= all_counts

    return multigraphs_probabilities


def get_matches(words: Set[str], regex: str) -> Set[str]:
    """Retrieve the matches and their probabilities from all given words."""
    multigraphs = set()
    for word in words:
        matches = re.findall(regex, word)
        [multigraphs.add(match) for match in matches]
    assert len(multigraphs) > 0
    return _get_probabilities(words, multigraphs)


if __name__ == "__main__":
    words = read_words()
    assert len(words) > 0

    start_consonants = get_matches(words, r"^[^aeiouy]+")
    start_vowels = get_matches(words, r"^[aeiouy]+")
    mid_consonants = get_matches(words, r"(?=[aeiouy]([^aeiouy]+)[aeiouy])")
    mid_vowels = get_matches(words, r"(?=[^aeiouy]([aeiouy]+)[^aeiouy])")
    end_consonants = get_matches(words, r"[^aeiouy]+$")
    end_vowels = get_matches(words, r"[aeiouy]+$")

    start = {"CONSONANT": start_consonants, "VOWEL": start_vowels}
    mid = {"CONSONANT": mid_consonants, "VOWEL": mid_vowels}
    end = {"CONSONANT": end_consonants, "VOWEL": end_vowels}

    print(f"start = {json.dumps(start, indent=4, sort_keys=True)}")
    print(f"mid = {(json.dumps(mid, indent=4, sort_keys=True))}")
    print(f"end = {(json.dumps(end, indent=4, sort_keys=True))}")
