# Translated from https://gist.github.com/shlomibabluki/5473521

Set = (initial_data=null) ->
    # that = @
    @content = {}
    @length = 0
    if initial_data
        # console.log "initial data is set"
        for item in initial_data
            @add(item)
    # console.log "Content"
    # console.log @content
    return

Set::add = (item) ->
    @content[item] = true
    @length += 1
    return

Set::remove = (item) ->
    delete @content[item]
    @length -= 1
    return

Set::asArray = ->
    that = @
    res = []
    for val in @content
        console.log(val)
        res.push(val)
    res

intersect_safe = (a1,a2) ->
    ai = 0
    bi = 0
    result = new Array()

    while ai < a1.length and bi < a2.length
        if a1[ai] < a2[bi]
            ai++
        else if a1[ai] > a2[bi]
            bi++
        else
            result.push a1[ai]
            ai++
            bi++
    result

SummaryTool = () ->

    that = @

    # Naive method for splitting a text into sentences
    that.split_content_to_sentences = (content) ->
        # content = content.split("\n\n").join(". ")
        content = content.split("\n").join(". ")
        result = content.split(". ")
        # console.log "split_content_to_sentences result ->"
        # console.log result
        result

    # Naive method for splitting a text into paragraphs
    that.split_content_to_paragraphs = (content) ->
        content.split("\n\n")

    # Caculate the intersection between 2 sentences
    that.sentences_intersection = (sent1,sent2) ->

        # console.log "Sent1"
        # console.log sent1
        # console.log "Sent2"
        # console.log sent2

        if !sent1 or !sent2
            return 0
        if typeof sent1 == "undefined" or typeof sent2 == "undefined"
            return 0
        # split the sentence into words/tokens
        s1 = new Set(sent1.split(" "))
        s2 = new Set(sent2.split(" "))

        # If there is not intersection, just return 0
        if (s1.length + s2.length) == 0
            return 0

        # We normalize the result by the average number of words
        result = (intersect_safe(s1,s2).length / ((s1.length+s2.length)/2))

        result

    # Format a sentence - remove all non-alphbetic chars from the sentence
    # We'll use the formatted sentence as a key in our sentences dictionary
    that.format_sentence = (sentence) ->
        # re = new RegExp ("\\W+")
        if typeof sentence == "undefined"
            return ""
        # console.log "sentence before format"
        # console.log sentence
        result = sentence.replace(/\W+/g,'')
        # console.log "sentence after format"
        # console.log result
        result

    # Convert the content into a dictionary <K, V>
    # k = The formatted sentence
    # V = The rank of the sentence
    that.get_sentences_ranks = (content) ->
        # Split the content into sentences
        sentences = that.split_content_to_sentences(content)
        # console.log "len Sentences"
        # console.log sentences.length
        # console.log "Done"

        # Calculate the intersection of every two sentences
        n = sentences.length

        values = ((0 for num in [0..n]) for row in [0..n])

        # console.log "values before = "
        # console.log values

        for i in [0..n]
            for j in [0..n]
                values[i][j] = that.sentences_intersection(sentences[i],sentences[j])

        # console.log "values after = "
        # console.log values

        # Build the sentences dictionary
        # The score of a sentences is the sum of all its intersection
        sentences_dic = {}

        for i in [0..n]
            score = 0
            for j in [0..n]
                if i == j
                    continue

                score += values[i][j]
            sentences_dic[that.format_sentence(sentences[i])] = score
        # console.log "Sentences dic"
        # console.log sentences_dic
        sentences_dic

    # Return the best sentence in a paragraph
    that.get_best_sentence = (paragraph,sentences_dic) ->

        # Split the paragraph into sentences
        sentences = that.split_content_to_sentences(paragraph)

        # Ignore short paragraphs
        if sentences.length < 2
            return ""

        # Get the best sentence according to the sentences dictionary
        best_sentence = ""
        max_value = 0

        for s in sentences
            strip_s = that.format_sentence(s)

            if strip_s
                if sentences_dic[strip_s] > max_value
                    max_value = sentences_dic[strip_s]
                    best_sentence = s

        return best_sentence

    # Build the summary
    that.get_summary = (title,content,sentences_dic) ->

        # Split the content into paragraphs
        paragraphs = that.split_content_to_paragraphs(content)

        # Add the title
        summary = []
        summary.push(title.trim())
        summary.push("")

        # Add the best sentence from each paragraph
        for p in paragraphs
            # console.log "Next paragraph"
            # console.log p
            sentence = that.get_best_sentence(p,sentences_dic).trim()
            if sentence
                summary.push(sentence)

        summary.join("\n")

    that


