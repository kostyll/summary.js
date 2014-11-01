// Generated by CoffeeScript 1.8.0
var Set, SummaryTool, intersect_safe, process_summary, test;

Set = function(initial_data) {
  var item, _i, _len;
  if (initial_data == null) {
    initial_data = null;
  }
  this.content = {};
  this.length = 0;
  if (initial_data) {
    for (_i = 0, _len = initial_data.length; _i < _len; _i++) {
      item = initial_data[_i];
      this.add(item);
    }
  }
};

Set.prototype.add = function(item) {
  this.content[item] = true;
  this.length += 1;
};

Set.prototype.remove = function(item) {
  delete this.content[item];
  this.length -= 1;
};

Set.prototype.asArray = function() {
  var res, that, val, _i, _len, _ref;
  that = this;
  res = [];
  _ref = this.content;
  for (_i = 0, _len = _ref.length; _i < _len; _i++) {
    val = _ref[_i];
    console.log(val);
    res.push(val);
  }
  return res;
};

intersect_safe = function(a1, a2) {
  var ai, bi, result;
  ai = 0;
  bi = 0;
  result = new Array();
  while (ai < a1.length && bi < a2.length) {
    if (a1[ai] < a2[bi]) {
      ai++;
    } else if (a1[ai] > a2[bi]) {
      bi++;
    } else {
      result.push(a1[ai]);
      ai++;
      bi++;
    }
  }
  return result;
};

SummaryTool = function() {
  var that;
  that = this;
  that.split_content_to_sentences = function(content) {
    var result;
    content = content.split("\n").join(". ");
    result = content.split(". ");
    return result;
  };
  that.split_content_to_paragraphs = function(content) {
    return content.split("\n\n");
  };
  that.sentences_intersection = function(sent1, sent2) {
    var result, s1, s2;
    if (!sent1 || !sent2) {
      return 0;
    }
    if (typeof sent1 === "undefined" || typeof sent2 === "undefined") {
      return 0;
    }
    s1 = new Set(sent1.split(" "));
    s2 = new Set(sent2.split(" "));
    if ((s1.length + s2.length) === 0) {
      return 0;
    }
    result = intersect_safe(s1, s2).length / ((s1.length + s2.length) / 2);
    return result;
  };
  that.format_sentence = function(sentence) {
    var result;
    if (typeof sentence === "undefined") {
      return "";
    }
    result = sentence.replace(/\W+/g, '');
    return result;
  };
  that.get_sentences_ranks = function(content) {
    var i, j, n, num, row, score, sentences, sentences_dic, values, _i, _j, _k, _l;
    sentences = that.split_content_to_sentences(content);
    n = sentences.length;
    values = (function() {
      var _i, _results;
      _results = [];
      for (row = _i = 0; 0 <= n ? _i <= n : _i >= n; row = 0 <= n ? ++_i : --_i) {
        _results.push((function() {
          var _j, _results1;
          _results1 = [];
          for (num = _j = 0; 0 <= n ? _j <= n : _j >= n; num = 0 <= n ? ++_j : --_j) {
            _results1.push(0);
          }
          return _results1;
        })());
      }
      return _results;
    })();
    for (i = _i = 0; 0 <= n ? _i <= n : _i >= n; i = 0 <= n ? ++_i : --_i) {
      for (j = _j = 0; 0 <= n ? _j <= n : _j >= n; j = 0 <= n ? ++_j : --_j) {
        values[i][j] = that.sentences_intersection(sentences[i], sentences[j]);
      }
    }
    sentences_dic = {};
    for (i = _k = 0; 0 <= n ? _k <= n : _k >= n; i = 0 <= n ? ++_k : --_k) {
      score = 0;
      for (j = _l = 0; 0 <= n ? _l <= n : _l >= n; j = 0 <= n ? ++_l : --_l) {
        if (i === j) {
          continue;
        }
        score += values[i][j];
      }
      sentences_dic[that.format_sentence(sentences[i])] = score;
    }
    return sentences_dic;
  };
  that.get_best_sentence = function(paragraph, sentences_dic) {
    var best_sentence, max_value, s, sentences, strip_s, _i, _len;
    sentences = that.split_content_to_sentences(paragraph);
    if (sentences.length < 2) {
      return "";
    }
    best_sentence = "";
    max_value = 0;
    for (_i = 0, _len = sentences.length; _i < _len; _i++) {
      s = sentences[_i];
      strip_s = that.format_sentence(s);
      if (strip_s) {
        if (sentences_dic[strip_s] > max_value) {
          max_value = sentences_dic[strip_s];
          best_sentence = s;
        }
      }
    }
    return best_sentence;
  };
  that.get_summary = function(title, content, sentences_dic) {
    var p, paragraphs, sentence, summary, _i, _len;
    paragraphs = that.split_content_to_paragraphs(content);
    summary = [];
    summary.push(title.trim());
    summary.push("");
    for (_i = 0, _len = paragraphs.length; _i < _len; _i++) {
      p = paragraphs[_i];
      sentence = that.get_best_sentence(p, sentences_dic).trim();
      if (sentence) {
        summary.push(sentence);
      }
    }
    return summary.join("\n");
  };
  return that;
};

