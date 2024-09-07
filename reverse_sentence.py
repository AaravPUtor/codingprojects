def reverse_sentence(s: str) -> str:
    """
    Given a sentence <s>, we define a word within <s> to be a continuous
    sequence of characters in <s> that starts with a capital letter and
    ends before the next capital letter in the string or at the end of
    the string, whichever comes first. A word can include a mixture of
    punctuation and spaces. Reverses a string input <s> word by word,
    ensuring any special characters attached to the word are also
    reversed respectively


    >>> reverse_sentence('ATest string!')
    'A!gnirts tseT'
    """
    totalstr = ''
    word = ''
    for i in s:
        if i.isupper(): #f -> T
            if word != "": #T
                totalstr += word[::-1] # B
                word = ""
            word += i #T
        else:
            word += i #B -> Te

    if word != "":
        totalstr += word[::-1]

    return totalstr