test = () ->

    title = """
    Swayy is a beautiful new dashboard for discovering and curating online content [Invites]
    """

    content = """
        Lior Degani, the Co-Founder and head of Marketing of Swayy, pinged me last week when I was in California to tell me about his startup and give me beta access. I heard his pitch and was skeptical. I was also tired, cranky and missing my kids – so my frame of mind wasn’t the most positive.

        I went into Swayy to check it out, and when it asked for access to my Twitter and permission to tweet from my account, all I could think was, “If this thing spams my Twitter account I am going to bitch-slap him all over the Internet.” Fortunately that thought stayed in my head, and not out of my mouth.

        One week later, I’m totally addicted to Swayy and glad I said nothing about the spam (it doesn’t send out spam tweets but I liked the line too much to not use it for this article). I pinged Lior on Facebook with a request for a beta access code for TNW readers. I also asked how soon can I write about it. It’s that good. Seriously. I use every content curation service online. It really is That Good.

        What is Swayy? It’s like Percolate and LinkedIn recommended articles, mixed with trending keywords for the topics you find interesting, combined with an analytics dashboard that shows the trends of what you do and how people react to it. I like it for the simplicity and accuracy of the content curation. Everything I’m actually interested in reading is in one place – I don’t have to skip from another major tech blog over to Harvard Business Review then hop over to another major tech or business blog. It’s all in there. And it has saved me So Much Time

        After I decided that I trusted the service, I added my Facebook and LinkedIn accounts. The content just got That Much Better. I can share from the service itself, but I generally prefer reading the actual post first – so I end up sharing it from the main link, using Swayy more as a service for discovery.

        I’m also finding myself checking out trending keywords more often (more often than never, which is how often I do it on Twitter.com).

        The analytics side isn’t as interesting for me right now, but that could be due to the fact that I’ve barely been online since I came back from the US last weekend. The graphs also haven’t given me any particularly special insights as I can’t see which post got the actual feedback on the graph side (however there are numbers on the Timeline side.) This is a Beta though, and new features are being added and improved daily. I’m sure this is on the list. As they say, if you aren’t launching with something you’re embarrassed by, you’ve waited too long to launch.

        It was the suggested content that impressed me the most. The articles really are spot on – which is why I pinged Lior again to ask a few questions:

        How do you choose the articles listed on the site? Is there an algorithm involved? And is there any IP?

        Yes, we’re in the process of filing a patent for it. But basically the system works with a Natural Language Processing Engine. Actually, there are several parts for the content matching, but besides analyzing what topics the articles are talking about, we have machine learning algorithms that match you to the relevant suggested stuff. For example, if you shared an article about Zuck that got a good reaction from your followers, we might offer you another one about Kevin Systrom (just a simple example).

        Who came up with the idea for Swayy, and why? And what’s your business model?

        Our business model is a subscription model for extra social accounts (extra Facebook / Twitter, etc) and team collaboration.

        The idea was born from our day-to-day need to be active on social media, look for the best content to share with our followers, grow them, and measure what content works best.

        Who is on the team?

        Ohad Frankfurt is the CEO, Shlomi Babluki is the CTO and Oz Katz does Product and Engineering, and I [Lior Degani] do Marketing. The four of us are the founders. Oz and I were in 8200 [an elite Israeli army unit] together. Emily Engelson does Community Management and Graphic Design.

        If you use Percolate or read LinkedIn’s recommended posts I think you’ll love Swayy.

        ➤ Want to try Swayy out without having to wait? Go to this secret URL and enter the promotion code thenextweb . The first 300 people to use the code will get access.

        Image credit: Thinkstock

    """

    st = SummaryTool()

    sentences_dic = st.get_sentences_ranks(content)

    # console.log "Sentences_dic"
    # console.log sentences_dic

    summary = st.get_summary(title,content,sentences_dic)

    console.log summary

    console.log ""
    console.log "Original length "
    console.log title.length+content.length

    console.log "summary length "
    console.log summary.length

    console.log "summary ratio"
    console.log (100 - (100 * (summary.length/(title.length+content.length))))


test()