test = function() {
  var content, sentences_dic, st, summary, title;
  title = "Swayy is a beautiful new dashboard for discovering and curating online content [Invites]";
  content = "Lior Degani, the Co-Founder and head of Marketing of Swayy, pinged me last week when I was in California to tell me about his startup and give me beta access. I heard his pitch and was skeptical. I was also tired, cranky and missing my kids – so my frame of mind wasn’t the most positive.\n\nI went into Swayy to check it out, and when it asked for access to my Twitter and permission to tweet from my account, all I could think was, “If this thing spams my Twitter account I am going to bitch-slap him all over the Internet.” Fortunately that thought stayed in my head, and not out of my mouth.\n\nOne week later, I’m totally addicted to Swayy and glad I said nothing about the spam (it doesn’t send out spam tweets but I liked the line too much to not use it for this article). I pinged Lior on Facebook with a request for a beta access code for TNW readers. I also asked how soon can I write about it. It’s that good. Seriously. I use every content curation service online. It really is That Good.\n\nWhat is Swayy? It’s like Percolate and LinkedIn recommended articles, mixed with trending keywords for the topics you find interesting, combined with an analytics dashboard that shows the trends of what you do and how people react to it. I like it for the simplicity and accuracy of the content curation. Everything I’m actually interested in reading is in one place – I don’t have to skip from another major tech blog over to Harvard Business Review then hop over to another major tech or business blog. It’s all in there. And it has saved me So Much Time\n\nAfter I decided that I trusted the service, I added my Facebook and LinkedIn accounts. The content just got That Much Better. I can share from the service itself, but I generally prefer reading the actual post first – so I end up sharing it from the main link, using Swayy more as a service for discovery.\n\nI’m also finding myself checking out trending keywords more often (more often than never, which is how often I do it on Twitter.com).\n\nThe analytics side isn’t as interesting for me right now, but that could be due to the fact that I’ve barely been online since I came back from the US last weekend. The graphs also haven’t given me any particularly special insights as I can’t see which post got the actual feedback on the graph side (however there are numbers on the Timeline side.) This is a Beta though, and new features are being added and improved daily. I’m sure this is on the list. As they say, if you aren’t launching with something you’re embarrassed by, you’ve waited too long to launch.\n\nIt was the suggested content that impressed me the most. The articles really are spot on – which is why I pinged Lior again to ask a few questions:\n\nHow do you choose the articles listed on the site? Is there an algorithm involved? And is there any IP?\n\nYes, we’re in the process of filing a patent for it. But basically the system works with a Natural Language Processing Engine. Actually, there are several parts for the content matching, but besides analyzing what topics the articles are talking about, we have machine learning algorithms that match you to the relevant suggested stuff. For example, if you shared an article about Zuck that got a good reaction from your followers, we might offer you another one about Kevin Systrom (just a simple example).\n\nWho came up with the idea for Swayy, and why? And what’s your business model?\n\nOur business model is a subscription model for extra social accounts (extra Facebook / Twitter, etc) and team collaboration.\n\nThe idea was born from our day-to-day need to be active on social media, look for the best content to share with our followers, grow them, and measure what content works best.\n\nWho is on the team?\n\nOhad Frankfurt is the CEO, Shlomi Babluki is the CTO and Oz Katz does Product and Engineering, and I [Lior Degani] do Marketing. The four of us are the founders. Oz and I were in 8200 [an elite Israeli army unit] together. Emily Engelson does Community Management and Graphic Design.\n\nIf you use Percolate or read LinkedIn’s recommended posts I think you’ll love Swayy.\n\n➤ Want to try Swayy out without having to wait? Go to this secret URL and enter the promotion code thenextweb . The first 300 people to use the code will get access.\n\nImage credit: Thinkstock\n";
  st = SummaryTool();
  sentences_dic = st.get_sentences_ranks(content);
  summary = st.get_summary(title, content, sentences_dic);
  console.log(summary);
  console.log("");
  console.log("Original length ");
  console.log(title.length + content.length);
  console.log("summary length ");
  console.log(summary.length);
  console.log("summary ratio");
  return console.log(100 - (100 * (summary.length / (title.length + content.length))));
};

process_summary = function(title, content) {
  var efficiency, sentences_dic, st, summary;
  st = SummaryTool();
  sentences_dic = st.get_sentences_ranks(content);
  summary = st.get_summary(title, content, sentences_dic);
  efficiency = 100 - (100 * (summary.length / (title.length + content.length)));
  return {
    summary: summary,
    efficiency: efficiency
  };
};